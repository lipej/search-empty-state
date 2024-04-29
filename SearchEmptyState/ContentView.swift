//
//  ContentView.swift
//  search-empty-state
//
//  Created by Felipe José on 29/04/24.
//

import SwiftUI

struct ContentView: View {
    @State private var wizards = ["Alvo Dumbledore", "Harry Potter", "Hermione Granger", "Severus Snape", "Minerva McGonagall"]
    @State private var searchTerm = ""
    
    var filteredWizards: [String] {
        guard !searchTerm.isEmpty else {return wizards}
        
        return wizards.filter { $0.localizedCaseInsensitiveContains(searchTerm) }
    }
    
    
    var body: some View {
        NavigationStack {
            VStack {
                List(filteredWizards, id: \.self) {
                    wizard in Text(wizard)
                }
                .searchable(text: $searchTerm, prompt: "Search a Wizard")
                .overlay {
                    if filteredWizards.isEmpty {
                        ContentUnavailableView(label: {
                            VStack {
                                Image("wand").resizable().frame(width: 120, height: 120).padding(.bottom, -20)
                                Text("No Wizards").bold()
                            }
                        }, description: {
                            Text("No wizards was found with: \(searchTerm), maybe you're looking for a muggle?").accessibilityIdentifier("ResultError")
                        }
                        )
                    }
                }
            }
            .navigationTitle("Hogwarts Wizards")
        }
    }
}

#Preview {
    ContentView()
}
