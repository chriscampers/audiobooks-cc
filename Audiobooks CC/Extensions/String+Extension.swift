//
//  Strings+Extension.swift
//  Audiobooks CC
//
//  Created by Chris Campanelli on 2025-10-24.
//

import Foundation
import UIKit

// Taken from: https://stackoverflow.com/a/57345508
extension String {
    var removingHTMLTags: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
