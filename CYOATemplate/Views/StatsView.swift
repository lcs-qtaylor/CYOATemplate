//
//  StatsView.swift
//  CYOATemplate
//
//  Created by Russell Gordon on 2024-06-02.
//
import SwiftUI

struct StatsView: View {
    
    // MARK: Stored properties
    @Binding var showing: Bool
    @Environment(BookStore.self) var book
    let viewModel: achievementViewModel
   
    // MARK: Computed properties
    var body: some View {
        @Bindable var book = book
        NavigationStack {
            VStack {
                if let achievements = viewModel.achievements {
                    if achievements.isEmpty {
                        Text("No achievements unlocked yet.")
                            .padding()
                    } else {
                        List(achievements) { achievement in
                            VStack(alignment: .leading) {
                                Text(achievement.name)
                                    .font(.headline)
                                Text(achievement.description)
                                    .font(.subheadline)
                            }
                            .padding()
                        }
                    }
                } else {
                    ProgressView()
                }
            }
            .padding()
            .navigationTitle("Statistics")
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button {
                        showing = false
                    } label: {
                        Text("Done")
                            .bold()
                    }
                }
            }
        }
    }
}

#Preview {
    StatsView(showing: .constant(true), viewModel: achievementViewModel(book: BookStore()))
}
