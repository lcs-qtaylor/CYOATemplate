//
//  StatsView.swift
//  CYOATemplate
//
//  Created by Russell Gordon on 2024-06-02.
//

import SwiftUI

struct StatsView: View {
    
    // MARK: Stored properties
    
    // Whether this view is showing in the sheet right now
    @Binding var showing: Bool
    
    // MARK: Computed properties
    var body: some View {
        NavigationStack {
            VStack {
                Text("A total of x pages out of y pages overall have been visited in this story.")
            }
            .padding()
            .navigationTitle("Statistics")
            // Toolbar to show buttons for various actions
            .toolbar {
                
                // Hide this view
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
    StatsView(showing: Binding.constant(true))
}
