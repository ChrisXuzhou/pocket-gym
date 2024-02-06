//
//  Activitydatatype.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/5/9.
//

import Foundation
import SwiftUI

enum Musclecolor: Comparable, CaseIterable {
    case lighter, light, middle, dark, darker

    var color: Color {
        switch self {
        case .lighter:
            return NORMAL_LIGHT_BLUE_COLOR
        case .light:
            return NORMAL_LAVENDER_COLOR
        case .middle:
            return NORMAL_TANGERINE_COLOR
        case .dark:
            return NORMAL_TOMATO_COLOR
        case .darker:
            return NORMAL_HEAT_COLOR
        }
    }
}

extension Musclecolor {
    static func of(_ value: Int) -> Musclecolor {
        value < 2 ? Musclecolor.lighter :
            value < 3 ? Musclecolor.light :
            value < 5 ? Musclecolor.middle :
            value < 8 ? Musclecolor.dark :
            Musclecolor.darker
    }
}


/*
 
 enum Activitymuscledatatype: String, CaseIterable {
     case workoutdata, exercisedata

     func ofvalue(_ descriptor: Muscledescripor) -> Int {
         switch self {
         case .exercisedata:
             // 3  5  8  12
             return descriptor.exerciseidlist.count
         case .workoutdata:
             // 5  8  12  20
             return descriptor.analysisedlist.count
         }
     }

     func color(_ descriptor: Muscledescripor, days: Int) -> Musclecolor {
         switch self {
         case .exercisedata:
             // 3  5  8  12
             let data = Double(descriptor.exerciseidlist.count) / Double(days)

             return
                 data < 0.05 ? Musclecolor.lighter :
                 data < 0.1 ? Musclecolor.light :
                 data < 0.3 ? Musclecolor.middle :
                 data < 0.5 ? Musclecolor.dark :
                 Musclecolor.darker

         case .workoutdata:

             // 5  8  12  20
             let data = Double(descriptor.analysisedlist.count) / Double(days)

             return
                 data < 0.1 ? Musclecolor.lighter :
                 data < 0.3 ? Musclecolor.light :
                 data < 0.5 ? Musclecolor.middle :
                 data < 0.8 ? Musclecolor.dark :
                 Musclecolor.darker
         }
     }

     func color(_ data: Int) -> Musclecolor {
         switch self {
         case .exercisedata:
             // 3  5  8  12

             return
                 data < 3 ? Musclecolor.lighter :
                 data < 5 ? Musclecolor.light :
                 data < 8 ? Musclecolor.middle :
                 data < 12 ? Musclecolor.dark :
                 Musclecolor.darker

         case .workoutdata:

             // 5  8  12  20

             return
                 data < 5 ? Musclecolor.lighter :
                 data < 8 ? Musclecolor.light :
                 data < 12 ? Musclecolor.middle :
                 data < 20 ? Musclecolor.dark :
                 Musclecolor.darker
         }
     }
 }

 
 */


extension Int {
    
    func displaymusclecolor(_ factor: Double) -> Musclecolor {
        let data = Double(self) / factor

        if self > 0 {
            log("[displayed color] \(self) \(factor) \(data)")
        }
        
        return
            data < 0.1 ? Musclecolor.lighter :
            data < 0.3 ? Musclecolor.light :
            data < 0.5 ? Musclecolor.middle :
            data < 0.8 ? Musclecolor.dark :
            Musclecolor.darker
    }
}
