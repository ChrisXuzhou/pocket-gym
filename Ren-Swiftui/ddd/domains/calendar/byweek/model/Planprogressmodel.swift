//
//  Planprogressmodel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/5/27.
//

import Foundation

class Planprogressmodel: ObservableObject {
    var plan: Plan?
    var plantasklist: [Plantask]
    var workoutlist: [Workout]

    var progress: (Int, Int)

    init(_ planid: Int64) {
        plan = AppDatabase.shared.queryplan(id: planid)
        plantasklist = AppDatabase.shared.queryplantasklist(planid: planid)
        workoutlist = []

        var total = 0
        var finished = 0

        if !plantasklist.isEmpty {
            let workoutidlist = plantasklist.map({ $0.workoutid })
            workoutlist = AppDatabase.shared.queryrangeworkoutlist(workoutidlist)

            for eachtask in workoutlist {
                if eachtask.isfinished {
                    finished += 1
                }
            }
            
            total = workoutlist.count
        }

        progress = (finished, total)
    }
}
