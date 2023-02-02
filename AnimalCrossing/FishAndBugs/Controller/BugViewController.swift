//
//  BugViewController.swift
//  AnimalCrossing
//
//  Created by Hira on 2020/5/13.
//  Copyright © 2020 1. All rights reserved.
//

import UIKit
import RxSwift
import Kingfisher

class BugViewController: UIViewController {

    @IBOutlet var views: BugView!

    private let viewModel: AnimalViewModel = AnimalViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionViewAndRegisterXib()
        views.loading.startAnimating()
        viewModel.callSaveData(type: "bugs", count: 80) {
            self.views.mCollection.reloadData()
            self.views.loading.stopAnimating()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        views.mCollection.reloadData()
    }

    private func setupCollectionViewAndRegisterXib() {
        views.mCollection.delegate = self
        views.mCollection.dataSource = self
        views.mCollection.register(AnimalCollectionViewCell.nib, forCellWithReuseIdentifier: "AnimalCollectionViewCell")
    }
}

extension BugViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.bugsAllData.count == 0 ? 0 : viewModel.bugsAllData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnimalCollectionViewCell", for: indexPath) as! AnimalCollectionViewCell
        guard viewModel.bugsAllData.count > 0 else { return cell }
        let model = viewModel.bugsAllData[indexPath.item]
        cell.configCell(name: model.name, id: String(model.id), price: model.price, isBug: true)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "AnimalMain", bundle: nil).instantiateViewController(withIdentifier: "ResultViewController") as! ResultViewController
        guard viewModel.bugsAllData.count > 0 else { return }
        vc.model = viewModel.bugsAllData[indexPath.item]
        vc.mImage = viewModel.bugsImageArray[indexPath.item]
        vc.isfromBugs = true
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
