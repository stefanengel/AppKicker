//
//  Script.swift
//  AppKicker
//
//  Created by Stefan Engel on 12.03.19.
//  Copyright © 2019 Stefan Engel. All rights reserved.
//

import Foundation

class Script {
	let script: String

	init(script: String) {
		self.script = script
	}
}

extension Script {
	fileprivate func getContent(from pipe: Pipe) -> String? {
		return NSString(data: pipe.fileHandleForReading.readDataToEndOfFile(), encoding: String.Encoding.utf8.rawValue) as String?
	}

	func execute(completion: @escaping (ScriptResult) -> Void) {
		let process = Process()
		process.launchPath = "/bin/sh"
		process.arguments = ["-c", script]

		let standardOut = Pipe()
		process.standardOutput = standardOut
		let standardError = Pipe()
		process.standardError = standardError

		process.launch()
		process.terminationHandler = { process in
			completion(ScriptResult(exitCode: process.terminationStatus,
									standardOut: self.getContent(from: standardOut) ?? "",
									standardError: self.getContent(from: standardError) ?? ""))
		}
	}
}
