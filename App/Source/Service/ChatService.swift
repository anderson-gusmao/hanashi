//
//  ChatService.swift
//  Hanashi
//
//  Created by Anderson Santos Gusmão on 28/03/20.
//  Copyright © 2020 Anderson Santos Gusmão. All rights reserved.
//

import Foundation

final class ChatService {

	// MARK: Constants

	private struct Constant {
		static let awsRegion = "us-east-1"
		static let apiGatewayId = "wodglhhpnl"
		static let stage = "Prod"
		static let url = "wss://\(apiGatewayId).execute-api.\(awsRegion).amazonaws.com/\(stage)"
		static let genericError = "Oops! Something wrong is happening!"
		static let operationName = "sendmessage"
	}

	// MARK: Properties

	private var webSocketTask: URLSessionWebSocketTask?
	@Published var messages: String = .empty

	// MARK: Public methods

	func connect() {
		guard let url = URL(string: Constant.url) else { fatalError() }
		webSocketTask = URLSession(configuration: .default).webSocketTask(with: url)
		webSocketTask?.resume()
		runMessageLoop()
	}

	func disconnect() {
		webSocketTask?.cancel(with: .goingAway, reason: nil)
	}

	func send(message: String) {
		let payload = Payload(message: Constant.operationName, data: message).toJson()
		let message = URLSessionWebSocketTask.Message.string(payload)
		webSocketTask?.send(message) { [weak self] error in
			guard let _ = error else { return }
			self?.messages += Constant.genericError
		}
	}
}

// MARK: Private extension

private extension ChatService {

	func runMessageLoop()  {
		webSocketTask?.receive { [weak self] result in
			switch result {
			case .failure(_):
				self?.messages += Constant.genericError
			case .success(let response):
				guard case let .string(message) = response else { return }
				self?.messages += message.formatChatMessage()
			}
			self?.runMessageLoop()
		}
	}
}
