//
//  MuscleEvaluation.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/10/26.
//

import Foundation

class MuscleEvaluation {
    static var patterns: [Pattern] = [
        Pattern(pattern1),
        Pattern(pattern2),
        Pattern(pattern3),
        Pattern(pattern4),
        Pattern(pattern5),
        Pattern(pattern6),
        Pattern(pattern7),
    ]

    /*
     * variables
     */
    var dictionary: [Int: Pattern]

    init() {
        dictionary = Dictionary(uniqueKeysWithValues: MuscleEvaluation.patterns.map({ ($0.patterns.count, $0) }))
    }
}

extension MuscleEvaluation {
    static var shared = MuscleEvaluation()
}

class Pattern {
    var patterns: [(CGFloat, CGFloat, CGFloat, CGFloat)]

    init(_ patterns: [(CGFloat, CGFloat, CGFloat, CGFloat)] = []) {
        self.patterns = patterns
    }
}

let pattern1: [(CGFloat, CGFloat, CGFloat, CGFloat)] = [
    (0, 0, 1, 1),
]

let pattern2: [(CGFloat, CGFloat, CGFloat, CGFloat)] = [
    (0, 0, 0.5, 1),
    (0.5, 0, 0.5, 1),
]

let pattern3: [(CGFloat, CGFloat, CGFloat, CGFloat)] = [
    (0, 0, 0.5, 1),
    (0.5, 0, 0.5, 0.5),
    (0.5, 0.5, 0.5, 0.5),
]

let pattern4: [(CGFloat, CGFloat, CGFloat, CGFloat)] = [
    (0, 0, 0.5, 0.5),
    (0.5, 0, 0.5, 0.5),
    (0, 0.5, 0.5, 0.5),
    (0.5, 0.5, 0.5, 0.5),
]

let pattern5: [(CGFloat, CGFloat, CGFloat, CGFloat)] = [
    (0, 0, 0.5, 0.5),
    (0, 0.5, 0.5, 0.5),
    (0.5, 0, 0.5, 0.4),
    (0.5, 0.4, 0.5, 0.3),
    (0.5, 0.7, 0.5, 0.3),
]

let pattern6: [(CGFloat, CGFloat, CGFloat, CGFloat)] = [
    (0, 0, 0.5, 0.25),
    (0, 0.25, 0.5, 0.25),
    (0.5, 0, 0.5, 0.5),
    (0, 0.5, 1, 0.25),
    (0, 0.75, 0.5, 0.25),
    (0.5, 0.75, 0.5, 0.25),
]

let pattern7: [(CGFloat, CGFloat, CGFloat, CGFloat)] = [
    (0, 0, 0.5, 0.2),
    (0, 0.2, 0.5, 0.2),
    (0.5, 0, 0.5, 0.4),
    (0, 0.4, 1, 0.2),
    (0, 0.6, 0.5, 0.2),
    (0.5, 0.6, 0.5, 0.2),
    (0, 0.8, 1, 0.2),
]
