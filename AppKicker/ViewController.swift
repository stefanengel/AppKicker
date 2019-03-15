//
//  ViewController.swift
//  AppKicker
//
//  Created by Stefan Engel on 12.03.19.
//  Copyright © 2019 Stefan Engel. All rights reserved.
//

import Cocoa

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
		execute()
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
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
			applicationPopup.addItem(withTitle: app.executableURL!.lastPathComponent)
		}
	}

	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}
}

extension ViewController {
	fileprivate func execute() {
		let script = Script(script: scriptTextField.stringValue)

		script.execute { result in
			print(result)
		}

		if let url = URL(string: connectionTextField.stringValue) {
			let connectionChecker = ConnectionChecker(url: url)

			connectionChecker.canConnect() { canConnect in
				print("Can connect? \(canConnect)")
			}
		}
	}
}

// MARK: - Timer
extension ViewController {
	@objc func handleTimer() {
		Logger.shared.log(message: "Timer fired")
	}
}
