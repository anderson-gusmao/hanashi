//
//  String+Reuse.swift
//  Hanashi
//
//  Created by Anderson Santos Gusmão on 23/03/20.
//  Copyright © 2020 Anderson Santos Gusmão. All rights reserved.
//

import Foundation

extension String {
	static let empty = ""
	static let enter = "\n"

	func formatChatMessage() -> String {
		let hour = Calendar.current.component(.hour, from: Date())
		let minute = Calendar.current.component(.minute, from: Date())
		let second = Calendar.current.component(.second, from: Date())
		return "[\(hour):\(minute):\(second)] \(self)\(String.enter)"
	}
}
