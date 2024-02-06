//
//  Toolsmodel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/4/22.
//

import Foundation

enum Englishormetric: String, Codable {
    case english, metric
    
    var weightunit: Weightunit {
        switch self {
        case .english:
            return Weightunit.lb
        case .metric:
            return Weightunit.kg
        }
    }
    
    var lengthunit: Lengthunit {
        switch self {
        case .english:
            return .ins
        case .metric:
            return .cm
        }
    }
}

enum Activitylevel: String, Codable, CaseIterable {
    case activityl0, activityl1, activityl2, activityl3, activityl4, activityl5
    
    var ratio: Double {
        switch self {
        case .activityl0:
            return 1.2
        case .activityl1:
            return 1.4
        case .activityl2:
            return 1.6
        case .activityl3:
            return 1.75
        case .activityl4:
            return 2.0
        case .activityl5:
            return 2.3
        }
    }
}
