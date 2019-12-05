//
//  UIView + Snapshot.swift
//  CollectionViewDemo
//
//  Created by 高士傑 on 2019/12/5.
//  Copyright © 2019 AppCoda. All rights reserved.
//

import UIKit

//取得快照
extension UIView {
    var snapshot: UIImage? {
        var image: UIImage? = nil
        UIGraphicsBeginImageContext(bounds.size)
        
        //以一個視圖的大小建立一個點陣圖為主的圖形內容
        if let context = UIGraphicsGetCurrentContext() {
            
            //透過該圖形內容來渲染視圖的內容
            self.layer.render(in: context)
            
            //取得圖片
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        
        return image
    }
}
