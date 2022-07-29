//
//  AirDropViewModel.swift
//  Challenge2AirDrop
//
//  Created by Silviu Vranau on 29.07.2022.
//

import Foundation

class AirDropViewModel: ObservableObject {
    var timer: Timer?
    @Published var currentIndex: Int = 0
    @Published var currentState: SendState = .waiting
    @Published var progressIsHidden = false
    
    let states: [SendState] = [.waiting, .sending, .sent]
    
    init() {
        timer = Timer.scheduledTimer(withTimeInterval: 2.5, repeats: true) { _ in
            self.updateData()
        }
    }
    
    private func updateData() {
        guard currentIndex < states.count else { return }
        
        currentState = states[currentIndex]
        if currentState == .sent {
            progressIsHidden.toggle()
        }
        currentIndex += 1
    }
}
