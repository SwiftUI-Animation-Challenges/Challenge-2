//
//  AirDropAvatar.swift
//  AirDrop
//
//  Created by Chris Harper on 7/30/22.
//

import SwiftUI

struct AirDropAvatar: View {
	@ObservedObject var viewModel: AirDropAvatarViewModel
	let spacing: CGFloat?
    var body: some View {
		ZStack(alignment: .center) {
			Image(systemName: "person.crop.circle.fill")
				.resizable()
				.aspectRatio(contentMode: .fit)
				.foregroundColor(.secondary)
				.padding(spacing ?? 10)
			ProgressView(value: viewModel.progress)
				.progressViewStyle(.ring())
				.opacity(viewModel.progressOpacity)
				.animation(viewModel.state == .idle ? nil : .easeOut(duration: 3), value: viewModel.progress)
				.animation(.easeOut, value: viewModel.progressOpacity)
		}
    }
	
	init(model: AirDropAvatarViewModel, spacing: CGFloat? = 10) {
		self.viewModel = model
		self.spacing = spacing
	}
}
