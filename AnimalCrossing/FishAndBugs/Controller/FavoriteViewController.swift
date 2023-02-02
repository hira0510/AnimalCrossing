//
//  FavoriteViewController.swift
//  AnimalCrossing
//
//  Created by Hira on 2020/5/13.
//  Copyright © 2020 1. All rights reserved.
//

import UIKit
import RxSwift
import Kingfisher

class FavoriteViewController: UIViewController {

    @IBOutlet var views: FavoriteView!

    private var model: [AllData] = []
    private let viewModel: AnimalViewModel = AnimalViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionViewAndRegisterXib()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        if views.switchControl.selectedSegmentIndex == 0 {
            fetchData(fishKey: "isFavoriteFish", bugsKey: "isFavoriteBugs")
        } else {
            fetchData(fishKey: "isMuseumFish", bugsKey: "isMuseumBugs")
        }
    }

    private func setupCollectionViewAndRegisterXib() {
        views.switchControl.addTarget(self, action: #selector(switchValueChange), for: .valueChanged)
        views.mCollection.delegate = self
        views.mCollection.dataSource = self
        views.mCollection.register(AnimalCollectionViewCell.nib, forCellWithReuseIdentifier: "AnimalCollectionViewCell")
    }

    @objc func switchValueChange(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            fetchData(fishKey: "isFavoriteFish", bugsKey: "isFavoriteBugs")
        } else {
            fetchData(fishKey: "isMuseumFish", bugsKey: "isMuseumBugs")
        }
        views.mCollection.reloadData()
    }

    private func fetchBugsData() {
        for (_, value) in viewModel.canCatchBugsId.enumerated() {
            self.viewModel.fetchAllImage(id: value, type: "bugs") { (img) in
                self.viewModel.bugsImageArray.append(img)
                self.viewModel.favorCallSaveData(id: value, type: "bugs", count: self.viewModel.canCatchBugsId.count) {
                self.model += self.viewModel.bugsAllData
                self.views.mCollection.reloadData()
                self.views.loading.stopAnimating()
                }
            }
        }
    }

    private func fetchData(fishKey: String, bugsKey: String) {
        viewModel.canCatchBugsId = UserDefaults.standard.array(forKey: bugsKey) as? [Int] ?? []
        viewModel.canCatchFishId = UserDefaults.standard.array(forKey: fishKey) as? [Int] ?? []
        model = []
        viewModel.fishAllData = []
        viewModel.bugsAllData = []
        viewModel.bugsImageArray = []
        if viewModel.canCatchFishId.count + viewModel.canCatchBugsId.count != 0 {
            views.loading.startAnimating()
            if viewModel.canCatchFishId.count > 0 {
                for (_, value) in viewModel.canCatchFishId.enumerated() {
                    self.viewModel.fetchAllImage(id: value, type: "fish") { (img) in
                        self.viewModel.bugsImageArray.append(img)
                        self.viewModel.favorCallSaveData(id: value, type: "fish", count: self.viewModel.canCatchFishId.count) {
                            self.model = self.viewModel.fishAllData
                            guard self.viewModel.canCatchBugsId.count > 0 else {
                                self.views.mCollection.reloadData()
                                self.views.loading.stopAnimating()
                                return
                            }
                            self.fetchBugsData()
                        }
                    }
                }
            }
        } else {
            self.views.loading.stopAnimating()
            self.views.mCollection.reloadData()
        }
    }
}

extension FavoriteViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnimalCollectionViewCell", for: indexPath) as! AnimalCollectionViewCell
        guard model.count > 0 else { return cell }
        let models = model[indexPath.item]
        let isBug = indexPath.item + 1 > viewModel.fishAllData.count ? true : false
        cell.configCell(name: models.name, id: String(models.id), price: models.price, isBug: isBug)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "AnimalMain", bundle: nil).instantiateViewController(withIdentifier: "ResultViewController") as! ResultViewController
        guard model.count > 0 else { return }
        vc.model = model[indexPath.item]
        vc.mImage = self.viewModel.bugsImageArray[indexPath.item]
        vc.isfromBugs = indexPath.item + 1 > viewModel.fishAllData.count ? true : false
        navigationController?.pushViewController(vc, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 90, height: 150)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
    }
}
