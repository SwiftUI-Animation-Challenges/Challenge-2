import SwiftUI

struct Icon: View {
    var body: some View {
        GeometryReader { proxy in
            let strokeWidth = proxy.size.width / 16
            ZStack {
                Image(systemName: "person.fill")
                    .resizable()
                    .aspectRatio(CGSize(width: 1, height: 1), contentMode: .fit)
                    .foregroundColor(Color(red: 31/255, green: 31/255, blue: 31/255))
                    .clipShape(Circle())
                    .offset(y: 35)
                    .padding(40)
                    .background(Color(red: 154/255, green: 154/255, blue: 154/255))
                Circle()
                    .stroke(style: .init(lineWidth: strokeWidth))
                    .foregroundColor(Color(red: 154/255, green: 154/255, blue: 154/255))
                    .padding(strokeWidth / 2)
            }
        }.clipShape(Circle())
    }
}


struct Icon_Previews: PreviewProvider {
    static var previews: some View {
        Icon()
            .background(Color(red: 31/255, green: 31/255, blue: 31/255))
    }
}
