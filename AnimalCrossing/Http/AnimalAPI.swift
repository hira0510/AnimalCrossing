//
//  AnimalAPI.swift
//  AnimalCrossing
//
//  Created by Hira on 2020/5/13.
//  Copyright © 2020 1. All rights reserved.
//

import UIKit
import Moya
import ObjectMapper
import RxSwift
import Kingfisher

class AnimalAPI {
    let mainQueue = MainScheduler.instance
    let backQueue = SerialDispatchQueueScheduler.init(qos: .background)
    let provider = MoyaProvider<AnimalService>()

    func fetchDataFish(id: Int, type: String) -> Observable<BugsModel> {
        return provider.rx.request(.getFish(id: id, type: type)).asObservable().mapObject(BugsModel.self).subscribeOn(backQueue).observeOn(mainQueue)
    }
}
