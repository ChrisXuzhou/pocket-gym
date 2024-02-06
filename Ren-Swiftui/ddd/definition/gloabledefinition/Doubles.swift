//
//  Doubles.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/20.
//

import Foundation

extension Double {
    var displayin1digit: String {
        String(format: "%.1f", self)
    }

    var displayinpercent: String {
        "\(self * 100)%"
    }
}
