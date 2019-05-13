//
//  UICollectionView+Extension.swift
//  LiverWell
//
//  Created by Jo Yun Hsu on 2019/5/13.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    func lw_registerCellWithNib(identifier: String, bundle: Bundle?) {
        
        let nib = UINib(nibName: identifier, bundle: bundle)
        
        register(nib, forCellWithReuseIdentifier: identifier)
        
    }
    
}
