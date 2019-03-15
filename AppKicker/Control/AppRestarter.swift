//
//  AppRestarter.swift
//  AppKicker
//
//  Created by Stefan Engel on 15.03.19.
//  Copyright © 2019 Stefan Engel. All rights reserved.
//

import Cocoa

struct AppRestarter {

}

// MARK: - Restarting an app
extension AppRestarter {
	static func restart(app executableUrl: URL) {
		for app in NSWorkspace.shared.runningApplications {
			if app.executableURL! == executableUrl {
				app.forceTerminate()
				break
			}
		}

		NSWorkspace.shared.launchApplication(executableUrl.path)
	}
}
