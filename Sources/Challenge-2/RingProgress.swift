import SwiftUI

struct RingProgress: View {
    var trackColor = Color(red: 104 / 255, green: 104 / 255, blue: 106 / 255)
    var progressColor: Color = .blue
    var lineWidth: Double = 10

    @State private var progress: Double = 0

    private var animation: Animation {
        .easeInOut(duration: 2)
    }

    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    trackColor,
                    style: .init(lineWidth: lineWidth)
                )
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    progressColor,
                    style: .init(lineWidth: lineWidth)
                )
                .animation(animation, value: progress)
                .rotationEffect(.degrees(-90))
        }
        .padding(lineWidth / 2)
        .onAppear { progress = 1 }
    }
}


struct RingProgress_Previews: PreviewProvider {
    static var previews: some View {
        RingProgress()
    }
}
