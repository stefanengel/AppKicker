//
//  ConnectionChecker.swift
//  AppKicker
//
//  Created by Stefan Engel on 14.03.19.
//  Copyright © 2019 Stefan Engel. All rights reserved.
//

import Foundation

class ConnectionChecker {
	let url: URL

	init(url: URL) {
		self.url = url
	}
}

// MARK: - Sending requests
extension ConnectionChecker {
	func canConnect(completion: @escaping (Bool) -> Void) {
		let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
			guard error == nil else {
				completion(false)
				return
			}

			completion(true)
		}

		task.resume()
	}
}
