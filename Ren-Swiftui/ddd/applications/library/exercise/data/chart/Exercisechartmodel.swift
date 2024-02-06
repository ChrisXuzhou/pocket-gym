//
//  Exercisechartmodel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/5/7.
//

import Foundation
import SwiftUI

class Exercisechartmodel: ObservableObject {
    var expectwidth: CGFloat {
        BASIC_WIDTH * CGFloat(xlist.count)
    }

    var type: Exercisedatatype
    var _ylast: Double?

    var xlist: [String] = []
    var ylist: [Double] = []
    var ydescriptionlist: [String] = []

    var _ymax: Double = 0.0
    var _ymin: Double = 9999.9

    init(type: Exercisedatatype,
         analysisedlist: [Analysisedexercise]) {
        self.type = type

        if analysisedlist.isEmpty {
            return
        }

        for i in 0 ..< analysisedlist.count {
            let _a = analysisedlist[i]

            let _x = _a.workday.systemedyearmonthdate
            xlist.append(_x)

            var _y: Double = 0.0

            if type == .sets {
                _y = Double(_a.sets)
                ylist.append(_y)
                ydescriptionlist.append("\(Int(_y))")
            } else if type == .volume {
                _y = _a.volume
                ylist.append(_y)
                ydescriptionlist.append(String(format: "%.1f", _y))
            } else if type == .max {
                _y = _a.maxweight
                ylist.append(_y)
                ydescriptionlist.append(String(format: "%.1f", _y))
            } else if type == .onerm {
                _y = _a.onerm
                ylist.append(_y)
                ydescriptionlist.append(String(format: "%.1f", _y))
            }

            if _y > _ymax {
                _ymax = _y
            }

            if _y < _ymin {
                _ymin = _y
            }
        }

        if !ylist.isEmpty && _ymin < 9999.0 && _ymax > 0 {
            _ylast = ylist.last

            ylist = ylist.map({ ($0 / _ymax) * 0.6 + 0.3 })
        }
    }

    func _yminstring(_ weightunit: Weightunit) -> String {
        if type == .sets {
            return String(format: "%.0f", _ymin)
        } else {
            return String(format: "%.1f", Weight(value: _ymin, weightunit: .kg).transformedto(weightunit: weightunit))
        }
    }

    func _ymaxstring(_ weightunit: Weightunit) -> String {
        if type == .sets {
            return String(format: "%.0f", _ymax)
        } else {
            return String(format: "%.1f", Weight(value: _ymax, weightunit: .kg).transformedto(weightunit: weightunit))
        }
    }
}
