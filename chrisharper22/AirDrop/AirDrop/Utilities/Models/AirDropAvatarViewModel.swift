//
//  AirDropAvatarViewModel.swift
//  AirDrop
//
//  Created by Chris Harper on 7/30/22.
//

import Combine
import SwiftUI

/// The view model for a `AirDropAvatar`,
@MainActor class AirDropAvatarViewModel: ObservableObject {
	/// The current state of AirDrop, as an ``AirDropState``.
	@Published var state: AirDropState = .idle
	/// The progress of AirDrop.
	@Published var progress: Double = 0.0
	/// The opacity of the AirDrop progress indicator.
	@Published var progressOpacity: Double = 0.0
	/// The opacity of the AirDrop state text.
	@Published var stateOpacity: Double = 1.0
	/// The timer responsible for the flashing of the AirDrop state text when waiting.
	@Published var timer = Timer.publish(every: 0.75, on: .main, in: .common).autoconnect()
	
	/// The possible states of AirDrop.
	enum AirDropState {
		/// An idle state.
		case idle
		/// A waiting state.
		case waiting
		/// A sending state in which data is being transferred.
		case sending
		/// A completed state where data transfer is complete.
		case complete
	}
	
	/// The text of an ``AirDropState``.
	var stateText: String {
		switch state {
		case .idle:
			return " "
		case .waiting:
			return "Waiting..."
		case .sending:
			return "Sending..."
		case .complete:
			return "Sent"
		}
	}
	
	/// A `Bool` indicating whether or not AirDrop is running.
	var running: Bool {
		switch state {
		case .idle, .complete:
			return false
		case .waiting, .sending:
			return true
		}
	}
	
	/// The text of the button as a result of the current ``AirDropState``.
	var buttonText: String {
		switch state {
		case .idle:
			return "Start"
		case .waiting, .sending:
			return "Running"
		case .complete:
			return "Reset"
		}
	}
	
	/// Set the state opacity according to the current A``AirDropState``.
	func updateStateOpacity() {
		switch state {
		case .idle:
			stateOpacity = 0
		case .waiting:
			stateOpacity == 0 ? (stateOpacity = 1.0) : (stateOpacity = 0.0)
		default:
			stateOpacity = 1.0
		}
	}
	
	/// The action of the button as a result of the current ``AirDropState``.
	func buttonAction() {
		switch state {
		case .idle:
			Task { await prepareAirDrop() }
		case .complete:
			resetAirDrop()
		default:
			fatalError("AvatarViewModel.buttonAction(): really, this shouldn't have happened.")
		}
	}
	
	/// The role of the button as a result of the current ``AirDropState``.
	var buttonRole: ButtonRole? {
		switch state {
		case .idle, .waiting, .sending:
			return .none
		case .complete:
			return .destructive
		}
	}
	
	/// The color of an ``AirDropState``.
	var stateColor: Color {
		switch state {
		case .idle:
			return .primary
		case .waiting, .sending:
			return .secondary
		case .complete:
			return .accentColor
		}
	}

	/// Resets properties to their defaults.
	private func resetAirDrop() {
		state = .idle
		progressOpacity = 0.0
		progress = 0.0
		stateOpacity = 1.0
	}
	
	/// The first stage of the AirDrop animation.
	private func prepareAirDrop() async {
		state = .waiting
		progressOpacity = 1.0
		await commenceAirDrop()
	}
	
	/// The second stage of the AirDrop animation.
	private func commenceAirDrop() async {
		try? await Task.sleep(seconds: 5)
		state = .sending
		progress = 1.0
		await finishAirDrop()
	}
	
	/// The third stage of the AirDrop animation.
	private func finishAirDrop() async {
		try? await Task.sleep(seconds: 3.25)
		state = .complete
		try? await Task.sleep(seconds: 1.25)
		progressOpacity = 0.0
	}
}
