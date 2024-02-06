//
//  Muscleradarmodel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/10/23.
//
import SwiftUI

class Muscleradarmodel: ObservableObject {
    var groupid: String

    var score: Double = 0.0
    var values: [Musclevalue] = []

    init(groupid: String, score: Double, assesslist: [Musclevalue]) {
        self.groupid = groupid
        self.score = score
        values = assesslist
    }

    /*
     * variables
     */
    var muscleid2analysiseds: [String: [Analysisedmuscle]] = [:]

    init(groupid: String, analysiseds: [Analysisedmuscle], rangedays: Int) {
        self.groupid = groupid

        var rawlist: [Musclevalue] = []
        muscleid2analysiseds = Dictionary(grouping: analysiseds, by: { $0.muscleid })

        if let allmuscleids = Musclelibrary.shared.groupdictionary[groupid] {
            for muscleid in allmuscleids.map({ $0.ident }) {
                if let eachanalysiseds = muscleid2analysiseds[muscleid] {
                    rawlist.append(
                        Musclevalue(muscleid: muscleid, days: eachanalysiseds.count, rangedays: rangedays, volumn: 0.0)
                    )
                } else {
                    rawlist.append(
                        Musclevalue(muscleid: muscleid, days: 0, rangedays: rangedays, volumn: 0.0)
                    )
                }
            }
        }

        /*
         values = rawlist.sorted(by: { l, r in
             l.times < r.times
         })
         */
    }

    init(groupid: String, days: Int = 16) {
        self.groupid = groupid

        fetchindays(days)
    }

    private func fetchindays(_ days: Int) {
        let end = Date()
        let start = Calendar.current.date(byAdding: .day, value: -days, to: end) ?? end
        let interval = DateInterval(start: start, end: end)

        let analysiseds = AppDatabase.shared.queryAnalysisedmuscles(interval, groupid: groupid)

        var rawlist: [Musclevalue] = []
        muscleid2analysiseds = Dictionary(grouping: analysiseds, by: { $0.muscleid })

        if let allmuscleids = Musclelibrary.shared.groupdictionary[groupid] {
            for muscleid in allmuscleids.map({ $0.ident }) {
                if let eachanalysiseds = muscleid2analysiseds[muscleid] {
                    rawlist.append(
                        Musclevalue(muscleid: muscleid, days: eachanalysiseds.count, rangedays: days, volumn: 0.0)
                        // Musclevalue(muscleid: muscleid, times: eachanalysiseds.count, percent: Double(eachanalysiseds.count) / total * 100.0)
                    )
                } else {
                    rawlist.append(
                        Musclevalue(muscleid: muscleid, days: 0, rangedays: days, volumn: 0.0)
                        // Musclevalue(muscleid: muscleid, times: 0, percent: 0.0)
                    )
                }
            }
        }

        values = rawlist.sorted(by: { l, r in
            l.days < r.days
        })

        /*

         self.muscleid2analysiseds = muscleid2analysiseds
         self.values = values

         */

        objectWillChange.send()
    }
}

/*
 Musclevalue(muscleid: muscleid, times: eachanalysiseds.count, percent: Double(eachanalysiseds.count / total) * 100)
 */
