//
//  PersonBadgeView + ViewModel.swift
//  Airdrop Progress Animation
//
//  Created by Mert Tecimen on 5.08.2022.
//

import Foundation


struct User: Identifiable{
    let id: UUID
    let name: String
    let device: String = Device.allCases.randomElement()?.rawValue ?? ""
}

extension PersonBadgeView{
    class ViewModel: ObservableObject{
        @Published var state: States = .idle
        let waitDelay: Double
        let sendingDelay: Double
        var user: User!
        
        
        init(waitDelay: Double, sendingDelay: Double) {
            self.waitDelay = waitDelay
            self.sendingDelay = sendingDelay
        }
        
        func requestTransfer(){
            self.state = .waiting
            print("Waiting")
            DispatchQueue.main.asyncAfter(deadline: .now() + waitDelay){ [unowned self] in
                transfer()
            }
        }
        
        func transfer(){
            self.state = .sending
            print("Sending")
            
            // Waits till the animation is compeleted.
            DispatchQueue.main.asyncAfter(deadline: .now() + ((sendingDelay * 2))){ [unowned self] in
                self.setSent()
            }
        }
        
        func setSent(){
            self.state = .sent
            print("Sent")
        }
        
        func resetTransfer(){
            self.state = .idle
        }
        
        
        
    }
}
