//
//  AnalysisedmuscleModel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/1/28.
//

import Foundation

enum MuscleIndicatorType {
    case cnt, volume
}

class AnalysisedmuscleViewModel: ObservableObject {
    let muscle: Muscledef
    var analysisedlist: [Analysisedmuscle]
    var id2Analysised: [Int64: Analysisedmuscle]

    @Published var focused: Analysisedmuscle?

    func focus(_ id: Int64) {
        if let found = id2Analysised[id] {
            focused = found
        }
    }

    var focusedTime: Date {
        focused?.createtime ?? Date()
    }

    init(_ muscle: Muscledef) {
        self.muscle = muscle

        analysisedlist = []
        timelineValues = []
        id2Analysised = [:]

        refresh()
    }

    func refresh() {
        let end = Date()
        let start = Calendar.current.date(byAdding: .day, value: -60, to: end) ?? end
        let interval = DateInterval(start: start, end: end)

        let analysisedlist: [Analysisedmuscle] = [] // AppDatabase.shared.queryAnalysisedmuscles(interval, muscle: muscle.identify)
        if !analysisedlist.isEmpty {
            self.analysisedlist = analysisedlist
            id2Analysised = Dictionary(uniqueKeysWithValues: analysisedlist.map({ ($0.id!, $0) }))
            focused = analysisedlist.last
        }

        _ = fetch()
    }

    var timelineValues: [MultiTimelineGraphValue]

    func fetch() -> [MultiTimelineGraphValue] {
        if timelineValues.isEmpty {
            doFetch()
        }
        return timelineValues
    }

    func doFetch() {
        analysisedlist.forEach { analysised in

                /*
                 
                 timelineValues.append(
                MultiTimelineGraphValue(id: analysised.id!,
                                        time: analysised.createtime,
                                        leftValue1: Double(analysised.primaryExerciseCnt),
                                        leftValue2: Double(analysised.secondaryExerciseCnt),
                                        rightValue: Double(analysised.primaryVolume))
                 
            )
                 */
        }
    }
}


protocol TimelineGraphAware {
    func focus(_ id: Int64)

    func focusedid() -> Int64
}

extension AnalysisedmuscleViewModel: TimelineGraphAware {
    func focusedid() -> Int64 {
        focused?.id ?? -1
    }
}
