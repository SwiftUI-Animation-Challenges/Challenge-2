//
//  PersonBadgeView.swift
//  Airdrop Progress Animation
//
//  Created by Mert Tecimen on 4.08.2022.
//

import SwiftUI

// There are no optimal solutions (as far as I know) to stopping "repeatForever" animations, so In couple of WWDC sessions demonstraids that recommended way of doings is switching between animated and non-animated versions of a view. Which makes me a bit uncomfortable, a stop method for animations would be appreciated.
fileprivate struct BlinkingStatusText: View{
    
    @Binding var text: String
    @State var textColor: Color
    
    var body: some View{
        Text(text)
            .foregroundColor(textColor)
            .onAppear{
                withAnimation(.linear(duration: 0.8).repeatForever(autoreverses: true)){
                    textColor = .clear
                }
            }
    }
}

struct ProgressRing: View{
    
    @Binding var progressAmount: CGFloat
    
    var body: some View{
        GeometryReader{ geometry in
            ZStack{
                Circle()
                    .stroke(
                        Color.progressRingBackgroundColor,
                        lineWidth: geometry.size.width * 1/20
                    )
                Circle()
                    .trim(from: 0, to: progressAmount / 100)
                    .stroke(
                        Color.progressRingAccentColor,
                        lineWidth: geometry.size.width * 1/20
                    )
                    .rotationEffect(.degrees(-90))
            }
        }
    }
}

// Data transfer on AirDrop contains 4 states: idle, waiting, sending and sent. View Model in PersonBadge view contains a state variable, when airdrop is requested those states are iterated via given delay values.
struct PersonBadgeView: View {
    
    @State var progress: CGFloat = 0
    let user: User
    // Random sending delay and wait delay for users to add variaty.
    @StateObject private var viewModel: ViewModel = .init(waitDelay:  Double.random(in: 2...5), sendingDelay: Double.random(in: 1...5))
    
    @State private var deviceTextColor: Color = .textColor
    @State private var statusTextColor: Color = .textColor
    @State private var statusText: String = ""
    
    init(user: User){
        self.user = user
    }
    
    var body: some View {
        GeometryReader{ geometry in
            VStack {
                ZStack{
                    ZStack{
                        Circle()
                            .foregroundColor(.badgeBackgroundColor)
                            .padding([.all], geometry.size.width / 25)
                        // User Icon and animations are contained in UserIconView.
                        UserIconView(state: $viewModel.state, size: .init(width: geometry.size.width / 1.5, height: geometry.size.height / 1.5))
                            .frame(maxWidth: geometry.size.width * 3/4, maxHeight: geometry.size.height * 3/4)
                    }
                    // ProgressRing is wraps around UserIconView and displays a progress animation that completes in given sending delay time.
                    ProgressRing(progressAmount: $progress)
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                .aspectRatio(1.0, contentMode: .fit)
                .onReceive(viewModel.$state){ state in
                    switch state{
                    case .idle:
                        resetAnimation()
                        statusText = "from \(user.name)"
                        statusTextColor = .textColor
                    case .waiting:
                        statusText = "Waiting..."
                        statusTextColor = .badgeBackgroundColor
                    case .sending:
                        startAnimation()
                        statusText = "Sending..."
                    case .sent:
                        statusText = "Sent"
                        statusTextColor = .progressRingAccentColor
                    }
                }
                .onAppear{
                    viewModel.user = user
                }
                .onTapGesture{
                    if viewModel.state == .idle{
                        viewModel.requestTransfer()
                    }
                }
                .onLongPressGesture{
                    viewModel.resetTransfer()
            }
                Text("\(user.device)")
                    .foregroundColor(deviceTextColor)
                // Switching between animated and non-animated versions of text view.
                if viewModel.state == .waiting{
                    BlinkingStatusText(text: $statusText, textColor: statusTextColor)
                } else {
                    Text(statusText)
                        .foregroundColor(statusTextColor)
                }
                 
            }
        }
    }
    
    private func startAnimation(){
        // Ease Ins to first half of the progress animation.
        withAnimation(.easeIn(duration: viewModel.sendingDelay)){
            progress = 50
        }
        // Ease Outs to second half of the progress animaiton.
        withAnimation(.easeOut(duration: viewModel.sendingDelay).delay(viewModel.sendingDelay)){
            progress = 100
        }
    }
    
    private func resetAnimation(){
        // Resets progress animation.
        progress = 0
    }
    
}

struct PersonBadgeView_Previews: PreviewProvider {
    static var previews: some View {
        PersonBadgeView(user: .init(id: UUID(), name: "Tony"))
    }
}
