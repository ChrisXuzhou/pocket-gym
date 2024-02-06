//
//  Activitychartcontentmodel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/5/9.
//

import Foundation
import SwiftUI

let BASIC_WIDTH: CGFloat = 10

class Daywrapper {
    var day: Date?
    var emtydays: Int

    init(day: Date? = nil, emtydays: Int = 1) {
        self.day = day
        self.emtydays = emtydays
    }
}

class Activitychartcontentmodel: ObservableObject {
    /*
     * chart data after processed.
     */
    var type: Exercisedatatype
    var analysisedlist: [Analysisedexercisewrapper]

    var days: [Daywrapper] = []
    var datestr2analysisedlist: [String: [Analysisedexercisewrapper]] = [:]

    var _ylast: Double?

    var ylist: [Double] = []
    var ydescriptionlist: [String] = []

    var _ymax: Double = 0.0
    var _ymin: Double = 99999999.9

    func insertempty(_ daywrapper: Daywrapper) {
        days.append(daywrapper)
        ylist.append(0.0)
        ydescriptionlist.append("")
    }

    init(type: Exercisedatatype,
         lastdays: Int,
         analysisedlist: [Analysisedexercisewrapper]) {
        self.type = type
        self.analysisedlist = analysisedlist

        if analysisedlist.isEmpty {
            return
        }

        let days: [Date] = daysarray(Date(), lastdays)
        datestr2analysisedlist = Dictionary(grouping: analysisedlist, by: { $0.analysis.workday.systemedyearmonthdate })

        var emptydaywrapper: Daywrapper?
        for idx in 0 ..< days.count {
            let day = days[idx]

            let yearmonthdate = day.systemedyearmonthdate
            let analysisedlist = datestr2analysisedlist[yearmonthdate] ?? []

            // day content is empty.
            if analysisedlist.isEmpty {
                if day.isInToday {
                    if let _empty = emptydaywrapper {
                        insertempty(_empty)
                        emptydaywrapper = nil
                    }

                    insertempty(Daywrapper(day: day))
                    continue
                }

                if let _empty = emptydaywrapper {
                    _empty.emtydays += 1
                    emptydaywrapper = _empty
                } else {
                    emptydaywrapper = Daywrapper()
                }

                continue
            }

            if let _empty = emptydaywrapper {
                insertempty(_empty)
                emptydaywrapper = nil
            }

            // day content is not empty.
            let y: (Double, String) = merge(type: type, analysisedlist: analysisedlist)

            self.days.append(Daywrapper(day: day))
            ylist.append(y.0)
            ydescriptionlist.append(y.1)

            let _y = y.0

            if _y > _ymax {
                _ymax = _y
            }

            if _y < _ymin {
                _ymin = _y
            }
            
            
        }

        if let _empty = emptydaywrapper {
            insertempty(_empty)
            emptydaywrapper = nil
        }

        if !ylist.isEmpty && _ymin < 99999999.0 && _ymax > 0 {
            _ylast = ylist.last

            ylist = ylist.map({
                if $0 == 0 {
                    return 0.0
                } else {
                    return ($0 / _ymax) * 0.6 + 0.3
                }
            })
        }
    }

    private func merge(type: Exercisedatatype, analysisedlist: [Analysisedexercisewrapper]) -> (Double, String) {
        var total: Double = 0.0
        var totalstr: String = "0.0"

        if type == .sets {
            for each in analysisedlist {
                total += Double(each.analysis.sets)
            }
            totalstr = String(format: "%.0f", total)
        } else if type == .volume {
            for each in analysisedlist {
                total += Double(each.analysis.volume)
            }
            totalstr = String(format: "%.1f", total)
        } else if type == .max {
            for each in analysisedlist {
                let _newweight = Double(each.analysis.maxweight)
                if _newweight > total {
                    total = _newweight
                    totalstr = String(format: "%.1f", total)
                }
            }
        } else if type == .onerm {
            for each in analysisedlist {
                let _onerm = Double(each.analysis.onerm)
                if _onerm > total {
                    total = _onerm
                    totalstr = String(format: "%.1f", total)
                }
            }
        }

        return (total, totalstr)
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

/*

 for i in 0 ..< analysisedlist.count {
     let _a = analysisedlist[i]

     let _x = _a.workday
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

 */
