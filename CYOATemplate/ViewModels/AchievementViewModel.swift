//
//  AchievementViewModel.swift
//  CYOATemplate
//
//  Created by Quinlan Daniel Taylor on 2024-06-11.
//

import Foundation

@Observable
class achievementViewModel: Observable {
    
    // Details of the current page being read
    var achievements: [Achievement]?
    
    init(book: BookStore) {
        
        // Load the edges for this page
        Task {
            achievements = try await book.getAchievementsForCurrentPage()
        }
        
    }
    
}


//import Foundation
//import Supabase
//
//@Observable
//class AchievementViewModel: Observable {
//    
//   var achievementList: [Achievement] = []
//    var book: BookStore
//    
//    init(book: BookStore) {
//        self.book = book
//        Task {
//            await fetchAchievements()
//        }
//    }
//    
//    func fetchAchievements() async {
//        guard let currentPageId = book.currentPageId else {
//            print("No current page available.")
//            return
//        }
//        
//        do {
//            let achievements: [Achievement] = try await supabase
//                .from("achievement")
//                .select()
//                .eq("page_id", value: currentPageId)
//                .execute()
//                .value
//            
//            DispatchQueue.main.async {
//                self.achievementList = achievements
//            }
//            
//        } catch {
//            debugPrint(error)
//        }
//    }
//    
//    func checkForAchievement() async throws {
//        guard let currentPageId = book.currentPageId else {
//            print("No current page available.")
//            return
//        }
//        
//        if let achievement = try await getAchievement(for: currentPageId) {
//            if isNewAchievement(achievement) {
//                appendAchievement(achievement)
//                print("New achievement unlocked: \(achievement.name)")
//            } else {
//                print("Achievement already unlocked: \(achievement.name)")
//            }
//        } else {
//            print("No achievement associated with this page.")
//        }
//    }
//    
//    private func getAchievement(for pageId: Int) async throws -> Achievement? {
//        do {
//            let achievement: Achievement = try await supabase
//                .from("achievement")
//                .select()
//                .eq("page_id", value: pageId)
//                .single()
//                .execute()
//                .value
//            
//            return achievement
//        } catch {
//            debugPrint(error)
//            return nil
//        }
//    }
//    
//    private func isNewAchievement(_ achievement: Achievement) -> Bool {
//        return !achievementList.contains(where: { $0.id == achievement.id })
//    }
//    
//    private func appendAchievement(_ achievement: Achievement) {
//        achievementList.append(achievement)
//    }
//}
