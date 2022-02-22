//
//  NSTableViewExtension.swift
//  HengLink_Mac
//
//  Created by lian on 2021/6/30.
//

import AppKit

extension NSTableView {
    
    /// 可视范围内容
    var visibleRows: NSRange {
        return rows(in: visibleRect)
    }
    
    /// 滚动到某一行
    /// - Parameters:
    ///   - row: 行数
    ///   - animated: 是否有动画
    func scrollRowToVisible(row: Int, animated: Bool) {
        if animated {
            let rowRect = self.rect(ofRow: row)
            var scrollOrigin = rowRect.origin
            let clipView = self.superview as? NSClipView
            
            let tableHalfHeight = clipView!.frame.height * 0.5
            let rowRectHalfHeight = rowRect.height * 0.5
            
            scrollOrigin.y = (scrollOrigin.y - tableHalfHeight) + rowRectHalfHeight
            let scrollView = clipView!.superview as? NSScrollView
            
            if scrollView!.responds(to: #selector(NSScrollView.flashScrollers)) {
                scrollView!.flashScrollers()
            }
            clipView!.animator().setBoundsOrigin(scrollOrigin)
        } else {
            self.scrollRowToVisible(row)
        }
    }
    
    func scroll(_ point: NSPoint, animated: Bool) {
        if animated {
            guard let clipView = self.superview as? NSClipView, let scrollView = clipView.superview as? NSScrollView else {
                scroll(point)
                return
            }
            if scrollView.responds(to: #selector(NSScrollView.flashScrollers)) {
                scrollView.flashScrollers()
            }
            clipView.animator().setBoundsOrigin(point)
        } else {
            scroll(point)
        }
        
    }
    
    /// 注册cell 使用 xib
    func registerNib<T: NSView>(name: T.Type) {
        register(NSNib(nibNamed: String(describing: name), bundle: Bundle.main), forIdentifier: NSUserInterfaceItemIdentifier(String(describing: name)))
    }
    
    /// 获取复用cell
    /// - Returns: 复用 cell
    func makeView<T: NSView>(name: T.Type, owner: Any?) -> T? {
        let identifier = NSUserInterfaceItemIdentifier(String(describing: name))
        var cell = makeView(withIdentifier: identifier, owner: owner) as? T
        if cell == nil {
            cell = T(frame: CGRect(x: 0, y: 0, width: width, height: 50))
            cell?.identifier = identifier
        }
        return cell
    }
    
    /// 安全获取 cell
    /// - Parameters:
    ///   - column: 列
    ///   - row: 行
    ///   - makeIfNecessary: 是否强制生成
    /// - Returns: view
    func getSafeView(atColumn column: Int, row: Int, makeIfNecessary: Bool) -> NSView? {
        guard numberOfColumns > column else { return nil }
        guard numberOfRows > row else { return nil }
        return view(atColumn: column, row: row, makeIfNecessary: makeIfNecessary)
    }
    
    func scroll(toRect rect: CGRect, animationDuration duration: Double) {
        if let scrollView = enclosingScrollView {           // we do have a scroll view
            let clipView = scrollView.contentView           // and thats its clip view
            var newOrigin = clipView.bounds.origin          // make a copy of the current origin
            if newOrigin.x > rect.origin.x {                // we are too far to the right
                newOrigin.x = rect.origin.x                 // correct that
            }
            if rect.origin.x > newOrigin.x + clipView.bounds.width - rect.width {  // we are too far to the left
                newOrigin.x = rect.origin.x - clipView.bounds.width + rect.width   // correct that
            }
            if newOrigin.y > rect.origin.y {                // we are too low
                newOrigin.y = rect.origin.y                 // correct that
            }
            if rect.origin.y > newOrigin.y + clipView.bounds.height - rect.height {    // we are too high
                newOrigin.y = rect.origin.y - clipView.bounds.height + rect.height // correct that
            }
            NSAnimationContext.beginGrouping()              // create the animation
            NSAnimationContext.current.duration = duration  // set its duration
            clipView.animator().setBoundsOrigin(newOrigin)  // set the new origin with animation
            scrollView.reflectScrolledClipView(clipView)    // and inform the scroll view about that
            NSAnimationContext.endGrouping()                // finaly do the animation
        }
    }
    
    func keepPosition(row: Int, offset: CGFloat, insertRow: @escaping () -> Void) {
        var scrollOrigin: CGPoint = .zero
        let rowRect = rect(ofRow: row)
        let adjustScroll = rowRect != .zero && !visibleRect.contains(rowRect)
        if adjustScroll {
            let origin = visibleRect.origin
            scrollOrigin = CGPoint(x: origin.x, y: origin.y - offset)
            if isFlipped {
                scrollOrigin.y = height - scrollOrigin.y
            }
        }
        
        DispatchQueue.main.async {
            insertRow()
            if adjustScroll {
                if self.isFlipped {
                    scrollOrigin.y = self.height - scrollOrigin.y
                }
                self.scroll(scrollOrigin)
            }
        }
    }
    
    func scroll(toPoint: NSPoint, duration: TimeInterval) {
        if let scrollView = enclosingScrollView {
            NSAnimationContext.beginGrouping()
            NSAnimationContext.current.duration = duration
            let clipView = scrollView.contentView
            clipView.animator().setBoundsOrigin(toPoint)
            scrollView.reflectScrolledClipView(scrollView.contentView)
            NSAnimationContext.endGrouping()
        }
    }
}
