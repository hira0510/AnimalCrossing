//
//  MenuCollectionReusableView.swift
//  AnimalCrossing
//
//  Created by Hira on 2020/5/18.
//  Copyright © 2020 1. All rights reserved.
//

import UIKit

class MenuCollectionReusableView: UICollectionReusableView {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    static var nib: UINib {
        return UINib(nibName: "MenuCollectionReusableView", bundle: Bundle(for: self))
    }
    
    func config(type: String) {
        titleLabel.text = "現在可捕捉的\(type)"
    }

    func dejimaConfig(title: String) {
        titleLabel.text = title
    }
}
