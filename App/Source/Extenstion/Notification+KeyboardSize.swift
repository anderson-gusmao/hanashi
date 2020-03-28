//
//  Notification+KeyboardSize.swift
//  Hanashi
//
//  Created by Anderson Santos Gusmão on 23/03/20.
//  Copyright © 2020 Anderson Santos Gusmão. All rights reserved.
//

import UIKit

extension Notification {
	var keyboardSize: CGRect? {
		return (self.userInfo?  [UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
	}
}
