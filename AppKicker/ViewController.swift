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
	@IBOutlet weak var applicationPopup: NSPopUpButton!
	@IBOutlet weak var scriptTextField: NSTextField!
	@IBOutlet weak var intervalTextField: NSTextField!
	
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
