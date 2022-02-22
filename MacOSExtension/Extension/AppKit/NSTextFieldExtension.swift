//
//  NSTextFieldExtension.swift
//  HengLink_Mac
//
//  Created by lian on 2021/11/18.
//

import AppKit

extension NSTextField {
    
    var text: String? {
        get {
            return stringValue
        }
        set {
            stringValue = newValue ?? ""
        }
    }
}
