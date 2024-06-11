//
//  DirectedGraphBuilder.swift
//  GraphGenerator
//
//  Created by Russell Gordon on 2023-06-10.
//

import Foundation
import Supabase

// NOTE: This is the command-line app entry point
@main
struct DirectedGraphBuilder {
    
    static func main() async throws {


        // Attempt to open the database
        // TODO: 1 - Replace details of this instance of StoryInformation with data for your own group's story
        let storyInfo = StoryInformation(title: "Journey Under The Sea",
                                         authorOrAuthors: "R.A. Montgomery",
                                         seriesInfo: "CHOOSE YOUR OWN ADVENTURE #2",
                                         publisherInfo: "Chooseco LLC, Waitsfield, Vermont, 2006")
        
        // TODO: 2 - Replace details of this instance of SupabaseClient with settings for your group's database
        let supabase = SupabaseClient(
          supabaseURL: URL(string: " https://rquokznnbicodfhxggob.supabase.co")!,
          supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJxdW9rem5uYmljb2RmaHhnZ29iIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTc0MjgwODksImV4cCI6MjAzMzAwNDA4OX0.PTR9atcziZiG4_Icgu6vMMeSwP6QLXwn_x5j4A2BhOk"
        )

        print("About to read page and edge data from database...", terminator: "")
        await generateGraphvizCommands(using: storyInfo, usingClient: supabase)

        // TODO: 3 - Visit this website
        //
        //       https://sketchviz.com/new

        // TODO: 4 - Paste the commands to build the graph at left in the Sketchviz interface
        //

        // TODO: 5 - Uncheck the "Sketchy" box
        //
        
        // TODO: 6 - View and optionally download the PNG
        //

        // Alternatively... if you wish to generate graphs on the command line of your own computer....
        
        // TODO: 3b - If you have not yet, install Homebrew.
        //
        //       https://brew.sh

        // TODO: 4b - If you have not yet, install graphviz by running this command in the Terminal
        //
        //       brew install graphviz

        // TODO: 5b - In the Terminal, from the folder 'input.txt' exists in, run the following command to generate your group's graph:
        //
        //           dot -Tpdf input.txt > output.pdf
        
    }
    
}

