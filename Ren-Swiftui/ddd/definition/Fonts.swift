//
//  Fonts.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/2/22.
//

import Foundation
import SwiftUI

let DEFINE_FONT_SMALLEST_SIZE: CGFloat = 11
let DEFINE_FONT_SMALLER_SIZE: CGFloat = 13
let DEFINE_FONT_SMALL_SIZE: CGFloat = 15
let DEFINE_FONT_SIZE: CGFloat = 17
let DEFINE_FONT_BIG_SIZE: CGFloat = 19
let DEFINE_FONT_BIGGEST_SIZE: CGFloat = 23

let DEFINE_SHEET_FONT_SIZE: CGFloat = DEFINE_FONT_SIZE - 1

// 兼容一些‘历史定义’
public var LITTLE_TEXT_SIZE: CGFloat = DEFINE_FONT_SMALL_SIZE
public var NORMAL_TEXT_SIZE: CGFloat = DEFINE_FONT_SIZE
public var LARGE_TEXT_SIZE: CGFloat = DEFINE_FONT_BIG_SIZE
public var TITLE_TEXT_SIZE: CGFloat = DEFINE_FONT_BIG_SIZE

extension String {
    var _id: String {
        lowercased().replacingOccurrences(of: " ", with: "")
    }
}

func ofindex(_ id: Int64, max: Int64 = 10) -> Int {
    let idx: Int = Int(abs(id) % max)
    return idx
}

let DEFAULT_COLORS: [Color] = [
    NORMAL_TOMATO_COLOR, NORMAL_TANGERINE_COLOR, NORMAL_BANANA_COLOR,
    NORMAL_BASIL_COLOR, NORMAL_SAGE_COLOR, NORMAL_BLUEBERRY_COLOR, NORMAL_LAVENDER_COLOR,
    NORMAL_GRAPE_COLOR, NORMAL_FLAMINGO_COLOR
]

/*
 
 let NORMAL_TOMATO_COLOR: Color = Color("Tomato")
 let NORMAL_TANGERINE_COLOR: Color = Color("Tangerine")
 let NORMAL_BANANA_COLOR: Color = Color("Banana")
 let NORMAL_BASIL_COLOR: Color = Color("Basil")
 let NORMAL_SAGE_COLOR: Color = Color("Sage")
 let NORMAL_PEACOCK_COLOR: Color = Color("Peacock")
 let NORMAL_BLUEBERRY_COLOR: Color = Color("Blueberry")
 let NORMAL_LAVENDER_COLOR: Color = Color("Lavender")
 let NORMAL_GRAPE_COLOR: Color = Color("Grape")
 let NORMAL_FLAMINGO_COLOR: Color = Color("Flamingo")
 
 
 */



func ofcolor(_ id: Int64) -> Color {
    let idx: Int = Int(abs(id) % 9)
    let opacity: Double = 1 // Double(abs(id) % 10) / 10

    return DEFAULT_COLORS[idx].opacity(opacity)
}

extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        min(max(self, limits.lowerBound), limits.upperBound)
    }
}

extension Int {
    var nonNegative: Int {
        clamped(to: 0...Int.max)
    }
}

extension Collection {
    var tailLength: Int {
        (count - 1).nonNegative
    }

    var head: SubSequence { prefix(1) }
    var tail: SubSequence { suffix(tailLength) }
}

extension String {
    var uppercaseFirst: String {
        (head.localizedUppercase + tail.lowercased())
    }
    
    var words: [String] {
        components(separatedBy: " ")
    }
    
    var uppercaseFirstWords: String {
        words
            .map(\.uppercaseFirst)
        .joined(separator: " ")
    }
    
}
