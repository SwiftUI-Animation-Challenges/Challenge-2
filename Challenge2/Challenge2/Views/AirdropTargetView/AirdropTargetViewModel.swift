//
//  AirdropTargetViewModel.swift
//  Challenge2
//
//  Created by Matt Pfeiffer on 7/29/22.
//

import SwiftUI

class AirdropTargetViewModel: ObservableObject {
    @Published var sendState: AirdropSendState = .preSend
    @Published var progress: CGFloat = 0.0
    @Published var opacity: Double = 1.0
    
    var name: String
    var image: Image?
    
    var timer: Timer?
    
    var stateText: String {
        switch sendState {
        case .preSend:
            return "from Matt"
        case .connecting:
            return "Waiting..."
        case .inProgress:
            return "Sending..."
        case .done:
            return "Sent"
        }
    }
    
    init(name: String, image: Image? = nil) {
        self.name = name
        self.image = image
    }
    
    func simulateInitiate() {
        progress = 0.0
        sendState = .connecting
        withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
            opacity = 0.0
        }
        
        let waitTime: TimeInterval = 2.0
        DispatchQueue.main.asyncAfter(deadline: .now() + waitTime) {
            self.simulateConnected()
        }
    }
    
    func simulateConnected() {
        sendState = .inProgress
        withAnimation(.easeInOut(duration: 0.1)) {
            self.opacity = 1.0
        }
        
        timer = Timer.scheduledTimer(timeInterval: 0.01,
                                     target: self,
                                     selector: #selector(stepProgress),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    @objc func stepProgress() {
        DispatchQueue.main.async {
            self.progress += 0.005
            
            
            
            if self.progress > 1.0 {
                self.simulateCompleted()
            }
        }
    }
    
    func simulateCompleted() {
        timer?.invalidate()
        
        // slight delay so that the progress finishes before fadeout
        let waitTime: TimeInterval = 0.1
        DispatchQueue.main.asyncAfter(deadline: .now() + waitTime) {
            self.sendState = .done
        }
    }
}
