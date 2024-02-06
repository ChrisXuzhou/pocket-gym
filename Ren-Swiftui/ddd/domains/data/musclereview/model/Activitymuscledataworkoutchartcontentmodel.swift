//
//  Reviewmusclechartcontentmodel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/5/10.
//
import Foundation
import SwiftUI

enum Reviewmuscledatatype: String, CaseIterable {
    case set, volume, counts

    var index: Int {
        switch self {
        case .set:
            return 0
        case .volume:
            return 1
        case .counts:
            return 2
        }
    }

    var ratio: CGFloat {
        switch self {
        case .set:
            return 0.8
        case .volume:
            return 1
        case .counts:
            return 0.7
        }
    }
}

class Activitymuscledatachartmodel: ObservableObject {
    @Published var selectedtype: Reviewmuscledatatype = .volume
    var lastdays: Int
    var analysisedexercises: [Analysisedexercisewrapper]

    init(lastdays: Int, analysisedexercises: [Analysisedexercisewrapper]) {
        self.lastdays = lastdays
        self.analysisedexercises = analysisedexercises
    }
}

private func merge(type: Reviewmuscledatatype, analysisedlist: [Analysisedexercisewrapper]) -> (Double, String) {
    var total: Double = 0.0
    var totalstr: String = ""

    if type == .set {
        for each in analysisedlist {
            total += Double(each.analysis.sets)
        }
        totalstr = String(format: "%.0f", total)
    } else if type == .volume {
        for each in analysisedlist {
            total += Double(each.analysis.volume)
        }
        totalstr = String(format: "%.1f", total)
    } else if type == .counts {
        total = Double(analysisedlist.count)
        totalstr = String(format: "%.0f", total)
    }

    return (total, totalstr)
}

class Reviewmusclechartcontentmodel: ObservableObject {
    /*
     * chart data after processed.
     */
    var type: Reviewmuscledatatype
    var analysisedlist: [Analysisedexercisewrapper]

    var days: [Daywrapper] = []
    var datestr2analysisedlist: [String: [Analysisedexercisewrapper]] = [:]

    var ylist: [Double] = []
    var ydescriptionlist: [String] = []

    var _ymax: Double = 0.0
    var _ymin: Double = 9999999.9

    func insertempty(_ daywrapper: Daywrapper) {
        days.append(daywrapper)
        ylist.append(0.0)
        ydescriptionlist.append("")
    }

    init(
        type: Reviewmuscledatatype,
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

        if !ylist.isEmpty && _ymin < 9999999.0 && _ymax > 0 {
            ylist = ylist.map({
                if $0 == 0 {
                    return 0.0
                } else {
                    return ($0 / _ymax) * 0.6 + 0.3
                }
            })
        }
    }
}
