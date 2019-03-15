//
//  IntegerValueFormatter.swift
//  AppKicker
//
//  Created by Stefan Engel on 12.03.19.
//  Copyright © 2019 Stefan Engel. All rights reserved.
//

import Foundation

class IntegerValueFormatter: NumberFormatter {
	override func isPartialStringValid(_ partialString: String, newEditingString newString: AutoreleasingUnsafeMutablePointer<NSString?>?, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
		return partialString.isEmpty || Int(partialString) != nil
	}
}
