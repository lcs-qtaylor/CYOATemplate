//  AppEntryView.swift
//  CYOATemplate
//
//  Created by Russell Gordon on 2024-06-02.
//

import SwiftUI
import AVFoundation

class AudioPlayer: ObservableObject {
    var creepySoundEffect: AVAudioPlayer? = nil
}

struct AppEntryView: View {
    // MARK: Stored properties
    @StateObject var audioPlayer = AudioPlayer()
    @State var isAuthenticated = false
    
    // MARK: Computed properties
    var body: some View {
        Group {
            if isAuthenticated {
                BookView()
            } else {
                AuthView()
            }
        }
        .environmentObject(audioPlayer)
        .task {
            for await state in await supabase.auth.authStateChanges {
                if [.initialSession, .signedIn, .signedOut].contains(state.event) {
                    isAuthenticated = state.session != nil
                }
            }
        }
    }
}

#Preview {
    AppEntryView()
}
