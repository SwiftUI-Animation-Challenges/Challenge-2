import SwiftUI


// On the Content View, view model contains dummy data that represents AirDrop users; PersonBagde (AirDrop) views are displayed on 3 column lazyVGrid.

struct ContentView: View {
    
    @State private var progress: CGFloat = 0
    @StateObject private var viewModel = ViewModel()
    
    
    private var threeColumnGrid = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        VStack {
            Text("Tap on individual icon to start animation. Longpress to reset animation for individual icon.")
                .fontWeight(.light)
                .foregroundColor(.textColor)
                .padding([.all], 10)
            LazyVGrid(columns: threeColumnGrid, spacing: 50) {
                ForEach(viewModel.users){ user in
                    VStack {
                        PersonBadgeView(user: user)
                        // Aspect ratio setted to 1 to make circular icon even on height and width.
                            .aspectRatio(1.0, contentMode: .fit)
                        .frame(minWidth: 100, maxWidth: .infinity, minHeight: 100, maxHeight: .infinity)
                    }
                }
                .padding(.all, 10)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background{
            Color.backgroundColor
                .ignoresSafeArea(.container)
        }
    }
}
