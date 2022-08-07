//
//  Constants.swift
//  Airdrop Progress Animation
//
//  Created by Mert Tecimen on 4.08.2022.
//

import Foundation

enum States{
    case idle, waiting, sending, sent
}

enum Device: String, CaseIterable{
    case iphone = "iPhone"
    case macbook = "MacBook"
    case iPad = "iPad"
}


