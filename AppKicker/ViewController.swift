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
	}
}

// MARK: - Timer
extension ViewController {
	@objc func handleTimer() {
		print("Timer fired!")
	}
}
