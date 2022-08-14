import SwiftUI

struct PulsatingText: View {

    let text: String

    @State private var animationState: Double = 0

    init(_ text: String) {
        self.text = text
    }

    private var opacity: Double {
        1 - animationState
    }

    var animation: Animation {
        .default
        .speed(0.5)
        .repeatForever()
    }

    var body: some View {
        Text(text)
            .opacity(opacity)
            .animation(animation, value: animationState)
            .onAppear { animationState = 1 }
    }
}


struct PulsatingText_Previews: PreviewProvider {
    static var previews: some View {
        PulsatingText("Waiting...")
    }
}
