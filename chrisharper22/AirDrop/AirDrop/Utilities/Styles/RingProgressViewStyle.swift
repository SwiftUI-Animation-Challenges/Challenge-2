//
//  RingProgressViewStyle.swift
//  AirDrop
//
//  Created by Chris Harper on 7/30/22.
//

import SwiftUI

/// A progress view that visually indicates its progress using a ring shape.
///
/// You can also use `ProgressViewStyle/ring` to construct this style.
public struct RingProgressViewStyle: ProgressViewStyle {
	private let lineWidth: CGFloat?
	private let strokeStyle: StrokeStyle?
	
	/// Creates a view representing the body of a progress view.
	public func makeBody(configuration: Configuration) -> some View {
		if lineWidth != nil {
			ZStack {
				Circle()
					.stroke(Color(uiColor: .tertiaryLabel), lineWidth: lineWidth!)
				configuration.label
				Circle()
					.trim(from: 0, to: configuration.fractionCompleted ?? 0)
					.stroke(Color.accentColor, lineWidth: lineWidth!)
			}
			.rotationEffect(.degrees(-90))
		}
		if strokeStyle != nil {
			ZStack {
				Circle()
					.stroke(Color(uiColor: .tertiaryLabel), style: strokeStyle!)
				configuration.label
				Circle()
					.trim(from: 0, to: configuration.fractionCompleted ?? 0)
					.stroke(Color.accentColor, style: strokeStyle!)
					
			}
			.rotationEffect(.degrees(-90))
		}
	}
	
	/// Creates a ring-shaped rogress view style.
	init(lineWidth: CGFloat = 10) {
		self.lineWidth = lineWidth
		self.strokeStyle = nil
	}
	
	/// Creates a ring-shaped rogress view style
	/// with the given stroke style.
	init(_ strokeStyle: StrokeStyle) {
		self.lineWidth = nil
		self.strokeStyle = strokeStyle
	}
}

public extension ProgressViewStyle where Self == RingProgressViewStyle {
	/// A progress view that visually indicates its progress using a ring
	/// shape.
	static func ring(lineWidth: CGFloat = 10) -> Self {
		.init(lineWidth: lineWidth)
	}
	
	/// A progress view that visually indicates its progress using a ring
	/// shape using the given stroke style.
	static func ring(_ strokeStyle: StrokeStyle) -> Self {
		.init(strokeStyle)
	}
}
