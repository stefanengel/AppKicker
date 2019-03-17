//
//  AppRestarter.swift
//  AppKicker
//
//  Created by Stefan Engel on 15.03.19.
//  Copyright © 2019 Stefan Engel. All rights reserved.
//

import Cocoa

class AppRestarter {
	static var currentApp: NSRunningApplication?
}

// MARK: - Restarting an app
extension AppRestarter {
	static func restart(app executableUrl: URL) {
		guard currentApp == nil else {
			Logger.shared.log(message: "App termination already in progress, ignoring new request")
			return
		}

		for app in NSWorkspace.shared.runningApplications {
			if app.executableURL! == executableUrl {
				currentApp = app
				Logger.shared.log(message: "Calling forceTerminate")
				app.forceTerminate()

				Timer.scheduledTimer(timeInterval: TimeInterval(5), target: self, selector: #selector(start), userInfo: nil, repeats: false)
				break
			}
		}
	}

	@objc static func start() {
		guard let url = currentApp?.executableURL else {
			currentApp = nil
			return
		}

		currentApp = nil
		Logger.shared.log(message: "Calling launchApplication")
		NSWorkspace.shared.launchApplication(url.path)
	}
}
