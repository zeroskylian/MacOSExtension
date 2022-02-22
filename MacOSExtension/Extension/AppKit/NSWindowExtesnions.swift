//
//  NSWindowExtesnions.swift
//  HengLink_Mac
//
//  Created by lian on 2021/9/27.
//

import AppKit

extension NSWindow {
    var mouseLocation: CGPoint {
        let mouseLocation = NSEvent.mouseLocation
        let windowPoint = convertFromScreen(CGRect(origin: mouseLocation, size: .zero))
        return windowPoint.origin
    }
}
