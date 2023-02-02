//
//  ResultViewController.swift
//  AnimalCrossing
//
//  Created by Hira on 2020/5/13.
//  Copyright © 2020 1. All rights reserved.
//

import UIKit
import Kingfisher

class ResultViewController: UIViewController {

    @IBOutlet var views: ResultView!
    internal var model: AllData? = nil
    internal var isfromBugs: Bool = false
    internal var mImage: Image?
    private let viewModel: ResultViewModel = ResultViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.monthLabelArray = [views.month1, views.month2, views.month3, views.month4, views.month5, views.month6, views.month7, views.month8, views.month9, views.month10, views.month11, views.month12]
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.title = model?.name
        setupXib()
    }

    private func setupXib() {
        guard let data = model else { return }
        viewModel.setMonthLabel(allYear: data.isAllYear, southern: data.southern, northern: data.northern)
        views.nameLabel.text = "名稱：" + data.name
        views.shadowLabel.text = "魚影大小：" + viewModel.shadowChinese(shadow: data.shadow)
        views.timeLabel.text = data.isAllDay ? "出現時間：全天" : "出現時間：" + data.time
        views.addressLabel.text = "出現地點：" + viewModel.addressChinese(address: data.location, isfromBugs: isfromBugs)
        views.moneyLabel.text = "出售價錢：" + String(data.price)
        views.shadowLabel.isHidden = isfromBugs ? true : false
        
        if mImage == UIImage(named: "imageBG") {
            let type = isfromBugs ? "bugs" : "fish"
            let url = "http://acnhapi.com/images/\(type)/\((model?.id)?.description ?? "")"
            if let url = URL(string: url) {
                UIImageView().kf.setImage(with: url, placeholder: UIImage(named: "imageBG"), options: nil, progressBlock: nil) { (result) in
                    switch result {
                    case .success(let success):
                        self.views.mImageView.image = success.image
                    case .failure(_):
                        self.views.mImageView.image = UIImage(named: "imageBG")!
                    }
                }
            }
        } else {
            views.mImageView.image = mImage
        }
    }
}
