//
//  LoadingView.swift
//  AnimalCrossing
//
//  Created by Hira on 2020/5/18.
//  Copyright © 2020 1. All rights reserved.
//

import UIKit

class LoadingView: UIView {

    @IBOutlet var views: UIView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        subviewinit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        subviewinit()
    }

    private func subviewinit() {
        Bundle.main.loadNibNamed("LoadingView", owner: self, options: nil)
        self.addSubview(views)
        views.translatesAutoresizingMaskIntoConstraints = false
        views.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        views.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        views.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        views.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        loading.startAnimating()
    }
}
