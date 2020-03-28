//
//  ChatViewController.swift
//  Hanashi
//
//  Created by Anderson Santos Gusmão on 23/03/20.
//  Copyright © 2020 Anderson Santos Gusmão. All rights reserved.
//

import UIKit
import Combine

final class ChatViewController: UIViewController {

	// MARK: Constant

	private struct Constant {
		static let animationTime = 0.5
		static let originalBottomValue: CGFloat = 0
	}

	// MARK: Properties

	private var chatViewModel: ChatViewModel?
	private var messageSubscriber: AnyCancellable?
	private var keyboardWillShowSubscriber: AnyCancellable?
	private var keyboardWillHideSubscriber: AnyCancellable?

	// MARK: Interface builder outlets

	@IBOutlet weak var chatTextView: UITextView!
	@IBOutlet weak var chatInputText: UITextField!
	@IBOutlet weak var composeViewBottomConstraint: NSLayoutConstraint!

	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}

	// MARK: Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		setupNotifications()
		setupUI()
	}
}

// MARK: Private extension

private extension ChatViewController {

	func setupNotifications() {
		keyboardWillShowSubscriber = NotificationCenter
			.default
			.publisher(for: UIResponder.keyboardWillShowNotification)
			.compactMap { $0.keyboardSize?.height }
			.sink { [weak self] height in
				self?.composeViewBottomConstraint.constant = height
				UIView.animate(withDuration: Constant.animationTime) { self?.view.layoutIfNeeded() }
			}

		keyboardWillHideSubscriber = NotificationCenter
		.default
		.publisher(for: UIResponder.keyboardWillHideNotification)
		.sink { [weak self] height in
			self?.composeViewBottomConstraint.constant = Constant.originalBottomValue
			UIView.animate(withDuration: Constant.animationTime) { self?.view.layoutIfNeeded() }
		}
	}

	func setupUI() {
		chatInputText.becomeFirstResponder()
		chatTextView.layoutManager.allowsNonContiguousLayout = false
		chatViewModel = ChatViewModel()
		messageSubscriber = chatViewModel?.$messages
			.receive(on: DispatchQueue.main)
			.assign(to: \.text, on: chatTextView)
	}

	func send(_ message: String) {
		chatViewModel?.send(message: message)
		chatInputText.text = .empty
		chatTextView.scrollRangeToVisible(NSMakeRange(chatTextView.text.count - 1, 1))
	}

	@IBAction func onSendDidPress(_ sender: Any) {
		guard let message = chatInputText.text, !message.isEmpty else { return }
		send(message)
	}
}
