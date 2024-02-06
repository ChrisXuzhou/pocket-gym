//
//  Muscleradardetailmodel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/5/9.
//

import Foundation

let MUSCLE_RADAR_DETAIL_TYPE_KEY: String = "muscleradardetailtype"

enum Muscleradardetailtype: String, CaseIterable {
    case summary, history
}

class Analysisedexercisewrapper {
    var analysis: Analysisedexercise

    init(_ analysis: Analysisedexercise) {
        self.analysis = analysis
    }
}

class Muscleradardetailmodel: ObservableObject {
    @Published var pagedto: Muscleradardetailtype

    /*
     * variables
     */
    let days: Int
    var muscleid: String

    let workouttimes: Int

    /*
     * analysises
     */
    var maxcount: Int = 0
    var analysises: [Analysisedexercisewrapper] = []
    var exerciseids: [Int64] = []
    var exerciseid2analysises: [Int64: [Analysisedexercisewrapper]] = [:]

    init(_ muscleid: String, days: Int, workouttimes: Int) {
        self.muscleid = muscleid
        self.days = days
        self.workouttimes = workouttimes

        pagedto = .summary

        if let _cache = AppDatabase.shared.queryappcache(MUSCLE_RADAR_DETAIL_TYPE_KEY) {
            pagedto = Muscleradardetailtype(rawValue: _cache.cachevalue) ?? .summary
        }

        refresh()
    }

    func refresh() {
        Task.init {
            if days <= 0 {
                return
            }

            let end = Date()
            let start = Calendar.current.date(byAdding: .day, value: -days, to: end) ?? end
            let interval = DateInterval(start: start, end: end)

            let rawanalysises = AppDatabase.shared.queryanalysisedexercise(interval, muscleid: muscleid)
            let analysises = rawanalysises.map({ Analysisedexercisewrapper($0) })

            let exerciseid2analysises = Dictionary(grouping: analysises, by: { $0.analysis.exerciseid })
            let exerciseids = exerciseid2analysises.keys.sorted(by: { lid, rid in
                if let _las = exerciseid2analysises[lid], let _ras = exerciseid2analysises[rid] {
                    return _las.count > _ras.count
                }

                return lid < rid
            })

            DispatchQueue.main.async {
                self.analysises = analysises
                self.exerciseids = exerciseids
                self.exerciseid2analysises = exerciseid2analysises

                let maxcount = exerciseid2analysises.values.map{ $0.count }.max() ?? 0
                self.maxcount = maxcount < 5 ? maxcount * 2 : maxcount
                
                self.objectWillChange.send()
            }
        }
    }
}
