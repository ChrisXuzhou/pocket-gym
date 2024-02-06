//
//  Analysisedmucleviewlabelmodel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/6/12.
//

import Foundation

class Analysisedmucleviewlabelmodel: ObservableObject {
    var analysised: Analysisedmuscle
    var lastanalysised: Analysisedmuscle?

    init(_ analysised: Analysisedmuscle) {
        let muscleid = analysised.muscleid
        let lastlist = AppDatabase.shared.querylast20analysisedmuscles(muscle: muscleid, limit: 2)

        self.analysised = analysised

        if !lastlist.isEmpty {
            if let _first = lastlist.first {
                self.analysised = _first
            }

            if let _last = lastlist.last {
                lastanalysised = _last
            }
        }

        refresh()
    }

    var title: String = ""
    var description: String = ""

    var left: Double = 0.0
    var leftdate: Date = Date()

    var right: Double = 0.0
    var rightdate: Date = Date()

    var ofunit: Weightunit? {
        PreferenceDefinition.shared.ofweightunit
    }

    var isinit: Bool {
        false
    }

    func refresh() {
        title = analysised.displayMuscleName
        rightdate = analysised.createtime
        description = Reviewmuscledatatype.volume.rawValue

        right = Weight(value: analysised.volume, weightunit: .kg).transformedto(weightunit: PreferenceDefinition.shared.ofweightunit)

        if let _last = lastanalysised {
            leftdate = _last.createtime

            left =
                Weight(value: _last.volume, weightunit: .kg).transformedto(weightunit: PreferenceDefinition.shared.ofweightunit)
        }
    }
}
