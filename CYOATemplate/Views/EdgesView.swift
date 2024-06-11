//
//  EdgesView.swift
//  CYOATemplate
//
//  Created by Russell Gordon on 2023-06-01.
//

import SwiftUI

struct EdgesView: View {

    // MARK: Stored properties

    // Access the book state through the environment
    @Environment(BookStore.self) var book
    
    // The view model for the page view
    //
    // Making the view model a constant means
    // when the page number changes in the BookStore class
    // (which is fed to the initializer of EdgesViewModel)
    // then EdgesView will be re-loaded, updating the text
    let viewModel: EdgesViewModel
    
    // Whether the challenge/quiz view is being shown right now
    @State private var showingQuizView = false
    
    // Whether the quiz question was answered correctly
    @State private var quizResult: QuizResult = .quizNotActive

    // MARK: Computed properties
    var body: some View {
        
        VStack(spacing: 20) {
            
            // Have edges loaded yet?
            if let edges = viewModel.edges {

                // Are there no edges for this page?
                // NOTE: This should not happen if database is populated correctly.
                if edges.isEmpty {
                    
                    HStack {
                        Spacer()
                        
                        Text("No edges found for page \(book.currentPageId!).")
                            .onTapGesture {
                                book.showCoverPage()
                            }
                    }

                } else {
                    
                    // Show the edges for this page
                    ForEach(edges) { edge in
                        HStack {
                            Spacer()
                            Text(
                                try! AttributedString(
                                    markdown: edge.prompt,
                                    options: AttributedString.MarkdownParsingOptions(
                                        interpretedSyntax: .inlineOnlyPreservingWhitespace
                                    )
                                )
                            )
                                .multilineTextAlignment(.trailing)
                        }
                        .onTapGesture {
                            
                            // DEBUG
                            print("Current page number is: \(book.currentPageId!)")
                            print("==== about to change page ====")
                            
                            if edge.prompt.contains("Turn to the next page") {
                                
                                if quizResult == .quizNotActive ||
                                    quizResult == .wasNotCorrect {
                                    showingQuizView = true
                                } else {
                                    
                                    // Question answered correctly, allow reader to move on
                                    book.read(edge.toPage)

                                }
                                
                            } else {

                                // Move to page edge connects to
                                // (No prompt for quiz on pages that have multiple options)
                                book.read(edge.toPage)

                            }
                            
                            // DEBUG
                            print("==== changed page ====")
                            print("New page number is: \(book.currentPageId!)")
                        }
                    }
                }

            } else {
                
                // Edges are loading from database
                ProgressView()
            }
                
        }
        // Show the quiz view
        .sheet(isPresented: $showingQuizView) {
            VocabularyQuizView(
                showing: $showingQuizView,
                result: $quizResult
            )
            .presentationDetents([.medium, .fraction(0.33)])
        }


    }
}

#Preview {
    EdgesView(
        viewModel: EdgesViewModel(book: BookStore())
    )
}
