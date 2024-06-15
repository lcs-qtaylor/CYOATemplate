//
//  SettingsView.swift
//  CYOATemplate
//
//  Created by Russell Gordon on 2024-06-02.
//

import SwiftUI
import AVFoundation

struct SettingsView: View {
    
    // MARK: Stored properties
    @State var creepySoundEffect: AVAudioPlayer? = nil
    @State private var isMusicPlaying = true
    
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
            
            List {
                
                //Toggle for dark mode
                Toggle(isOn: $book.reader.prefersDarkMode) {
                    Label {
                        Text("Dark Mode")
                    } icon: {
                        Image(systemName: "moonphase.first.quarter")
                    }
                }
                Toggle("Music Off", isOn: $isMusicPlaying)
                    .onChange(of: isMusicPlaying) { newValue, _ in
                        if newValue {
                            // Play the sound
                            if let path = Bundle.main.path(forResource: "scary-ambience-5-traullis-215938.mp3", ofType: nil) {
                                let url = URL(fileURLWithPath: path)
                                
                                do {
                                    creepySoundEffect = try AVAudioPlayer(contentsOf: url)
                                    creepySoundEffect?.play()
                                } catch {
                                    // Handle error
                                    print("Couldn't load audio file:", error)
                                }
                            } else {
                                print("Audio file not found")
                            }
                        } else {
                            // Stop the sound
                            creepySoundEffect?.stop()
                        }
                    }
                
                
                // Dropdown picker for font size
                HStack {
                    Text("Font Size:")
                    
                    Spacer()
                    
                    Picker("Size", selection: $book.reader.fontSize) {
                        ForEach(fontSizes, id: \.self) { size in
                            Text("\(size)").tag(size)
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                //color picker for primary
                ColorPicker("Select Primary Colour", selection: $book.primaryColor, supportsOpacity: false)
                
                //color picker for secondary
                ColorPicker("Select Secondary Colour", selection: $book.secondaryColor, supportsOpacity: false)
                
            }
            .listStyle(.plain)
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
