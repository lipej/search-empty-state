//
//  ContentView.swift
//  search-empty-state
//
//  Created by Felipe José on 29/04/24.
//

import SwiftUI

struct ContentView: View {
    @State private var wizards: [String] = []
    @State private var searchTerm = ""
    private var staticWizards = ["Alvo Dumbledore", "Harry Potter", "Hermione Granger", "Severus Snape", "Minerva McGonagall"]
    var filteredWizards: [String] {
        guard !searchTerm.isEmpty else {return wizards}
        return wizards.filter { $0.localizedCaseInsensitiveContains(searchTerm) }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if !wizards.isEmpty {
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
                                Text("No wizards were found with the name \(searchTerm). Perhaps you're looking for a muggle?").accessibilityIdentifier("ResultError")
                            }
                            )
                        }
                    }
                } else {
                    Text("loading...")
                }
            }
            .navigationTitle("Hogwarts Wizards")
        }.task {
            do {
                wizards = try await fetchWizards()
            } catch {
                wizards = staticWizards
            }
        }.colorScheme(.light)
    }
    
    struct Wizards: Codable {
        let name: String
        let hogwartsStudent: Bool
        let hogwartsStaff: Bool
    }
    
    func fetchWizards() async throws -> [String] {
        let url = URL(string: "https://hp-api.onrender.com/api/characters")!
        let (data, _) = try await URLSession.shared.data(from: url)
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let result = try decoder.decode([Wizards].self, from: data)
            return result.filter { $0.hogwartsStaff || $0.hogwartsStudent } .map { $0.name }
        } catch {
            throw error
        }
    }
    
}


#Preview {
    ContentView()
}

