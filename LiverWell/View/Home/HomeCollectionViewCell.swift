//
//  HomeCollectionViewCell.swift
//  LiverWell
//
//  Created by 徐若芸 on 2019/4/3.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!

    func layoutCell(image: String) {

        imageView.image = UIImage(named: image)

    }

}
