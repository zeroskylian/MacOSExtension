//
//  NSScrollViewExtension.swift
//  HengLink_Mac
//
//  Created by lian on 2021/12/28.
//

import AppKit

extension NSScrollView {
    func scrollToBottom() {
        if hasVerticalScroller {
            verticalScroller?.floatValue = 1
        }
        let y = (documentView?.height ?? 0) - contentSize.height
        contentView.scroll(to: CGPoint(x: 0, y: y))
    }
}
