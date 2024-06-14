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
                

                  

     
                Toggle("Music off", isOn: $isMusicPlaying)
                           .onChange(of: isMusicPlaying) { newValue, _ in
                               if newValue {
                                   // Play the sound
                                   let path = Bundle.main.path(forResource: "scary-ambience-5-traullis-215938.mp3", ofType: nil)!
                                   let url = URL(fileURLWithPath: path)
                                   
                                   do {
                                       creepySoundEffect = try AVAudioPlayer(contentsOf: url)
                                       creepySoundEffect?.play()
                                   } catch {
                                       // Handle error
                                       print("Couldn't load audio file:", error)
                                   }
                               } else {
                                   // Stop the sound
                                   creepySoundEffect?.stop()
                               }
                           }

                
                
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
    }
    
}

#Preview {
    SettingsView(showing: Binding.constant(true))
}
