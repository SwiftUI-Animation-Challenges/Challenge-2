import SwiftUI

struct AirDropAnimationView: View {

    let recipientName: String
    @State private var phase: AnimationPhase = .pickRecipient

    @ViewBuilder
    private var subTitle: some View {
        switch phase {
        case .pickRecipient:
            Text("from Amos")
                .foregroundColor(Color(red: 222 / 255, green: 222 / 255, blue: 222 / 255))
        case .waiting:
            PulsatingText("Waiting...")
                .foregroundColor(Color(red: 222 / 255, green: 222 / 255, blue: 222 / 255))
                .opacity(0.7)
        case .sending:
            Text("Sending...")
                .foregroundColor(Color(red: 222 / 255, green: 222 / 255, blue: 222 / 255))
                .opacity(0.7)
        case .sent:
            Text("Sent")
                .foregroundColor(.blue)
        }
    }

    @ViewBuilder
    private var ringView: some View {
        let lineWidth: Double = 10
        switch phase {
        case .pickRecipient, .waiting:
            Circle()
                .stroke(
                    Color(red: 104 / 255, green: 104 / 255, blue: 106 / 255),
                    style: .init(lineWidth: lineWidth)
                )
                .padding(lineWidth / 2)
        case .sending:
            RingProgress(lineWidth: lineWidth)
        case .sent:
            Circle()
                .stroke(
                    .blue,
                    style: .init(lineWidth: lineWidth)
                )
                .padding(lineWidth / 2)
        }
    }

    private func showAnimations() {
        phase = .pickRecipient
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            phase = .waiting
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            phase = .sending
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 6.5) {
            phase = .sent
        }
    }

    var body: some View {
        VStack {
            ZStack {
                Icon()
                    .padding(14)
                ringView
            }

            VStack {
                Text(recipientName)
                    .foregroundColor(Color(red: 222 / 255, green: 222 / 255, blue: 222 / 255))
                subTitle
            }
        }
        .padding()
        .background(Color(red: 31/255, green: 31/255, blue: 31/255))
        .onAppear { showAnimations() }
    }
}

extension AirDropAnimationView {
    enum AnimationPhase {
        case pickRecipient
        case waiting
        case sending
        case sent
    }
}

struct AirDropAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        AirDropAnimationView(recipientName: "iPhone")
            .previewLayout(.fixed(width: 320, height: 350))
    }
}
