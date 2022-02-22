//
//  BundleExtensions.swift
//  HengLink_Mac
//
//  Created by lian on 2021/7/8.
//

import Foundation

extension Bundle {
    static let tUIKitFace: Bundle = {
        let path = Bundle.main.path(forResource: "TUIKitFace", ofType: "bundle")!
        return Bundle(path: path)!
    }()
    
    static func tUIKitFaceEmojiLocalizedString(for key: String, value: String?) -> String {
        let language: String = "Localizable/" + "zh-Hans"
        let path = tUIKitFace.path(forResource: language, ofType: "lproj")!
        let bundle = Bundle(path: path)!
        let string = bundle.localizedString(forKey: key, value: value, table: nil)
        return Bundle.main.localizedString(forKey: key, value: string, table: nil)
    }
    
    static func tUIKitFaceEmojiLocalizedString(for key: String) -> String {
        return tUIKitFaceEmojiLocalizedString(for: key, value: nil)
    }
    
}
