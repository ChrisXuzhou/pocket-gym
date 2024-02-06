//
//  Length.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/4/22.
//

import Foundation

enum Lengthunit: String, Codable {
    case cm, ins

    var name: String {
        switch self {
        case .cm:
            return "cm"
        case .ins:
            return "in"
        }
    }
}

struct Length {
    var value: Double
    var lengthunit: Lengthunit

    func switchuinit() -> Length {
        switch lengthunit {
        case .cm:
            // cm to ins
            let newvalue: Double = Measurement(value: value, unit: UnitLength.centimeters).converted(to: UnitLength.inches).value
            return Length(value: newvalue, lengthunit: .ins)
        case .ins:
            // ins to cm
            let newvalue: Double = Measurement(value: value, unit: UnitLength.inches).converted(to: UnitLength.centimeters).value
            return Length(value: newvalue, lengthunit: .cm)
        }
    }

    var ascmlenth: Double {
        switch lengthunit {
        case .cm:
            return value
        case .ins:
            return switchuinit().value
        }
    }

    func transformedto(lengthunit: Lengthunit) -> Double {
        if lengthunit == self.lengthunit {
            return value
        } else {
            return switchuinit().value
        }
    }
}

func ofcm(_ value: Double) -> Length {
    Length(value: value, lengthunit: .cm)
}

func ofins(_ value: Double) -> Length {
    Length(value: value, lengthunit: .ins)
}
