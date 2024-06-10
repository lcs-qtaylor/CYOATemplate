//
//  WarningView.swift
//  CYOATemplate
//
//  Created by Justin Hui on 7/6/2024.
//

import SwiftUI

struct WarningView: View {
    
    // MARK: Stored properties
    
    // Access the book state through the environment
    @Environment(BookStore.self) var book
    
    // MARK: Computed properties
    var body: some View {
        
        VStack (spacing: 45){
            
            HStack{
                Text("Trigger Warning:")
                    .bold()
                    .font(.title)
                
            }
            
            
            Text("This story This app is a choose-your-own-adventure style experience that contains mature themes. Please be aware that the story includes: brutality, violence and death. These elements are integral to the narrative and may be disturbing or triggering for some players. Viewer discretion is strongly advised. If you are sensitive to such content, please proceed with caution or consider refraining from playing.")
            
            
            VStack{
                
                RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(.blue)
                .overlay(Text("Yes, Bring it on!").foregroundStyle(.white))
                .frame(width: 200, height: 35)
                .onTapGesture {
                    withAnimation {
                        book.beginReading()
                    }
                }
                
                Link("No, I want my mommy!", destination: URL(string: "https://media0.giphy.com/media/l0MYDItBlfs4FX1SM/200w.gif?cid=6c09b952fhzn38ynk2bn5u06gr32gxwa3og8xec9pgvjad35&ep=v1_gifs_search&rid=200w.gif&ct=g")!)
                    .buttonStyle(.borderedProminent)
                    .frame(width: 200, height: 35)
    
            }
            
        }
        .padding()
    }
}

#Preview {
    WarningView()
}
