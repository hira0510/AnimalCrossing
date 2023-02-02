//
//  DejimaCollectionViewCell.swift
//  AnimalCrossing
//
//  Created by Hira on 2020/5/25.
//  Copyright © 2020 1. All rights reserved.
//

import UIKit

class DejimaCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var introduceLabel: UILabel!
    @IBOutlet weak var mImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    static var nib: UINib {
        return UINib(nibName: "DejimaCollectionViewCell", bundle: nil)
    }
    
    public func configCell(introduce: String, image: String) {
        introduceLabel.text = introduce
        mImageView.image = UIImage(named: image)
    }
}
