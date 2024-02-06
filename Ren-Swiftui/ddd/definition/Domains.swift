//
//  Homepage.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/2/18.
//

import Foundation

enum Homedomain: String, Codable {
    case settings, calendar, workouts, library

    var cannew: Bool {
        switch self {
        case .settings:
            return false
        case .calendar:
            return true
        case .workouts:
            return true
        case .library:
            return false
        }
    }
}
