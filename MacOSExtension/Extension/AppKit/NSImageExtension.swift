//
//  NSImageExtension.swift
//  HengLink_Mac
//
//  Created by lian on 2021/7/26.
//

import Foundation

extension NSImage {
    static func generateMarkImage(mark: String, frame: CGRect) -> NSImage? {
        let font = NSFont.systemFont(ofSize: 12, weight: .regular)
        let color = HLColor.hexEBEBEB.color
        let viewWidth = frame.width
        let viewHeight = frame.height
        let sqrtLength = sqrt(viewWidth * viewWidth + viewHeight * viewHeight)
        let attr: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: color]
        let attrStr = NSAttributedString(string: mark, attributes: attr)
        let strWidth = attrStr.size().width
        let strHeight = attrStr.size().height
        let newImage = NSImage(size: CGSize(width: viewWidth, height: viewHeight), flipped: false) { _ in
            guard let content = NSGraphicsContext.current?.cgContext else { return false }
            content.saveGState()
            content.concatenate(CGAffineTransform(translationX: viewWidth / 2, y: viewHeight / 2))
            content.concatenate(CGAffineTransform(rotationAngle: DesignKit.waterMark.rotaion))
            content.concatenate(CGAffineTransform(translationX: -viewWidth / 2, y: -viewHeight / 2))
            let horCount = Int(sqrtLength / (strWidth + DesignKit.waterMark.horziontalSpace) + 1)
            let verCount = Int(sqrtLength / (strHeight + DesignKit.waterMark.verticalSpace) + 1)
            let orignX = -(sqrtLength - viewWidth) / 2
            let orignY = -(sqrtLength - viewHeight) / 2
            var tempOrignX = orignX
            var tempOrignY = orignY
            for i in 0 ..< horCount * verCount {
                let textRect = CGRect(x: tempOrignX, y: tempOrignY, width: strWidth, height: strHeight)
                (mark as NSString).draw(in: textRect, withAttributes: attr)
                if i % horCount == 0 && i != 0 {
                    tempOrignX = orignY
                    tempOrignY += strHeight + DesignKit.waterMark.verticalSpace
                } else {
                    tempOrignX += strWidth + DesignKit.waterMark.horziontalSpace
                }
            }
            content.restoreGState()
            return true
        }
        return newImage
    }
    
    func jpegData() -> Data? {
        guard let cgImage = cgImage(forProposedRect: nil, context: nil, hints: nil) else { return nil }
        let bitmapRep = NSBitmapImageRep(cgImage: cgImage)
        let jpegData = bitmapRep.representation(using: NSBitmapImageRep.FileType.jpeg, properties: [:])!
        return jpegData
    }
}
