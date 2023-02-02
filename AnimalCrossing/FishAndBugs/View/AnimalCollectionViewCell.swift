//
//  AnimalCollectionViewCell.swift
//  AnimalCrossing
//
//  Created by Hira on 2020/5/13.
//  Copyright © 2020 1. All rights reserved.
//

import UIKit
import Kingfisher

class AnimalCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var mImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var museumButton: UIButton!
    @IBOutlet weak var view: UIView!
    
    private var isFavorite: Bool = false
    private var isMuseum: Bool = false
    private var isBug: Bool = false
    private var id: Int = 0
    private var favoritesData: [Int] = []
    private var museumData: [Int] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        favoriteButton.addTarget(self, action: #selector(didClickFavoriteBtn), for: .touchUpInside)
        museumButton.addTarget(self, action: #selector(didClickMuseumBtn), for: .touchUpInside)
        view.layer.cornerRadius = 10
    }

    static var nib: UINib {
        return UINib(nibName: "AnimalCollectionViewCell", bundle: nil)
    }
    
    @objc func didClickMuseumBtn() {
        isMuseum = !isMuseum
        isMuseum ? museumButton.setImage(UIImage(named: "owl_icon_fill"), for: .normal) : museumButton.setImage(UIImage(named: "owl_icon"), for: .normal)
        museumData = isBug ? UserDefaults.standard.array(forKey: "isMuseumBugs") as? [Int] ?? []: UserDefaults.standard.array(forKey: "isMuseumFish") as? [Int] ?? []
        if museumData.contains(id) {
            for i in 0..<museumData.count {
                if museumData[i] == id {
                    museumData.remove(at: i)
                    break
                }
            }
        } else {
            museumData.append(id)
        }
        if isBug {
            UserDefaults.standard.set(museumData, forKey: "isMuseumBugs")
        } else {
            UserDefaults.standard.set(museumData, forKey: "isMuseumFish")
        }
        
        if isMuseum {
            view.layer.borderWidth = 2
            view.layer.borderColor = UIColor(red: 205/255, green: 57/255, blue: 255/255, alpha: 1).cgColor
        } else {
            view.layer.borderWidth = 0
        }
    }

    @objc func didClickFavoriteBtn() {
        isFavorite = !isFavorite
        isFavorite ? favoriteButton.setImage(UIImage(named: "Favorites choose"), for: .normal) : favoriteButton.setImage(UIImage(named: "Favorites"), for: .normal)
        favoritesData = isBug ? UserDefaults.standard.array(forKey: "isFavoriteBugs") as? [Int] ?? []: UserDefaults.standard.array(forKey: "isFavoriteFish") as? [Int] ?? []
        if favoritesData.contains(id) {
            for i in 0..<favoritesData.count {
                if favoritesData[i] == id {
                    favoritesData.remove(at: i)
                    break
                }
            }
        } else {
            favoritesData.append(id)
        }
        if isBug {
            UserDefaults.standard.set(favoritesData, forKey: "isFavoriteBugs")
        } else {
            UserDefaults.standard.set(favoritesData, forKey: "isFavoriteFish")
        }
    }

    public func configCell(name: String, id: String, price: Int, isBug: Bool) {
        self.id = Int(id) ?? 0
        self.isBug = isBug
        
        favoritesData = isBug ? UserDefaults.standard.array(forKey: "isFavoriteBugs") as? [Int] ?? []: UserDefaults.standard.array(forKey: "isFavoriteFish") as? [Int] ?? []
        isFavorite = favoritesData.contains(Int(id) ?? 0) ? true : false
        isFavorite ? favoriteButton.setImage(UIImage(named: "Favorites choose"), for: .normal) : favoriteButton.setImage(UIImage(named: "Favorites"), for: .normal)
        
        museumData = isBug ? UserDefaults.standard.array(forKey: "isMuseumBugs") as? [Int] ?? []: UserDefaults.standard.array(forKey: "isMuseumFish") as? [Int] ?? []
        isMuseum = museumData.contains(Int(id) ?? 0) ? true : false
        isMuseum ? museumButton.setImage(UIImage(named: "owl_icon_fill"), for: .normal) : museumButton.setImage(UIImage(named: "owl_icon"), for: .normal)
        
        if isMuseum {
            view.layer.borderWidth = 2
            view.layer.borderColor = UIColor(red: 205/255, green: 57/255, blue: 255/255, alpha: 1).cgColor
        } else {
            view.layer.borderWidth = 0
        }

        moneyLabel.text = "$\(price)"
        nameLabel.text = name
        mImageView.alpha = self.id == 0 ? 0.5 : 1

        if id == "" {
            mImageView.image = UIImage(named: "imageBG")
        } else {
            let url = isBug ? "http://acnhapi.com/v1/icons/bugs/" + id : "http://acnhapi.com/v1/icons/fish/" + id
            if let url = URL(string: url) {
                DispatchQueue.main.async {
                    UIImageView().kf.setImage(with: url, placeholder: UIImage(named: "imageBG"), options: nil, progressBlock: nil) { (result) in
                        switch result {
                        case .success(let success):
                            self.mImageView.image = success.image
                        case .failure(_):
                            break
                        }
                    }
                }
            }
        }
    }
}
