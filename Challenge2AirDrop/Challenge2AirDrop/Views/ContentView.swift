//
//  ContentView.swift
//  Challenge2AirDrop
//
//  Created by Silviu Vranau on 29.07.2022.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = AirDropViewModel()
    @State var circleProgressValue: CGFloat = 0.0
    @State var isTextVisible = true
    
    
    var body: some View {
        ZStack {
            Color.black
            VStack {
                profileImageView
                Text(Constants.deviceName)
                    .foregroundColor(.white)
                    .font(.title)
                    .fontWeight(.medium)
                    .padding(.top, 30)
                stateTextView
            }
            .padding()
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    private var profileImageView: some View {
        Image(systemName: Constants.imageName)
            .resizable()
            .scaledToFit()
            .foregroundColor(.white.opacity(Constants.imageOpacity))
            .padding(9)
            .overlay(
                ZStack {
                    if !viewModel.progressIsHidden {
                        Circle()
                            .stroke(.gray, lineWidth: CGFloat(Constants.circleLineWidth))
                            .zIndex(0)
                        Circle()
                            .trim(from: 0, to: circleProgressValue)
                            .stroke(.blue, lineWidth: CGFloat(Constants.circleLineWidth))
                            .rotationEffect(.degrees(-90))
                            .animation(.linear(duration: Constants.progressBarAnimationDuration), value: circleProgressValue)
                            .zIndex(1)
                    }
                }
                    .animation(.default.delay(1.0), value: viewModel.progressIsHidden)
                
            )
            .frame(width: CGFloat(Constants.imageHeight), height: CGFloat(Constants.imageHeight), alignment: .center)
    }
    
    private var stateTextView: some View {
        Text(viewModel.currentState.rawValue)
            .foregroundColor(viewModel.currentState.textColor)
            .font(.title)
            .fontWeight(.medium)
            .opacity(isTextVisible ? 1 : 0)
            .animation(viewModel.currentState.isAnimating ? Animation.easeIn(duration: Constants.sendingStateAnimationDuration).repeatForever() : .default, value: isTextVisible) // this is to stop the animation for unwanted states.
            .onAppear {
                triggerAnimations()
            }
            .id(viewModel.currentState.hashValue)
    }
    
    private func triggerAnimations() {
        isTextVisible = !viewModel.currentState.isAnimating
        if viewModel.currentState == .sending {
            circleProgressValue = 1
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewLayout(.sizeThatFits)
            .previewDevice("iPhone 13 Pro")
        
    }
}
