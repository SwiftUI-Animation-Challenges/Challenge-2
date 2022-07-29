//
//  Gradient+Extensions.swift
//  Challenge2
//
//  Created by Matt Pfeiffer on 7/29/22.
//

import SwiftUI

public extension Gradient {
    static var shiny: Gradient {
        Gradient(colors: [
            Color.white.opacity(0.0125),
            Color.white.opacity(0.025),
            Color.white.opacity(0.05),
            Color.white.opacity(0.1),
            Color.white.opacity(0.2),
            Color.white.opacity(0.25),
            Color.white.opacity(0.375),
            Color.white.opacity(0.5),
            Color.white.opacity(0.75),
            Color.white.opacity(0.5),
            Color.white.opacity(0.375),
            Color.white.opacity(0.25),
            Color.white.opacity(0.175),
            Color.white.opacity(0.1),
            Color.white.opacity(0.05),
            Color.white.opacity(0.025),
            Color.white.opacity(0.0125),
        ])
    }
}
