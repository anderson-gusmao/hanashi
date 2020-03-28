//
//  Payload.swift
//  Hanashi
//
//  Created by Anderson Santos Gusmão on 28/03/20.
//  Copyright © 2020 Anderson Santos Gusmão. All rights reserved.
//

import Foundation

struct Payload: Encodable {

	var message: String
	var data: String

	func toJson() -> String {
		guard let data = try? JSONEncoder().encode(self) else { return .empty }
		return String(data: data, encoding: .utf8) ?? .empty
	}
}
