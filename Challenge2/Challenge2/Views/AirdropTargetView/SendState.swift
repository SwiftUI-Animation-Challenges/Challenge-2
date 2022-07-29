//
//  SendState.swift
//  Challenge2
//
//  Created by Matt Pfeiffer on 7/29/22.
//

import SwiftUI

enum AirdropSendState {
    case preSend, connecting, inProgress, done
    
    var color: Color {
        switch self {
        case .preSend:
            return .white
        case .connecting:
            return .gray
        case .inProgress:
            return .gray
        case .done:
            return .blue
        }
    }
    
    var opacity: Double {
        if self == .connecting {
            return 0.0
        }
        return 1.0
    }
    
    var animation: Animation? {
        if self == .connecting {
            return .easeInOut(duration: 1.0).repeatForever(autoreverses: true)
        }
        return nil
    }
}
