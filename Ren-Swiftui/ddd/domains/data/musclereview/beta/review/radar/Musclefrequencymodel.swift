//
//  Musclefrequencymodel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/10/23.
//

import Foundation

class Analysisedmusclewrapper {
    var analysised: Analysisedmuscle

    init(_ analysised: Analysisedmuscle) {
        self.analysised = analysised
    }
}

class Musclefrequencymodel: ObservableObject {
    /*
     * musclegroupid : muscleassesses
     */
    var dictionary: [String: Muscleradarmodel] = [:]
    /*
     * variables
     */
    var analysisedlist: [Analysisedmuscle] = []
    /*
     * musclegroupid : muscleassesses
     */
    var groupid2analysiseds: [String: [Analysisedmuscle]] = [:]

    init(_ days: Int = 30) {
        refreshandfetch(30)
    }

    func refreshandfetch(_ days: Int = 30) {
        let end = Date()
        let start = Calendar.current.date(byAdding: .day, value: -days, to: end) ?? end
        let interval = DateInterval(start: start, end: end)

        analysisedlist = AppDatabase.shared.queryAnalysisedmuscles(interval)
        groupid2analysiseds = Dictionary(grouping: analysisedlist, by: { $0.displaygroupid })

        for groupid in Librarynewdisplayedmuscle.shared.musclegroupids {
            let analysiseds = groupid2analysiseds[groupid] ?? []
            dictionary[groupid] = Muscleradarmodel(groupid: groupid, analysiseds: analysiseds, rangedays: days)
        }

        objectWillChange.send()
    }
}
