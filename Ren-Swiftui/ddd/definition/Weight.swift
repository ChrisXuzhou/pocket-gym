//
//  Weight.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/2/16.
//

import Foundation

enum Weightunit: String, Codable, CaseIterable {
    case kg, lb

    var name: String {
        switch self {
        case .kg:
            return "kg"
        case .lb:
            return "lb"
        }
    }
}

struct Weight {
    var value: Double
    var weightunit: Weightunit

    func switchuinit() -> Weight {
        switch weightunit {
        case .kg:
            // kg to lbs
            let newvalue: Double = Measurement(value: value, unit: UnitMass.kilograms).converted(to: UnitMass.pounds).value
            return Weight(value: newvalue, weightunit: .lb)
        case .lb:
            // lbs to kg
            let newvalue: Double = Measurement(value: value, unit: UnitMass.pounds).converted(to: UnitMass.kilograms).value
            return Weight(value: newvalue, weightunit: .kg)
        }
    }

    var askgweight: Double {
        switch weightunit {
        case .kg:
            return value
        case .lb:
            return switchuinit().value
        }
    }

    func transformedto(weightunit: Weightunit) -> Double {
        if weightunit == self.weightunit {
            return value
        } else {
            return switchuinit().value
        }
    }
}

func ofkg(_ value: Double) -> Weight {
    Weight(value: value, weightunit: .kg)
}

func oflb(_ value: Double) -> Weight {
    Weight(value: value, weightunit: .lb)
}
