//
//  PersonProgressView.swift
//  Challenge2
//
//  Created by Matt Pfeiffer on 7/29/22.
//

import SwiftUI

struct PersonProgressView: View {
    var image: Image? = Image("Lynyrd")
    var progress: CGFloat = 0.5
    var sendState: AirdropSendState = .inProgress
    
    @State private var isAnimating: Bool = false
    
    var body: some View {
        GeometryReader { geo in
            let lineWidth = geo.size.width * 0.03
            let personWidth = geo.size.width * 0.5
            
            Circle()
                .fill(.gray)
                .padding(lineWidth)
                .overlay(
                    ZStack {
                        
                        if sendState != .done {
                            Circle()
                                .stroke(Color.gray, lineWidth: lineWidth)
                            
                            Circle()
                                .trim(from: 1.0 - progress, to: 1.0)
                                .rotation(.degrees(90))
                                .stroke(Color.blue, lineWidth: lineWidth)
                                .rotation3DEffect(Angle(degrees: 180), axis: (x: 1.0, y: 0.0, z: 0.0))
                        }
                            
                        if let image = image {
                            image
                                .resizable()
                                .frame(width: geo.size.width * 0.95,
                                       height: geo.size.width * 0.95)
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "person.fill")
                                .resizable()
                                .frame(width: personWidth, height: personWidth * 1.1)
                                .aspectRatio(contentMode: .fill)
                                .foregroundColor(charcoal)
                                .offset(y: personWidth * 0.2)
                                .padding(personWidth * 0.2)
                                .clipShape(Circle())
                        }
                        
                        if sendState == .done {
                            LinearGradient(gradient: .shiny,
                                           startPoint: .leading,
                                           endPoint: .trailing)
                            .offset(x: isAnimating ? geo.size.width : -geo.size.width)
                            .rotationEffect(Angle(degrees: -45))
                            .clipShape(Circle())
                            .padding(lineWidth)
                            .onAppear() {
                                withAnimation(.linear(duration: 1.0)){
                                        isAnimating.toggle()
                                    }
                             }
                        }
                    }
                        .animation(.easeIn(duration: 1.0), value: sendState)
                )
        }
    }
}

struct PersonProgressView_Previews: PreviewProvider {
    static var previews: some View {
        PersonProgressView()
            .padding()
            .background(charcoal)
    }
}
