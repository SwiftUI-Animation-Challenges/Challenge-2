//
//  AirDropView.swift
//  AnimationChallengeTwo
//
//  Created by QBuser on 30/07/22.
//

import SwiftUI

struct AirDropView: View {
    @State private var completionAmount = 0.0
    @State var status: AirDropSates = .receive
    @State var isTimerRunning: Bool = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea(.all)
            VStack {
                LoaderView(completionAmount: $completionAmount)
                NameView(status: $status)
            }
            .onReceive(timer) { _ in
                if status == .sending {
                    if completionAmount >= 1.0 {
                        status = .sent
                        self.timer.upstream.connect().cancel()
                    } else {
                        completionAmount += 0.1
                    }
                }
            }
            .onAppear() {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    status = .waiting
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                        isTimerRunning = true
                        status = .sending
                    }
                }
                
            }
        }
    }
}

struct AirDropView_Previews: PreviewProvider {
    static var previews: some View {
        AirDropView()
    }
}

struct LoaderView: View {
    @Binding  var completionAmount: Double
    var body: some View {
        ZStack {
            Image(systemName: "person.circle.fill")
                .resizable()
                .renderingMode(.template)
                .foregroundColor(imageColor)
                .frame(width: 190, height: 190)
            ZStack {
                Circle()
                    .stroke(loaderColor, lineWidth: 6)
                    .frame(width: 200, height: 200)
                Circle()
                    .trim(from: 0, to: completionAmount)
                    .stroke(.blue, lineWidth: 6)
                    .frame(width: 200, height: 200)
                    .rotationEffect(.degrees(-90))
                    .animation(Animation.easeInOut(duration: 1), value: completionAmount)
            }
        }
    }
}

struct NameView: View {
    @Binding var status: AirDropSates
    @State private var blinking: Bool = false
    var body: some View {
        VStack(spacing: 5.0) {
            Text("iPhone")
                .foregroundColor(.white)
                .font(.title3)
            titleView(status: status)
        }
    }
    
    @ViewBuilder
    private func titleView(status: AirDropSates) -> some View {
        switch status {
        case .waiting:
            BlinkView(title: status.rawValue)
        case .receive:
            TitleView(title: status.rawValue,
                     color: .white)
        case .sent:
            TitleView(title: status.rawValue,
                     color: .blue)
        case .sending:
            TitleView(title: status.rawValue,
                     color: .white)
        }
    }
}
struct TitleView: View {
    @State var title: String
    @State var color: Color = .white
    var body: some View {
        Text(title)
            .font(.title3)
            .foregroundColor(color)
    }
}
struct BlinkView: View {
    @State private var blinking: Bool = false
    @State var title: String
    var body: some View {
        Text("Waiting...")
            .font(.title3)
            .foregroundColor(loaderColor)
            .opacity(blinking ? 0 : 1)
            .onAppear {
                withAnimation(.easeOut(duration: 0.75).repeatForever()) {
                    blinking = true
                }
            }
    }
}


enum AirDropSates: String {
    case receive = "From Amos"
    case waiting = "Waiting..."
    case sending = "Sending..."
    case sent = "Sent"
}
