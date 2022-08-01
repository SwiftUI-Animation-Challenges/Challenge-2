//
//  ContentView.swift
//  AirDrop
//
//  Created by Chris Harper on 7/30/22.
//

import SwiftUI

struct ContentView: View {
	@ObservedObject var viewModel = AirDropAvatarViewModel()
	
	var body: some View {
		VStack(spacing: 20) {
			Spacer()
			AirDropAvatar(model: viewModel)
				.frame(width: 225, height: 225)
			textStack
			Spacer()
			actionButton
		}
		.padding()
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
		.background {
			Color(uiColor: .secondarySystemGroupedBackground)
				.edgesIgnoringSafeArea(.all)
		}
	}
	
	var textStack: some View {
		VStack {
			Text("Colton Westfield") // some random name just because
			Group {
				if viewModel.state != .waiting {
					Text(viewModel.stateText)
						.opacity(viewModel.stateOpacity)
				} else {
					Text(viewModel.stateText)
						.opacity(viewModel.stateOpacity)
						.animation(viewModel.state == .waiting ? .easeInOut(duration: 0.75) : .none, value: viewModel.stateOpacity)
				}
			}
			.onReceive(viewModel.timer) { _ in
				viewModel.updateStateOpacity()
			}
			.foregroundColor(viewModel.stateColor)
		}
		.font(.title2)
	}
	
	var actionButton: some View {
		Button(role: viewModel.buttonRole) {
			viewModel.buttonAction()
		} label: {
			Text(viewModel.buttonText)
				.frame(width: 250)
		}
		.controlSize(.large)
		.buttonStyle(.borderedProminent)
		.disabled(viewModel.running)
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
			.preferredColorScheme(.dark)
	}
}
