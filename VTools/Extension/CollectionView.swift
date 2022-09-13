//
//  CollectionView.swift
//  VTools
//
//  Created by Jarvis on 2022/4/18.
//

import Foundation

extension UICollectionView {
    
    /// 尾部视图的Kind
    public class func footerViewKind() -> String {
        return "UICollectionElementKindSectionFooter"
    }
    
    /// 头部视图的Kind
    public class func headerViewKind() -> String {
        return "UICollectionElementKindSectionHeader"
    }
    
    /// 刷新完成后有回调
    /// - Parameter completionCallback: 回调
    public func reloadData(completionCallback:@escaping () -> Void) {
        UIView.performWithoutAnimation { [weak self] in
            guard let self = self else {return}
            self.reloadData()
        }
        self.performBatchUpdates(nil) { (_) in
            // TODO: 某个任务
            DispatchQueue.main.async() {
                completionCallback()
            }
        }
    }
}
