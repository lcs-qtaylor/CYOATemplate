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
    
    //primary color
    @State var primaryColor: Color = .black
    
    //secondary color
    @State var secondaryColor: Color = .red
    
    // MARK: Computed properties
    var body: some View {
        ZStack {
            
            LinearGradient(colors: [primaryColor, secondaryColor], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack {
                
                if book.isNotReadyToRead {
                    
                    ProgressView()
                    
                } else {
                    
                    // Show the cover
                    Text("Secrets in the Halls")
                        .font(Font.custom("Chalkduster", size: 50))
                        .foregroundColor(secondaryColor)
                    
                    Button("Begin The Adventure!") {
                        // Animate page changes (fade)
                        withAnimation {
                            book.beginReading()
                        }
                    }
                    .tint(secondaryColor)
                    .foregroundStyle(primaryColor)
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
