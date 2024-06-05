//
//  EdgesViewModel.swift
//  CYOATemplate
//
//  Created by Russell Gordon on 2024-06-03.
//

import Foundation

@Observable
class EdgesViewModel: Observable {
    
    // Details of the current page being read
    var edges: [Edge]?
    
    init(book: BookStore) {
        
        // Load the edges for this page
        Task {
            edges = try await book.getEdgesForCurrentPage()
        }
        
    }
    
}
