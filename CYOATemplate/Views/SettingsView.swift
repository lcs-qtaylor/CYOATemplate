//
//  SettingsView.swift
//  CYOATemplate
//
//  Created by Russell Gordon on 2024-06-02.
//

import SwiftUI

struct SettingsView: View {
    
    // MARK: Stored properties
    
    // Whether this view is showing in the sheet right now
    @Binding var showing: Bool
    
    // Access the book state through the environment
    @Environment(BookStore.self) var book
    
    // Available font sizes
    let fontSizes: [Int] = Array(10...50)
    
    // MARK: Computed properties
    var body: some View {
        
        // Make the connection to the book state a two-way binding
        // (By default when accessing through environment it is read-only)
        @Bindable var book = book
        
        // The user interface
        return NavigationStack {
            
            VStack {
                Toggle(isOn: $book.reader.prefersDarkMode) {
                    Label {
                        Text("Dark Mode")
                    } icon: {
                        Image(systemName: "moonphase.first.quarter")
                    }
                }
                
                // Dropdown picker for font size
                HStack {
                    Text("Font Size:")
                    Picker("Font Size", selection: $book.reader.fontSize) {
                        ForEach(fontSizes, id: \.self) { size in
                            Text("\(size)").tag(size)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(maxWidth: 100) // Adjust width as needed
                }
                .padding(.top, 10)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Settings")
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
        // Dark / light mode toggle
        .preferredColorScheme(book.reader.prefersDarkMode ? .dark : .light)
    }
}

#Preview {
    SettingsView(showing: Binding.constant(true))
}
