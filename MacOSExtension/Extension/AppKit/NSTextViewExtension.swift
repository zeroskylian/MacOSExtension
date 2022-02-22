//
//  NSTextViewExtension.swift
//  HengLink_Mac
//
//  Created by lian on 2021/11/23.
//

import AppKit

extension NSTextView {
    var text: String? {
        get {
            return string
        }
        set {
            string = newValue ?? ""
        }
    }
    
    var attributedString: NSAttributedString {
        get {
            return attributedString()
        }
        set {
            textStorage?.setAttributedString(newValue)
        }
    }
}
