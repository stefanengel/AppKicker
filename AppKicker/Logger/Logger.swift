//
//  Logger.swift
//  AppKicker
//
//  Created by Stefan Engel on 15.03.19.
//  Copyright © 2019 Stefan Engel. All rights reserved.
//

import Cocoa
import os.log

class Logger {
	static var shared = Logger()
	weak var textView: NSTextView?
}

// MARK: - Logging
extension Logger {
	func log(message: String) {
		guard let textView = textView else {
			return
		}

		DispatchQueue.main.async { [weak self] in
			textView.string.append("\n\(NSDate()) \(message)")
			textView.scrollToEndOfDocument(self)
		}
		os_log("%{PUBLIC}@", log: OSLog.actions, type: .info, message)
	}
}

// MARK: - OSLog
extension OSLog {
	private static var subsystem = Bundle.main.bundleIdentifier!

	static let actions = OSLog(subsystem: subsystem, category: "actions")
}
