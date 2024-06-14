//
//  GameView.swift
//  CYOATemplate
//
//  Created by Russell Gordon on 2023-05-29.
//

import Supabase
import SwiftUI

struct BookView: View {
    
    // MARK: Stored properties
    // Tracks overall state as the reader reads the book
    @Environment(BookStore.self) var book
    // Whether the statistics view is being shown right now
    @State private var showingStatsView = false

    // Whether the settings view is being shown right now
    @State private var showingSettingsView = false
    // Track when app is foregrounded, backgrounded, or made inactive
    @Environment(\.scenePhase) var scenePhase


    // MARK: Computed properties
    var body: some View {
        
        NavigationStack {
            
            VStack {
                
                if book.isBeingRead {
                    
                    //                    HStack {
                    //                        Text("\(book.currentPageId!)")
                    //                            .font(.largeTitle)
                    //                        Spacer()
                    //                    }
                    //                    .padding()
                    
                    PageView(
                        viewModel: PageViewModel(book: book)
                    )
                    
                } else {
                    CoverView()
                }
                
            }
            // Add our object to track state into the environment
            // so it is accessible to the other views in the app
//            .environment(book)
            // Toolbar to show buttons for various actions
            .toolbar {
                
                // Button to return to the cover page
                ToolbarItem(placement: .automatic) {
                    Image(systemName: "arrow.left.circle")
                        .foregroundColor(book.secondaryColor)
                        .onTapGesture {
                            book.showCoverPage()
                        }
                }
                
                // Show the statistics view
                ToolbarItem(placement: .automatic) {
                    Button {
                        showingStatsView = true
                    } label: {
                        Image(systemName: "chart.pie.fill")
                            .foregroundColor(book.secondaryColor)
                    }
                    
                }
                
                // Show the settings view
                ToolbarItem(placement: .automatic) {
                    Button {
                        showingSettingsView = true
                    } label: {
                        Image(systemName: "gear")
                            .foregroundColor(book.secondaryColor)
                    }
                    
                }
            }
            // Show the statistics view
            .sheet(isPresented: $showingStatsView) {
                StatsView(showing: $showingStatsView, viewModel: achievementViewModel(book: book))

            }
            // Show the settings view
            .sheet(isPresented: $showingSettingsView) {
                SettingsView(showing: $showingSettingsView)
                // Make the book state accessible to SettingsView
                    .environment(book)
            }
            // Respond when app is backgrounded, foregrounded, or made inactive
            .onChange(of: scenePhase) {
                if scenePhase == .inactive {
                    print("Active")
                    Task {
                        try await book.saveState()
                        print("Reader's state for this book has been restored.")
                    }
                } else if scenePhase == .active {
                    print("Active")
                    Task {
                        try await book.restoreState()
                        print("Reader's state for this book has been restored.")
                    }
                } else if scenePhase == .background {
                    print("Background")
                }
            }
            
        }
        // Dark / light mode toggle
        .preferredColorScheme(book.reader.prefersDarkMode ? .dark : .light)
        
    }
}

#Preview {
    BookView()
}
