//
//  AirdropView.swift
//  Challenge2
//
//  Created by Matt Pfeiffer on 7/29/22.
//

import SwiftUI

struct AirdropView: View {
    let targets = [AirdropTarget(image: Image("Lynyrd"), name: "Lynyrd"),
                   AirdropTarget(image: Image("Katniss"), name: "Katniss"),
                   AirdropTarget(name: "Random Guy")]
    
    var body: some View {
        ZStack {
            charcoal
            ScrollView(.horizontal) {
                HStack(spacing: 20) {
                    ForEach(targets, id: \.id) { target in
                        AirdropTargetView(name: target.name, image: target.image)
                            .padding()
                    }
                }
            }
        }
        .ignoresSafeArea()
    }
    
    struct AirdropTarget {
        var id = UUID()
        var image: Image?
        var name: String
    }
}

struct AirdropView_Previews: PreviewProvider {
    static var previews: some View {
        AirdropView()
    }
}
