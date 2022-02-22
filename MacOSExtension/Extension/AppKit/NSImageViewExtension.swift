//
//  NSImageViewExtension.swift
//  HengLink_Mac
//
//  Created by lian on 2021/7/13.
//

import Foundation
import Kingfisher
import AppKit

public enum HLDownloadImageType {
    case network
    case sandbox
}

enum MessagePlaceholder {
    /// 默认头像 46 * 46
    case avatar
    
    /// 60 * 60 头像
    case sizeAvatar
    
    /// 通话呼叫
    case call
    
    /// 文件分享
    case fileShare
    
    /// 无
    case none
    
    /// 工作台
    case workTop
    
    /// 自定义图片
    case custom(image: NSImage, processor: ImageProcessor?)
    
    func image() -> NSImage? {
        switch self {
        case .avatar:
            return Asset.messageDefatultAvatar.image
        case .sizeAvatar:
            return Asset.messageDefatultAvatar.image
        case .fileShare:
            return nil
        case .workTop:
            return Asset.Message.iconChatFileshare.image
        case .none:
            return nil
        case .call:
            return nil
        case .custom(let image, processor: _):
            return image
        }
    }
}

extension NSImageView {
    func setImage(_ url: String?, placeholder: MessagePlaceholder, thumbnail: Bool = true, loadfileType: HLDownloadImageType? = .network) {
        let image = placeholder.image()
        self.image = image
        guard let urlString = url, urlString.count > 0 else { return }
        let queryAllow = urlString.queryAllow
        switch loadfileType {
        case .sandbox:
            self.kf.setImage(with: URL(fileURLWithPath: queryAllow), placeholder: image)
        default:
            let path = URL(string: queryAllow)
            var option: KingfisherOptionsInfo = [.cacheOriginalImage]
            switch placeholder {
            case .avatar:
                option += [.processor(HLImageProcessor.avatar)]
            case .sizeAvatar:
                option += [.processor(HLImageProcessor.sizeAvatar)]
            case .call:
                option += [.processor(HLImageProcessor.call)]
            case .fileShare:
                option += [.processor(HLImageProcessor.default)]
            case .workTop:
                if urlString.pathExtension == "svg" {
                    option += [.processor(HLSvgImageProcessor.default)]
                }
            case .custom(image: _, processor: let processor):
                if let process = processor {
                    option += [.processor(process)]
                }
            default:
                break
            }
            self.kf.setImage(with: path, placeholder: image, options: option)
        }
    }
}
