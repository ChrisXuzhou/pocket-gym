//
//  Musclevalue.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/10/22.
//

import Foundation
import SwiftUI

class Musclevalue: ObservableObject {
    var muscleid: String
    
    /*
     * 0.0 ~ 1.0
     */
    var average: Double
    var days: Int
    var volumn: Double
    var rangedays: Int

    init(muscleid: String, days: Int, rangedays: Int, volumn: Double = 0.0) {
        self.muscleid = muscleid
        self.days = days
        self.volumn = volumn
        self.rangedays = rangedays
        
        self.average = Double(days) / Double(rangedays)
    }
}

extension Musclevalue {
    
    var color: Color {
        if average < 0.1 {
            return PreferenceDefinition.shared.theme.opacity(0.1)
        } else if average < 0.3 {
            return PreferenceDefinition.shared.theme.opacity(0.5)
        }  else {
            return PreferenceDefinition.shared.theme
        }
    }
    
}
