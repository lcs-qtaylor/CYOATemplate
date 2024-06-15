//
//  BookStore.swift
//  CYOATemplate
//
//  Created by Russell Gordon on 2024-06-02.
//

import Foundation
import PostgREST
import SwiftUI
import NVMColor

// Stores everything related to tracking current state
// as the reader reads this CYOA book
@Observable
class BookStore: Observable {
    
    // MARK: Stored properties
    
    // Preserves preferences and state for the current reader of this book
    var reader: Reader
    var achievement: Achievement
    // What is the current page being read?
    var currentPageId: Int?
    var pageId: Int?

    private var firstPageId: Int?
    
    
    //Default colors for the primary and secondary
    var primaryColor: Color = .black
    var secondaryColor: Color = .red
    
    //Hex value of primary color
    var hexPrimary: String {
        return String(primaryColor.hex?.isHex()?.dropLast(2) ?? "000000")
    }
    
    //Hex vaule of secondary color
    var hexSecondary: String {
        return String(secondaryColor.hex?.isHex()?.dropLast(2) ?? "FF2C17")
    }
    
    // MARK: Computed properties
    
    // Is the book ready to read? (Do we know the id of the first page?)
    var isNotReadyToRead: Bool {
        
        // Returns true when the first page is not known
        return self.firstPageId == nil
        
    }
    
    // Is the book being read at the moment?
    var isBeingRead: Bool {
        
        // Returns true when a page is being read, otherwise false
        return self.currentPageId != nil
    }
    
    // What is the first page of the book?
    var firstPage: Int? {
        
        get async throws {
            
            do {
                let result: [String: Int] = try await supabase
                    .from("page")
                    .select("id")
                    .order("id", ascending: true)
                    .limit(1)
                    .single()
                    .execute()
                    .value
                
                return result["id"]!
                    
            } catch {
                
                debugPrint(error)
                
                return nil
            }
            
        }
        
    }
    
    // MARK: Initializer(s)
    init() {
        self.reader = Reader(prefersDarkMode: false, fontSize: 14)
        self.achievement = Achievement(id: 1, pageId: 1, achievementName: "", achievementDescription: "")
        Task {
            try await self.restoreState()
        }
    }
    
    // MARK: Function(s)
    
    // Show the cover page again
    func showCoverPage() {
        self.currentPageId = nil
    }
    
    // Restore any existing state for the reader of this book
    func restoreState() async throws {
        
        do {
            
            // Try to obtain reader's prior state
            let result: Reader = try await supabase
                .from("reader")
                .select()
                .limit(1)
                .single()
                .execute()
                .value
            
            self.reader = result
            
            self.primaryColor = Color(hex: result.primaryColor ?? "000000")!
            self.secondaryColor = Color(hex: result.secondaryColor ?? "FF2C17")!
            
            // When prior state doesn't know what page was last read read, set first page of book
            // NOTE: This shouldn't really ever happen, but might occur during testing.
            if result.lastPageReadId == nil {
                self.firstPageId = try await self.firstPage
            }
            
            // Set the current page (book is being read)
            self.currentPageId = result.lastPageReadId

        } catch {
            
            // Convert the generic error object into something we can inexpect
            let decodedError = error as! PostgrestError
            
            // When (likely if at this point) no rows are returned
            // we need to set the reader's state in the database for the first time
            if let code = decodedError.code, code == "PGRST116" {

                print("No rows, or multiple rows, returned.")
                
                do {

                    let reader = Reader(prefersDarkMode: false,fontSize: 14)
                    
                    // Create a Reader instance and add it to the database for this user
                    let newlyInsertedReader: Reader = try await supabase
                        .from("reader")
                        .insert(reader)
                        .select()
                        .single()
                        .execute()
                        .value
                    
                    self.reader = newlyInsertedReader
                    
                    // Set the first page id so the book is ready to read
                    self.firstPageId = try await self.firstPage

                } catch {
                    debugPrint(error)
                }
                
            } else {
                debugPrint(error)
            }
            
        }
    }
    
    // Start reading from the first page
    func beginReading() {
        self.currentPageId = self.firstPageId
    }
    
    // Advance to the provided page id
    func read(_ pageId: Int) {
        self.currentPageId = pageId
    }
    
    // Return the details of the current page
    func getCurrentPage() async throws -> Page? {
        
        do {
            let currentPage: Page = try await supabase
                .from("page")
                .select()
                .eq("id", value: self.currentPageId)
                .single()
                .execute()
                .value
            
            return currentPage
                
        } catch {
            
            debugPrint(error)
            
            return nil
        }
        
    }
    
    // Save the reader's state for this book
    func saveState() async throws {
        
        // Save current page
        self.reader.lastPageReadId = self.currentPageId

        self.reader.primaryColor = self.hexPrimary
        self.reader.secondaryColor = self.hexSecondary
        
        // Update in the database
        Task {
            
            do {
                
                try await supabase
                    .from("reader")
                    .update(self.reader)
                    .eq("id", value: self.reader.id!)
                    .execute()
                
            } catch {
                debugPrint(error)
            }
            
        }

    }
    
    
    // Return the details of the current page
    func getEdgesForCurrentPage() async throws -> [Edge]? {
        
        do {
            let edges: [Edge] = try await supabase
                .from("edge")
                .select()
                .eq("from_page", value: self.currentPageId)
                .execute()
                .value
            
            return edges
                
        } catch {
            
            debugPrint(error)
            
            return nil
        }
        
    }
    func getAchievementsForCurrentPage() async throws -> [Achievement]? {
        
        do {
            let achievements: [Achievement] = try await supabase
                .from("achievement")
                .select()
                .eq("page_id", value: self.currentPageId)
                .execute()
                .value
            
            return achievements
                
        } catch {
            
            debugPrint(error)
            
            return nil
        }
        
    }
    
}
