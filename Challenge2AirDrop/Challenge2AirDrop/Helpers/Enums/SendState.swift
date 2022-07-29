//
//  SendState.swift
//  Challenge2AirDrop
//
//  Created by Silviu Vranau on 29.07.2022.
//

import Foundation
import SwiftUI // should not import SwiftUI only for Color type usage, but for the sake of this example, let's keep it simple

enum SendState: String {
    case sending = "Sending..."
    case waiting = "Waiting..."
    case sent = "Sent"
    
    var textColor: Color {
        switch self {
        case .sent:
            return .blue
        default:
            return .gray
        }
    }
    
    var isAnimating: Bool {
        switch self {
        case .waiting: return true
        default: return false
        }
    }
}
