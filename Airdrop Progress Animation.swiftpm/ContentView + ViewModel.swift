//
//  ContentView + ViewModel.swift
//  Airdrop Progress Animation
//
//  Created by Mert Tecimen on 4.08.2022.
//

import Foundation


extension ContentView{
    class ViewModel: ObservableObject{
        @Published var state: States = .idle
        //let users: [User] = [.init(id: UUID(), name: "Moe")]
        let users: [User] = [.init(id: UUID(), name: "Moe"), .init(id: UUID(), name: "Homer"), .init(id: UUID(), name: "Apu"), .init(id: UUID(), name: "Lisa")]
    }
}
