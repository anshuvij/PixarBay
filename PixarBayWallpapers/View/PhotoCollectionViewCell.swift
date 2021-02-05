//
//  PhotoCollectionViewCell.swift
//  GetPhotos
//
//  Created by Anshu Vij on 8/12/20.
//  Copyright © 2020 anshu vij. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: CustomImageView!
    @IBOutlet weak var authorName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderWidth = 1
    }

}
