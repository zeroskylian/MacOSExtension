//
//  NSViewControllerExtension.swift
//  HengLink_Mac
//
//  Created by lian on 2021/11/3.
//

import AppKit

extension NSViewController {
    
    func endWindowSheet(code: NSApplication.ModalResponse! = .cancel) {
        if let window = self.view.window {
            window.sheetParent?.endSheet(window, returnCode: code)
        }
    }
    
    func beginWindowSheet(with window: NSWindow) {
        if let wid = self.view.window {
            wid.beginSheet(window, completionHandler: { _ in })
        }
    }
    
    func beginWindowSheet(windowController: NSWindowController) {
        if let window = windowController.window {
            beginWindowSheet(with: window)
        }
    }
    
    func beginWindowSheet(viewController: NSViewController) {
        beginWindowSheet(windowController: HLAppDefaultWindowController(controller: viewController))
    }
}
