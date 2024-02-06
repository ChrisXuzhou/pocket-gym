//
//  MusclesDisplayedModel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/1/27.
//
import Foundation

class Reviewpanelmodel: ObservableObject {
    /*
     * for graph display id
     */
    var graphid2descriptors: [String: Muscledescripor] = [:]
    var descriptors: [Muscledescripor] = []

    var workoutscoutmax: Int = 0

    /*
     * variables
     */
    var days: Int = 7
    var analysiseds: [Analysisedmuscle] = []

    init() {
        if let _cache = AppDatabase.shared.queryappcache(REVIEW_DAYS_KEY) {
            days = Int(_cache.cachevalue) ?? 7
        }

        refresh()
    }

    func refresh() {
        if days < 1 {
            return
        }

        Task.init {
            let end = Date()
            let start = Calendar.current.date(byAdding: .day, value: -days, to: end) ?? end
            let interval = DateInterval(start: start, end: end)

            analysiseds = AppDatabase.shared.queryAnalysisedmuscles(interval)

            analysis()
        }
    }

    init(_ analysiseds: [Analysisedmuscle]) {
        self.analysiseds = analysiseds

        Task.init {
            analysis()
        }
    }

    func analysis() {
        if analysiseds.isEmpty {
            return
        }

        let graphid2analysiseds = Dictionary(grouping: analysiseds, by: {
            if let _graphid = Librarynewdisplayedmuscle.shared.dictionary[$0.displaymainid]?.graphmuscleid {
                return _graphid
            }

            return "notfound"

        })

        let _graphid2descriptors =
            Dictionary(uniqueKeysWithValues:
                graphid2analysiseds.map { (key: String, value: [Analysisedmuscle]) in
                    (key, Muscledescripor(muscleid: key, graphmuscleid: key, analysisedlist: value))
                }
            )

        DispatchQueue.main.async {
            self.graphid2descriptors = _graphid2descriptors
            self.descriptors = Array(_graphid2descriptors.values)
            self.objectWillChange.send()
        }
    }
}
