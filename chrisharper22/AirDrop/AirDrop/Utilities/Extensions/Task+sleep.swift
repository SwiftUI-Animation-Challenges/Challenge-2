//
//  Task+sleep.swift
//  AirDrop
//
//  Created by Chris Harper on 7/30/22.
//

import Foundation

public extension Task where Success == Never, Failure == Never {
	///Suspends the current task for at least the given duration in seconds.
	static func sleep(seconds duration: Double) async throws {
		let duration = UInt64(duration * 1_000_000_000)
		try await Task.sleep(nanoseconds: duration)
	}
}
