//
//  RmCalculator.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/4/6.
//

import Foundation

class RmCalculator {
    
    var reps: Int
    var weightkg: Double
    
    init(reps: Int, weightkg: Double) {
        self.reps = reps
        self.weightkg = weightkg
    }
    
    private static let num2onermratio: [Double] = [100, 95, 93, 90, 87, 85, 83, 80, 77, 75, 70, 67, 65]
    
    private func ratio(_ repeats: Int) -> Double {
        repeats <= 0 ? 0.0 :
        (repeats < 13 ? RmCalculator.num2onermratio[repeats - 1] : RmCalculator.num2onermratio[12])
    }
    
    var onermkg: Double {
        let ratio = ratio(reps)
        return round(weightkg * 10000 / ratio) / 100
    }
    
}

