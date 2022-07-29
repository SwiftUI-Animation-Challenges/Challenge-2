//
//  AirdropTargetView.swift
//  Challenge2
//
//  Created by Matt Pfeiffer on 7/29/22.
//

import SwiftUI

struct AirdropTargetView: View {
    @ObservedObject var viewModel: AirdropTargetViewModel
    
    init(name: String, image: Image? = nil) {
        viewModel = AirdropTargetViewModel(name: name, image: image)
    }
    
    var body: some View {
        ZStack {
            
            VStack(spacing: 2) {
                PersonProgressView(image: viewModel.image,
                                   progress: viewModel.progress,
                                   sendState: viewModel.sendState)
                    .frame(width: 150, height: 150)
                    .padding(.bottom, 10)
                
                Text("\(viewModel.name)'s iPhone")
                    .foregroundColor(.white)
                    .font(.system(size: 14))
                
                Text(viewModel.stateText)
                    .opacity(viewModel.opacity)
                    .foregroundColor(viewModel.sendState.color)
                    .font(.system(size: 14))
            }
            .contentShape(Rectangle())
            .onTapGesture {
                viewModel.simulateInitiate()
            }
        }
        .onDisappear {
            viewModel.timer?.invalidate()
        }
    }
}
struct AirdropTargetView_Previews: PreviewProvider {
    static var previews: some View {
        AirdropTargetView(name: "Mock Name")
    }
}
