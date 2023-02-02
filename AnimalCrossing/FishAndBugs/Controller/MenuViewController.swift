//
//  MenuViewController.swift
//  AnimalCrossing
//
//  Created by Hira on 2020/5/13.
//  Copyright © 2020 1. All rights reserved.
//

import UIKit
import RxSwift
import Kingfisher

class MenuViewController: UIViewController {

    @IBOutlet var views: MenuView!

    private let viewModel: AnimalViewModel = AnimalViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = false
        setupCollectionViewAndRegisterXib()
        setSwitch()
        let mViews = LoadingView(frame: UIScreen.main.bounds)
        self.view.addSubview(mViews)
        self.tabBarController?.tabBar.isHidden = true

        self.viewModel.callSaveData(type: "fish", count: 80) {
            self.viewModel.callSaveData(type: "bugs", count: 80) {
                self.viewModel.nowCanCatch(type: "fish") {
                    self.viewModel.nowCanCatch(type: "bugs") {
                        self.tabBarController?.tabBar.isHidden = false
                        mViews.removeFromSuperview()
                        self.views.mCollection.reloadData()
                    }
                }
            }
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
        views.mCollection.register(MenuCollectionReusableView.nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "MenuCollectionReusableView")
    }

    private func reloadCanCatchData(isSouth: Bool) {
        views.timeLabel.text = viewModel.getNowTime().2
        viewModel.canCatchFishId = []
        viewModel.canCatchBugsId = []
        viewModel.canCatchFish = []
        viewModel.canCatchBugs = []
        viewModel.canCatchFishImageArray = []
        viewModel.canCatchBugsImageArray = []
        for i in 0...79 {
            self.viewModel.stringToAddCanCatch(isSouthern: isSouth, model: self.viewModel.fishAllData[i], type: "fish")
            self.viewModel.stringToAddCanCatch(isSouthern: isSouth, model: self.viewModel.bugsAllData[i], type: "bugs")
        }
        self.viewModel.nowCanCatch(type: "fish") {
            self.viewModel.nowCanCatch(type: "bugs") { }
        }
    }

    private func setSwitch() {
        views.timeLabel.text = viewModel.getNowTime().2
        views.dejimaButton.addTarget(self, action: #selector(didClickDejimaBtn), for: .touchUpInside)
        views.switchControl.addTarget(self, action: #selector(switchValueChange), for: .valueChanged)
        let isSouth = UserDefaults.standard.bool(forKey: "isSouth")
        if isSouth {
            views.switchControl.selectedSegmentIndex = 1
        } else {
            views.switchControl.selectedSegmentIndex = 0
        }
    }
    
    @objc func didClickDejimaBtn(sender: UIButton) {
        let vc = UIStoryboard.init(name: "AnimalMain", bundle: nil).instantiateViewController(withIdentifier: "DejimaViewController") as! DejimaViewController
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc func switchValueChange(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 1 {
            UserDefaults.standard.set(true, forKey: "isSouth")
            reloadCanCatchData(isSouth: true)
        } else {
            UserDefaults.standard.set(false, forKey: "isSouth")
            reloadCanCatchData(isSouth: false)
        }
        views.mCollection.reloadData()
    }
}

extension MenuViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return viewModel.canCatchFish.count == 0 ? 0 : viewModel.canCatchFish.count
        } else {
            return viewModel.canCatchBugs.count == 0 ? 0 : viewModel.canCatchBugs.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnimalCollectionViewCell", for: indexPath) as! AnimalCollectionViewCell

        if indexPath.section == 0 {
            guard viewModel.canCatchFish.count > 0 else { return cell }
            let model = viewModel.canCatchFish[indexPath.item]
            cell.configCell(name: model.name, id: String(model.id), price: model.price, isBug: false)
            return cell
        } else {
            guard viewModel.canCatchBugs.count > 0 else { return cell }
            let model = viewModel.canCatchBugs[indexPath.item]
            cell.configCell(name: model.name, id: String(model.id), price: model.price, isBug: true)
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "AnimalMain", bundle: nil).instantiateViewController(withIdentifier: "ResultViewController") as! ResultViewController
        if indexPath.section == 0 {
            guard viewModel.canCatchFish.count > 0 else { return }
            vc.model = viewModel.canCatchFish[indexPath.item]
            vc.mImage = viewModel.canCatchFishImageArray[indexPath.item]
            vc.isfromBugs = false
        } else {
            guard viewModel.canCatchBugs.count > 0 else { return }
            vc.model = viewModel.canCatchBugs[indexPath.item]
            vc.mImage = viewModel.canCatchBugsImageArray[indexPath.item]
            vc.isfromBugs = true
        }
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
        return UIEdgeInsets(top: 20, left: 10, bottom: 50, right: 10)
    }

    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        let header = view as! MenuCollectionReusableView
        if indexPath.section == 0 {
            header.config(type: "魚類")
        } else {
            header.config(type: "昆蟲")
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "MenuCollectionReusableView", for: indexPath)
        return header
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 30)
    }
}
