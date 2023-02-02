//
//  AnimalService.swift
//  AnimalCrossing
//
//  Created by Hira on 2020/5/13.
//  Copyright © 2020 1. All rights reserved.
//
import UIKit
import Moya

enum AnimalService {
    case getFish(id: Int, type: String)
}

extension AnimalService: TargetType {

    var baseURL: URL {
        return URL(string: "http://acnhapi.com/v1/")!
    }

    var path: String {
        switch self {
        case .getFish(let id, let type):
            return "\(type)/\(id)"
        }
    }

    var method: Moya.Method {
        return .get
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        return .requestPlain
    }

    var headers: [String: String]? {
        return nil
    }
}
