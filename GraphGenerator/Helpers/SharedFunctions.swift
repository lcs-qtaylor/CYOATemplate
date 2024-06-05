//
//  SharedFunctions.swift
//  GraphGenerator
//
//  Created by Russell Gordon on 2023-06-10.
//

import Cocoa
import Foundation
import Supabase

// Function to generate output that Graphviz requires
func generateGraphvizCommands(using description: StoryInformation, usingClient db: SupabaseClient) async {
    
    var output = ""
    
    // Get all the pages from the databsae
    do {
        
        print("About to read all pages...", terminator: "")
        
        let pages: [Page] = try await db
            .from("page")
            .select()
            .order("id", ascending: true)
            .execute()
            .value
        
        print("done.")
        
        // Opening of graph
        output += "digraph \"[map]\" {\n"
        
        // Start subgraph which contains table that comprises title section
        output += "subgraph { \"title\" [shape=none label=<<table border=\"0\">\n"
        output += "  <tr>\n"
        output += "    <td align=\"left\"><font face=\"Verdana,Helvetica\" point-size=\"40\"><b>\(description.title)</b></font></td>\n"
        output += "    <td width=\"100\"></td>\n"
        output += "  </tr>\n"
        output += "  <tr>\n"
        output += "    <td align=\"left\"><font face=\"Verdana,Helvetica\" point-size=\"20\">By \(description.authorOrAuthors)</font></td>\n"
        output += "    <td></td>"
        output += "  </tr>\n"
        output += "  <tr>\n"
        output += "    <td>&nbsp;</td>\n"
        output += "    <td></td>"
        output += "  </tr>\n"
        output += "  <tr>\n"
        output += "    <td align=\"left\"><font face=\"Verdana,Helvetica\" point-size=\"16\">\(description.seriesInfo)</font></td>\n"
        output += "    <td></td>"
        output += "  </tr>\n"
        output += "  <tr>\n"
        output += "    <td align=\"left\"><font face=\"Verdana,Helvetica\" point-size=\"16\">\(description.publisherInfo)</font></td>\n"
        output += "    <td></td>"
        output += "  </tr>\n"
        
        // End the table that comprises title section
        output += "</table>>]\n"
        output += "}\n"
        
        // Make empty dictionary to track endings
        var endingsCount = [String : Int]()
        
        // Build the graph itself from a sorted list of the pages
        for page in pages {
            
            print("Processing page \(page.id)...")
            
            // Handle ending pages
            if let endingTypeId = page.endingTypeId {
                
                print("Page is an ending, about to process ending... ", terminator: "")
                
                do {
                    
                    let ending: EndingType = try await db
                        .from("ending_type")
                        .select()
                        .eq("id", value: endingTypeId)
                        .single()
                        .execute()
                        .value
                    
                    // Make ending pages show up in red
                    output += "\(page.id) [style=\"filled\", fillcolor=\"\(ending.color)\"]\n"
                    
                    // Get the ending description, if it exists
                    let endingDescription = page.endingContext ?? ""
                    
                    // Create an invisible page after each ending page
                    output += "\"\(endingDescription) \(page.id)\" [style=invis]\n"
                    
                    // Make a label after the ending page
                    output += "\(page.id) -> \"\(endingDescription) \(page.id)\" [labelangle=0, minlen=3,  color=white, taillabel=\"\\n\(endingDescription)\", fontname=\"Helvetica Bold\"]\n"
                    
                    // Track endings by category
                    if let valueForKey = endingsCount["\(ending.id)"] {
                        // Increment count of endings of this type
                        endingsCount["\(ending.id)"]! = valueForKey + 1
                    } else {
                        // Start count of endings of this type
                        endingsCount["\(ending.id)"] = 1
                    }
                    
                    print("done.")
                    
                } catch {
                    
                    debugPrint(error)
                    
                    print("===")
                    print("Could not access ending_type table in database when using ending type ID of \(page.endingTypeId ?? -1).")
                    print(error.localizedDescription)

                }
                
            }
            
            // Draw pages and edges between pages
            print("About to process edges for page \(page.id)...", terminator: "")
            output += "\(page.id) -> {"
            do {
                
                let edges: [Edge] = try await db
                    .from("edge")
                    .select()
                    .eq("from_page", value: page.id)
                    .execute()
                    .value
                
                for edge in edges {
                    output += "\(edge.toPage);"
                }
                
            } catch {
                print("===")
                print("Could not access Edge table in database when using page ID of \(page.id).")
                print(error.localizedDescription)
            }
            output += "} [minlen=2]\n"
            
            print(" done.")
        }
        
        // Start subgraph which endings analysis
        print("About to analyze endings... ")
        
        output += "subgraph { \"endings\" [shape=none label=<<table border=\"0\">\n"
        output += "  <tr>\n"
        output += "  <td width=\"100\"></td>\n"
        output += "    <td colspan=\"2\" align=\"left\"><font face=\"Verdana,Helvetica\" point-size=\"20\"><b>&nbsp;</b></font></td>\n"
        output += "  </tr>\n"
        output += "  <tr>\n"
        output += "  <td></td>\n"
        output += "    <td colspan=\"2\" align=\"left\"><font face=\"Verdana,Helvetica\" point-size=\"20\"><b>&nbsp;</b></font></td>\n"
        output += "  </tr>\n"
        output += "  <tr>\n"
        output += "  <td></td>\n"
        output += "    <td colspan=\"2\" align=\"left\"><font face=\"Verdana,Helvetica\" point-size=\"20\"><b>Analysis of endings</b></font></td>\n"
        output += "  </tr>\n"
        
        // Make placeholders for counts of ending types
        do {
            
            print("About to iterate over all ending types...")
            
            let endingTypes: [EndingType] = try await db
                .from("ending_type")
                .select()
                .execute()
                .value
            
            for endingType in endingTypes {
                
                print("Analyzing for ending type: \(endingType.label)...")
                
                // Get count of endings for this ending type
                var countForThisEndingType = 0
                if let count = endingsCount["\(endingType.id)"] {
                    countForThisEndingType = count
                }
                
                output += "  <tr>\n"
                output += "  <td></td>\n"
                output += "<td align=\"right\" valign=\"top\"><font face=\"Verdana,Helvetica\" point-size=\"16\">\(countForThisEndingType)</font></td>"
                output += "    <td align=\"left\" valign=\"bottom\"><font face=\"Verdana,Helvetica\" point-size=\"18\" color=\"\(endingType.color)\"><b>\(endingType.label)</b></font></td>\n"
                output += "  </tr>\n"

            }
            
        } catch {
            print("===")
            print("Could not access EndingType table in database.")
            print(error.localizedDescription)
        }
            
        // End the table that comprises title section
        output += "</table>>]\n"
        output += "}\n"
        
        // Close out the graph
        output += "}\n"
        
        print("All done.\n")
        
        print("Press RETURN to proceed with copying graph code to clipboard...")
        let _ = readLine()
        
        // Copy the genereated output to the clipboard.
        print("About to add to clipboard...", terminator: "")
        let pasteBoard = NSPasteboard.general
        pasteBoard.clearContents()
        pasteBoard.setString(output, forType: .string)
        print("done.")
        
        print("Now go to https://sketchviz.com/new and paste the results into the field at left to build your graph.")
        print("Or, use `graphviz` to generate the graph on your own computer.\n")
        
        print("Press RETURN to close this program...")
        let _ = readLine()

        
    } catch {
        
        debugPrint(error)
        
        print("===")
        print("Could not access page table in database.")
        print(error.localizedDescription)

    }
        
}

