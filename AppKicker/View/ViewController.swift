//
//  ViewController.swift
//  AppKicker
//
//  Created by Stefan Engel on 12.03.19.
//  Copyright © 2019 Stefan Engel. All rights reserved.
//

import Cocoa
import PromiseKit

class ViewController: NSViewController {
	@IBOutlet weak var applicationLabel: NSTextField!
	@IBOutlet weak var scriptLabel: NSTextField!
	@IBOutlet weak var intervalLabel: NSTextField!
	@IBOutlet weak var connectionLabel: NSTextField!
	@IBOutlet weak var conditionLabel: NSTextField!
	@IBOutlet weak var applicationPopup: NSPopUpButton!
	@IBOutlet weak var scriptTextField: NSTextField!
	@IBOutlet weak var intervalTextField: NSTextField!
	@IBOutlet weak var connectionTextField: NSTextField!
	@IBOutlet weak var enableScriptCheckbox: NSButton!
	@IBOutlet weak var enableConnectionCheckbox: NSButton!
	@IBOutlet weak var verticalStackView: NSStackView!
	@IBOutlet weak var startButton: NSButton!
	@IBOutlet var logView: NSTextView!

	var apps: [String: URL] = [:]
	
	@IBAction func enableScriptCheckboxPressed(_ sender: Any) {
		scriptTextField.isEnabled = enableScriptCheckbox.state == .on
		scriptLabel.alphaValue = enableScriptCheckbox.state == .on ? 1.0 : 0.5
	}
	
	@IBAction func enableConnectionCheckboxPressed(_ sender: Any) {
		connectionTextField.isEnabled = enableConnectionCheckbox.state == .on
		connectionLabel.alphaValue = enableConnectionCheckbox.state == .on ? 1.0 : 0.5
	}

	@IBAction func startButtonPressed(_ sender: Any) {
		guard let interval = Int(intervalTextField.stringValue) else {
			return
		}

		Timer.scheduledTimer(timeInterval: TimeInterval(interval), target: self, selector: #selector(handleTimer), userInfo: nil, repeats: true)
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		applicationLabel.stringValue = "Anwendung:"
		scriptLabel.stringValue = "Script:"
		intervalLabel.stringValue = "Interval (seconds):"
		intervalTextField.formatter = IntegerValueFormatter()
		connectionLabel.stringValue = "Ensure connection to:"
		conditionLabel.stringValue = "Conditions"

		enableScriptCheckbox.title = "Enabled"
		enableConnectionCheckbox.title = "Enabled"

		verticalStackView.setCustomSpacing(30.0, after: startButton)

		logView.isEditable = false
		logView.font = NSFont(name: "Courier New", size: 12.0)
		Logger.shared.textView = logView

		for app in NSWorkspace.shared.runningApplications {
			apps[app.executableURL!.lastPathComponent] = app.executableURL!
		}

		let sortedAppUrls = apps.values.sorted(by: { lhs, rhs in
			return lhs.absoluteString < rhs.absoluteString
			return lhs.lastPathComponent < rhs.lastPathComponent
		})

		for appUrl in sortedAppUrls {
			applicationPopup.addItem(withTitle: appUrl.lastPathComponent)
		}
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}
}

enum AppKickerError: Error {
	case noConditionSpecified
	case scriptConditionNotMet
	case connectionConditionNotMet
}

extension ViewController {
	fileprivate func check(appWithUrl appUrl: URL) {
		firstly {
			return Promise<Void> { seal in
				if enableScriptCheckbox.state == .off
					&& enableConnectionCheckbox.state == .off {
					seal.reject(AppKickerError.noConditionSpecified)
					return
				}

				seal.fulfill(())
			}
		}
		.then {
			return Promise<Void> { seal in
				if self.enableScriptCheckbox.state == .on {
					let script = Script(script: self.scriptTextField.stringValue)

					script.execute { result in
						if result.exitCode == 0 {
							seal.fulfill(())
							return
						}
						else {
							seal.reject(AppKickerError.scriptConditionNotMet)
							return
						}
					}
				}

				seal.fulfill(())
			}
		}
		.then {
			return Promise<Void> { seal in
				if self.enableConnectionCheckbox.state == .on {
					if let url = URL(string: self.connectionTextField.stringValue) {
						let connectionChecker = ConnectionChecker(url: url)

						connectionChecker.canConnect() { canConnect in
							if canConnect {
								seal.fulfill(())
								return
							}
							else {
								seal.reject(AppKickerError.connectionConditionNotMet)
								return
							}
						}
					}
				}

				seal.fulfill(())
			}
		}
		.catch { _ in
			AppRestarter.restart(app: appUrl)
		}
	}
}

// MARK: - Timer
extension ViewController {
	@objc func handleTimer() {
		guard let appUrl = apps[applicationPopup.selectedItem!.title] else {
			return
		}

		check(appWithUrl: appUrl)
	}
}
