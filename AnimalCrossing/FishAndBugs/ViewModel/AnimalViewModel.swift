//
//  FishViewModel.swift
//  AnimalCrossing
//
//  Created by Hira on 2020/5/13.
//  Copyright © 2020 1. All rights reserved.
//

import RxCocoa
import RxSwift
import Foundation
import Kingfisher

class AnimalViewModel {

    private let animalApi = AnimalAPI()
    internal var bugsImageArray: [Image] = [Image].init(repeating: UIImage(named: "imageBG")!, count: 80)
    internal var fishImageArray: [Image] = [Image].init(repeating: UIImage(named: "imageBG")!, count: 80)
    internal var canCatchFishImageArray: [Image] = []
    internal var canCatchBugsImageArray: [Image] = []
    internal var fishAllData: [AllData] = []
    internal var bugsAllData: [AllData] = []
    internal var canCatchFish: [AllData] = []
    internal var canCatchBugs: [AllData] = []
    internal var canCatchFishId: [Int] = []
    internal var canCatchBugsId: [Int] = []
    internal var temporarily: [Int] = []

    @available(iOS 11.0, *)
    internal func requestData(id: Int, type: String) -> Observable<Bool> {
        return animalApi.fetchDataFish(id: id, type: type).flatMap { [weak self] (model) -> Observable<Bool> in
            guard let `self` = self else { return Observable.just(false) }
            guard model.id != 0 else { return Observable.just(false) }
            let models = AllData(model: model)
            let modeldata = try! NSKeyedArchiver.archivedData(withRootObject: models, requiringSecureCoding: false)
            UserDefaults.standard.set(modeldata, forKey: "\(type)\(id)")
            return Observable.just(true)
        }
    }

    internal func fetchAllImage(id: Int, type: String, image: @escaping (Image) -> Void) {
        let url = "http://acnhapi.com/images/\(type)/\(id)"
        if let url = URL(string: url) {
            UIImageView().kf.setImage(with: url, placeholder: UIImage(named: "imageBG"), options: nil, progressBlock: nil) { (result) in
                switch result {
                case .success(let success):
                    image(success.image)
                case .failure(_):
                    image(UIImage(named: "imageBG")!)
                }
            }
        }
    }

    internal func callSaveData(type: String, count: Int, result: @escaping () -> Void) {
        let isSouth = UserDefaults.standard.bool(forKey: "isSouth")

        for i in 1...count {

            if let mData = UserDefaults.standard.data(forKey: "\(type)\(i)") {
                var myModelData: Data?
                var myModel: AllData?
                myModelData = mData
                myModel = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(myModelData!) as! AllData
                guard let data = myModel else { return }
                if type == "fish" {
                    fishAllData.append(data)
                    self.stringToAddCanCatch(isSouthern: isSouth, model: self.fishAllData[i - 1], type: "fish")
                    self.fetchAllImage(id: i, type: "fish") { (img) in
                        self.fishImageArray[i - 1] = img
                        if self.fishAllData.count == count && i == count {
                            result()
                        }
                    }
                } else {
                    bugsAllData.append(data)
                    self.stringToAddCanCatch(isSouthern: isSouth, model: self.bugsAllData[i - 1], type: "bugs")
                    self.fetchAllImage(id: i, type: "bugs") { (img) in
                        self.bugsImageArray[i - 1] = img
                        if self.bugsAllData.count == count && i == count {
                            result()
                        }
                    }
                }
            } else {
                print("尚未有紀錄")
            }
        }
    }

    internal func favorCallSaveData(id: Int, type: String, count: Int, result: @escaping () -> Void) {

        if let mData = UserDefaults.standard.data(forKey: "\(type)\(id)") {
            var myModelData: Data?
            var myModel: AllData?
            myModelData = mData
            myModel = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(myModelData!) as! AllData
            guard let data = myModel else { return }
            if type == "fish" {
                fishAllData.append(data)
                if self.fishAllData.count == count {
                    result()
                }
            } else {
                bugsAllData.append(data)
                if self.bugsAllData.count == count {
                    result()
                }
            }
        } else {
            print("尚未有紀錄")
        }
    }

    internal func nowCanCatch(type: String, result: @escaping () -> Void) {
        if type == "fish" {
            for (_, value) in canCatchFishId.enumerated() {
                canCatchFish.append(fishAllData[value - 1])
                canCatchFishImageArray.append(fishImageArray[value - 1])
                if canCatchFishId.count == canCatchFish.count {
                    result()
                }
            }
        } else {
            for (_, value) in canCatchBugsId.enumerated() {
                canCatchBugs.append(bugsAllData[value - 1])
                canCatchBugsImageArray.append(bugsImageArray[value - 1])
                if canCatchBugsId.count == canCatchBugs.count {
                    result()
                }
            }
        }
    }

    /// 拿取現在時間 (0是月份, 1是小時)
    internal func getNowTime() -> (String, String, String) {
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MM"
        let month = monthFormatter.string(from: Date())

        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH"
        let time = timeFormatter.string(from: Date())

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        let date = dateFormatter.string(from: Date())
        return (month, time, date)
    }

    internal func stringToAddCanCatch(isSouthern: Bool, model: AllData, type: String) {
        if model.isAllYear && model.isAllDay {
            type == "fish" ? canCatchFishId.append(model.id) : canCatchBugsId.append(model.id)
        } else if model.isAllYear {
            fetchInThisTimeId(model: model, type: type, isTemporarily: false)
        } else if model.isAllDay {
            fetchInThisMonthId(isSouthern: isSouthern, model: model, type: type, isTemporarily: false)
        } else {
            fetchInThisTimeId(model: model, type: type, isTemporarily: true)
            fetchInThisMonthId(isSouthern: isSouthern, model: model, type: type, isTemporarily: true)
            if temporarily.count >= 2 {
                type == "fish" ? canCatchFishId.append(model.id) : canCatchBugsId.append(model.id)
            }
            temporarily = []
        }
    }

    private func fetchInThisMonthId(isSouthern: Bool, model: AllData, type: String, isTemporarily: Bool) {
        var monthArray: [Int] = []
        var chars: String = ""
        let inWhere = isSouthern ? model.southern : model.northern
        if inWhere.contains("&") { //5-9 & 10-1 || 5-9 & 8
            for char in inWhere {
                if char == "-" {
                    monthArray.append(Int(chars) ?? 0)
                    chars = ""
                } else if char == "&" || char == " " {
                    if chars != "" {
                        monthArray.append(Int(chars) ?? 0)
                        chars = ""
                    }
                } else {
                    chars.insert(char, at: chars.endIndex)
                }
            }
            monthArray.append(Int(chars) ?? 0)
            if monthArray.count < 4 {
                if String(monthArray[2]) == getNowTime().0 {
                    type == "fish" ? canCatchFishId.append(model.id) : canCatchBugsId.append(model.id)
                } else {
                    monthAndTimeFor(array1: monthArray[0], array2: monthArray[1], a1: 12, a2: 1, type: type, isTemporarily: isTemporarily, modelId: model.id, getTime: getNowTime().0)
                }
            } else {
                monthAndTimeFor(array1: monthArray[0], array2: monthArray[1], a1: 12, a2: 1, type: type, isTemporarily: isTemporarily, modelId: model.id, getTime: getNowTime().0)
                monthAndTimeFor(array1: monthArray[2], array2: monthArray[3], a1: 12, a2: 1, type: type, isTemporarily: isTemporarily, modelId: model.id, getTime: getNowTime().0)
            }
        } else if !inWhere.contains("&") && !inWhere.contains("-") { //8
            if inWhere == getNowTime().0 {
                type == "fish" ? canCatchFishId.append(model.id) : canCatchBugsId.append(model.id)
            }
        } else {
            for char in inWhere { //5-9
                if char == "-" {
                    monthArray.append(Int(chars) ?? 0)
                    chars = ""
                } else {
                    chars.insert(char, at: chars.endIndex)
                }
            }
            monthArray.append(Int(chars) ?? 0)
            monthAndTimeFor(array1: monthArray[0], array2: monthArray[1], a1: 12, a2: 1, type: type, isTemporarily: isTemporarily, modelId: model.id, getTime: getNowTime().0)
        }
    }

    private func fetchInThisTimeId(model: AllData, type: String, isTemporarily: Bool) {
        var monthArray: [Int] = []
        var chars: String = ""
        let inTime = model.time
        if inTime.contains("&") { // 5pm - 6pm & 8am - 9am
            for char in inTime {
                if char != "&" && char != " " && char != "m" && char != "-" {
                    if char == "a" {
                        monthArray.append(Int(chars) ?? 0)
                        chars = ""
                    } else if char == "p" {
                        monthArray.append(Int(chars)! + 12)
                        chars = ""
                    } else {
                        chars.insert(char, at: chars.endIndex)
                    }
                }
            }
            monthAndTimeFor(array1: monthArray[0], array2: monthArray[1], a1: 23, a2: 0, type: type, isTemporarily: isTemporarily, modelId: model.id, getTime: getNowTime().1)
            monthAndTimeFor(array1: monthArray[2], array2: monthArray[3], a1: 23, a2: 0, type: type, isTemporarily: isTemporarily, modelId: model.id, getTime: getNowTime().1)
        } else if inTime.contains("to") { // 5pm to 6pm
            for char in inTime {
                if char != "t" && char != "o" && char != " " && char != "m" {
                    if char == "a" {
                        monthArray.append(Int(chars) ?? 0)
                        chars = ""
                    } else if char == "p" {
                        monthArray.append(Int(chars)! + 12)
                        chars = ""
                    } else {
                        chars.insert(char, at: chars.endIndex)
                    }
                }
            }
            monthAndTimeFor(array1: monthArray[0], array2: monthArray[1], a1: 23, a2: 0, type: type, isTemporarily: isTemporarily, modelId: model.id, getTime: getNowTime().1)
        } else { // 5pm - 6pm
            for char in inTime {
                if char != "-" && char != " " && char != "m" {
                    if char == "a" {
                        monthArray.append(Int(chars) ?? 0)
                        chars = ""
                    } else if char == "p" {
                        monthArray.append(Int(chars)! + 12)
                        chars = ""
                    } else {
                        chars.insert(char, at: chars.endIndex)
                    }
                }
            }
            monthAndTimeFor(array1: monthArray[0], array2: monthArray[1], a1: 23, a2: 0, type: type, isTemporarily: isTemporarily, modelId: model.id, getTime: getNowTime().1)
        }
    }

    private func monthAndTimeFor(array1: Int, array2: Int, a1: Int, a2: Int, type: String, isTemporarily: Bool, modelId: Int, getTime: String) {
        if array1 > array2 {
            for i in array1...a1 {
                arrayForSave(i: i, id: modelId, type: type, isTemporarily: isTemporarily, getTime: getTime)
            }
            for i in a2...array2 {
                arrayForSave(i: i, id: modelId, type: type, isTemporarily: isTemporarily, getTime: getTime)
            }
        } else {
            for i in array1...array2 {
                arrayForSave(i: i, id: modelId, type: type, isTemporarily: isTemporarily, getTime: getTime)
            }
        }
    }

    private func arrayForSave(i: Int, id: Int, type: String, isTemporarily: Bool, getTime: String) {
        let str = i > 9 ? String(i) : "0" + String(i)
        if str == getTime {
            if isTemporarily {
                temporarily.append(id)
            } else {
                type == "fish" ? canCatchFishId.append(id) : canCatchBugsId.append(id)
            }
        }
    }
}
