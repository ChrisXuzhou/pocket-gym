//
//  ExercisedescriptionModel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/2/27.
//

import Foundation

enum Exerciseviewtype {
    case results, exercise

    var name: String {
        switch self {
        case .results:
            return "activity"
        case .exercise:
            return "exercise"
        }
    }
}

