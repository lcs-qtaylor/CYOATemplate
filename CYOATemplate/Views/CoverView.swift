//
//  CoverView.swift
//  CYOATemplate
//
//  Created by Russell Gordon on 2024-06-02.
//

import SwiftUI

struct CoverView: View {
    
    // MARK: Stored properties
    
    // Access the book state through the environment
    @Environment(BookStore.self) var book
    
    // MARK: Computed properties
    var body: some View {
        ZStack {
            
            LinearGradient(colors: [.black, .red], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack {
                
                if book.isNotReadyToRead {
                    
                    ProgressView()
                    
                } else {
                    
                    // Show the cover
                    Text("Secrets in the Halls")
                        .font(Font.custom("Chalkduster", size: 50))
                        .foregroundColor(Color.red)
                    
                    Button("Begin The Adventure!") {
                        // Animate page changes (fade)
                        withAnimation {
                            book.beginReading()
                        }
                    }
                    .tint(.red)
                    .foregroundStyle(.black)
                    .font(Font.custom("Chalkduster", size: 20))
                    .buttonStyle(.borderedProminent)
                    
                   
                }
                
            }
            .padding()
        }
        
    }
}

#Preview {
    CoverView()
}
