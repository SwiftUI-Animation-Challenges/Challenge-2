//
//  UserIconView.swift
//  Airdrop Progress Animation
//
//  Created by Mert Tecimen on 6.08.2022.
//

import SwiftUI
import Combine

struct Arc: Shape, Animatable {
    var startAngle: Angle
    var endAngle: Angle
    var clockwise: Bool
    var animatableData: Double
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        // Store of arc is starts from 90 degree (which is bottom center of the circle) animatableData (which 30 degree in this case) added for start angle and substracted fro end angle, at the end start angle 120 and end angle at 60 degress thus represents a smile.
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.width / 2, startAngle: .degrees(90+animatableData), endAngle: .degrees(90-animatableData), clockwise: clockwise)
        
        return path
    }
}

fileprivate struct AnimatedEyeView: View{
    
    @State var primaryEyeColor: Color
    let switchColor: Color
    let width: CGFloat
    // To achive blinking, eye color switched between background color and badge background color with spring animation.
    var body: some View{
        HStack(spacing: width / 4){
            Circle()
                .foregroundColor(primaryEyeColor)
            Circle()
                .foregroundColor(primaryEyeColor)
        }
        .onAppear{
            withAnimation(.spring().repeatForever(autoreverses: true)){
                primaryEyeColor = switchColor
            }
        }
    }
}

fileprivate struct EyeView: View{
    
    @Binding var eyeColor: Color
    let width: CGFloat
    
    var body: some View{
        HStack(spacing: width / 4){
            Circle()
                .foregroundColor(eyeColor)
            Circle()
                .foregroundColor(eyeColor)
        }
    }
}

struct UserIconHeadView: View{
    @Binding var state: States
    @State private var degree: Double = 0
    @State private var eyeColor: Color = .backgroundColor
    @State private var animation: Animation = .spring().repeatForever(autoreverses: true)
    
    var body: some View{
        GeometryReader{ geometry in
            ZStack{
                Circle()
                    .foregroundColor(.backgroundColor)
                ZStack {
                    if state == .waiting || state == .sending {
                        AnimatedEyeView(primaryEyeColor: .backgroundColor, switchColor: .badgeBackgroundColor, width: geometry.size.width / 2)
                            .frame(maxWidth:  geometry.size.width / 2, minHeight: geometry.size.height / 2)
                            .offset(y: geometry.size.height / 5)
                    } else {
                        EyeView(eyeColor: $eyeColor, width: geometry.size.width / 2)
                            .frame(maxWidth:  geometry.size.width / 2, minHeight: geometry.size.height / 2)
                            .offset(y: geometry.size.height / 5)
                    }
                    // Smile is achived with Arc View. See the definition for details.
                    Arc(startAngle: .degrees(100), endAngle: .degrees(30), clockwise: true, animatableData: degree)
                        .stroke(Color.badgeBackgroundColor, lineWidth: geometry.size.height / 20)
                }
                .offset(y: -1*geometry.size.height / 5)
            }
            .onReceive(Just(self.$state)){ _ in
                switch state {
                case .idle:
                    // EyeColor and degree reseted to default value.
                    eyeColor = .backgroundColor
                    degree = 0
                case .waiting:
                    degree = 0
                case .sending:
                    break
                case .sent:
                    eyeColor = .badgeBackgroundColor
                    // Sets degree for smile.
                    withAnimation(.linear(duration: 0.5)){
                        degree = 30
                    }
                }
            }
        }
    }
}

struct UserIconView: View {
    @Binding var state: States
    let size: CGSize
    
    // To achive reuseablity I have used coefficients on animation and size values to make views and animationt adeptive to diffrent sizes.
    @State private var headOffsetCoefficient: Double = 1/6
    @State private var bodyOffsetCoefficient: Double = 2/3
    @State private var headScaleCoefficient: Double = 1
    
    var body: some View {
        ZStack{
            ZStack{
                UserIconHeadView(state: $state)
                    .frame(maxWidth: size.width / 2, maxHeight: size.height / 2)
                    .offset(y: -size.height * headOffsetCoefficient)
                    .scaleEffect(x: headScaleCoefficient, y: headScaleCoefficient, anchor: .center)
                Circle()
                    .foregroundColor(.backgroundColor)
                    .offset(y: size.height * bodyOffsetCoefficient)
                    .scaleEffect(x: headScaleCoefficient, y: headScaleCoefficient, anchor: .center)
            }
        }
        .frame(width: size.width, height: size.height)
        .clipShape(Circle())
        // Little Combine things(!)
        .onReceive(Just($state)){ _ in
            switch state {
            case .idle:
                // Coefficients resetted to default value on idle.
                headOffsetCoefficient = 1/6
            bodyOffsetCoefficient = 2/3
            headScaleCoefficient = 1.0
            case .waiting:
                break
            case .sending:
                withAnimation(.linear(duration: 0.5)){
                    // Torse of the user illustration is offsetted out of view.
                    bodyOffsetCoefficient = 1
                    // Head of the user illustration centered on the view.
                    headOffsetCoefficient = 0
                    // Head of the user illustration scaled to twice in size.
                    headScaleCoefficient = 2
                    
                }
            case .sent:
                break
            }
        }
    }
}

struct UserIconView_Previews: PreviewProvider {
    static var previews: some View {
        UserIconView(state: .constant(.idle), size: .init(width: 300, height: 300))
        UserIconHeadView(state: .constant(.idle))
    }
}
