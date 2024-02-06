//
//  Planmodel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/7/2.
//

import Foundation

class Planmodel: ObservableObject {
    var workoutid: Int64
    var plantasklist: [Plantask] = []
    var plan: Plan?

    init(_ workoutid: Int64) {
        self.workoutid = workoutid

        let rawlist: [Plantask] = AppDatabase.shared.queryplantasklist(workoutid: workoutid)
        if let task = rawlist.first {
            if let _panid = task.planid {
                plantasklist = AppDatabase.shared.queryplantasklist(planid: _panid)
                plan = AppDatabase.shared.queryplan(id: _panid)
            }
        }
    }
}
