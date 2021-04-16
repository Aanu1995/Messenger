//
//  Extension.swift
//  Messenger
//
//  Created by user on 10/04/2021.
//

import UIKit

extension UIView {
    
    var width: CGFloat {
        return frame.size.width
    }
    
    var height: CGFloat {
        return frame.size.height
    }
    
    var left: CGFloat {
        return frame.origin.x
    }
    
    var right: CGFloat {
        return left + width
    }
    
    var top: CGFloat {
        return frame.origin.y
    }
    
    var bottom: CGFloat {
        return top + height
    }
}

// MARK: Notification

extension Notification.Name {
    static let googleSignIn = Notification.Name("googleSignIn")
}

extension String {
    
    subscript (r: Range<Int>) -> String {
        
        let range = Range(uncheckedBounds: (lower: max(0, min(count, r.lowerBound)),
                                                upper: min(count, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
    
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }
    
    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, count) ..< count]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }
    
    func sentencecased() -> String {
        let allLowerCase = lowercased()[1 ..< count]
        return uppercased()[0] + allLowerCase
    }
}

extension Date {
    func parseString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: self)
    }
}
