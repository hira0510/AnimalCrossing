//
//  ResultViewModel.swift
//  AnimalCrossing
//
//  Created by Hira on 2020/5/14.
//  Copyright © 2020 1. All rights reserved.
//

import UIKit

class ResultViewModel {
    internal var monthLabelArray: [UILabel] = []

    internal var isMonthSouthern: Bool = {
        return UserDefaults.standard.bool(forKey: "isSouth")
    }()

    internal func setMonthLabel(allYear: Bool, southern: String, northern: String) {
        if allYear {
            monthLabelArray.forEach { (label) in
                label.backgroundColor = UIColor(red: 109 / 255, green: 177 / 255, blue: 1, alpha: 1)
            }
        } else {
            var array: [Int] = []
            var chars: String = ""
            let inWhere = isMonthSouthern ? southern : northern
            if inWhere.contains("&") {
                for char in inWhere {
                    if char == "-" {
                        array.append(Int(chars) ?? 0)
                        chars = ""
                    } else if char == "&" || char == " " {
                        if chars != "" {
                            array.append(Int(chars) ?? 0)
                            chars = ""
                        }
                    } else {
                        chars.insert(char, at: chars.endIndex)
                    }
                }
                array.append(Int(chars) ?? 0)
                arrayFor(array1: array[0], array2: array[1])
                if array.count < 4 {
                    monthLabelArray[array[2] - 1].backgroundColor = UIColor(red: 109 / 255, green: 177 / 255, blue: 1, alpha: 1)
                } else {
                    arrayFor(array1: array[2], array2: array[3])
                }
            } else if inWhere.count == 1 {
                monthLabelArray[((Int(inWhere) ?? 10) - 1)].backgroundColor = UIColor(red: 109 / 255, green: 177 / 255, blue: 1, alpha: 1)
            } else {
                for char in inWhere {
                    if char == "-" {
                        array.append(Int(chars) ?? 0)
                        chars = ""
                    } else {
                        chars.insert(char, at: chars.endIndex)
                    }
                }
                array.append(Int(chars) ?? 0)
                arrayFor(array1: array[0], array2: array[1])
            }
        }
    }

    internal func arrayFor(array1: Int, array2: Int) {
        if array1 > array2 {
            for i in array1...12 {
                monthLabelArray[i - 1].backgroundColor = UIColor(red: 109 / 255, green: 177 / 255, blue: 1, alpha: 1)
            }
            for i in 1...array2 {
                monthLabelArray[i - 1].backgroundColor = UIColor(red: 109 / 255, green: 177 / 255, blue: 1, alpha: 1)
            }
        } else {
            for i in array1...array2 {
                monthLabelArray[i - 1].backgroundColor = UIColor(red: 109 / 255, green: 177 / 255, blue: 1, alpha: 1)
            }
        }
    }

    internal func shadowChinese(shadow: String) -> String {
        switch shadow {
        case "Smallest (1)":
            return "極小"
        case "Small (2)":
            return "小"
        case "Medium (3)":
            return "中等"
        case "Large (4)", "Medium (4)":
            return "大"
        case "Large (5)":
            return "特大"
        case "Largest (6)":
            return "極大"
        case "Narrow":
            return "長型"
        case "Largest with fin (6)":
            return "極大，帶鰭"
        case "Medium with fin (4)":
            return "中等，帶鰭"
        default:
            return "不確定"
        }
    }

    internal func addressChinese(address: String, isfromBugs: Bool) -> String {
        if isfromBugs {
            switch address {
            case "On rocks (when raining)":
                return "下雨天石頭上"
            case "Flying":
                return "飛行"
            case "Flying near hybrid flowers":
                return "飛行在混種花旁"
            case "Flying by light":
                return "燈光下飛行"
            case "On trees":
                return "樹上"
            case "On the ground":
                return "地上"
            case "On flowers":
                return "花上"
            case "On white flowers":
                return "白花上"
            case "Shaking trees":
                return "搖動樹木"
            case "Underground":
                return "地底下"
            case "On ponds and rivers":
                return "河川&池塘"
            case "On tree stumps":
                return "樹樁"
            case "On palm trees":
                return "棕櫚樹"
            case "Under trees":
                return "樹底下"
            case "On rotten food":
                return "腐爛食物附近"
            case "On the beach":
                return "海邊"
            case "On beach rocks":
                return "海邊岩岸邊"
            case "Near trash":
                return "垃圾旁"
            case "On villagers":
                return "鄰居身上"
            case "Hitting rocks":
                return "敲打石頭"
            default:
                return "不確定"
            }
        } else {
            switch address {
            case "River":
                return "河川"
            case "Pond":
                return "池塘"
            case "River (Clifftop)":
                return "懸崖上"
            case "River (Clifftop) & Pond":
                return "懸崖上&池塘"
            case "River (Mouth)":
                return "出海口"
            case "Sea":
                return "大海"
            case "Pier":
                return "碼頭"
            case "Sea (when raining or snowing)":
                return "下雨天大海"
            default:
                return "不確定"
            }
        }
    }
}
