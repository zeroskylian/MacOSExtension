//
//  NSCollectionViewExtension.swift
//  HengLink_Mac
//
//  Created by lian on 2021/10/28.
//

import AppKit

extension NSCollectionView {
    var contentOffset: CGPoint {
        get { return enclosingScrollView?.documentVisibleRect.origin ?? .zero }
        set { scroll(newValue) }
    }
    
    var visibleIndexPaths: Set<IndexPath> {
        return indexPathsForVisibleItems()
    }
}
