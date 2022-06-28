//
//  ChatViewModel.swift
//  Hanashi
//
//  Created by Anderson Santos Gusmão on 23/03/20.
//  Copyright © 2020 Anderson Santos Gusmão. All rights reserved.
//

import Foundation
import Combine

final class ChatViewModel {

	private let chatService = ChatService()
	private var messageSubscriber: AnyCancellable?
	@Published var messages: String = .empty

	init() {
		self.chatService.connect()
		messageSubscriber = chatService.$messages.sink { [weak self] messages in
			self?.messages = messages
		}
	}

	func send(message: String) {
		chatService.send(message: message)
	}
}
