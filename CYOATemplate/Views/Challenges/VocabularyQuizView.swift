//
//  VocabularyQuizView.swift
//  CYOATemplate
//
//  Created by Russell Gordon on 2024-06-03.
//

import SwiftUI

struct VocabularyQuizView: View {
    
    // MARK: Stored properties
    
    // Whether this view is showing in the sheet right now
    @Binding var showing: Bool
    
    // Whether the generated question was answered correctly or not
    @Binding var result: QuizResult
    
    // MARK: Computed properties
    var body: some View {
        NavigationStack {
            VStack {
                Button {
                    result = .wasCorrect
                    showing = false
                } label: {
                    Text("Simulate correct answer")
                }
                .buttonStyle(.borderedProminent)

                Button {
                    result = .wasNotCorrect
                    showing = false
                } label: {
                    Text("Simulate incorrect answer")
                }
                .buttonStyle(.borderedProminent)

            }
            .padding()
            .navigationTitle("Quiz time!")
        }
        .interactiveDismissDisabled()
    }
    
}

#Preview {
    VocabularyQuizView(
        showing: Binding.constant(true),
        result: Binding.constant(.wasCorrect)
    )
}
