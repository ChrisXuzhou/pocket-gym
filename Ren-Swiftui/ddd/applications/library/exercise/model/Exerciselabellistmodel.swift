//
//  Exerciselabellistmodel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/2/22.
//

import Foundation
import GRDB

extension Equipment {
    static func ofEquipmentname(_ key: String) -> String {
        if let equip = Equipment.shared.id2equipment[key] {
            return equip.id
        } else {
            return ""
        }
    }
}

class Exerciselabellistmodel: ObservableObject {
    /*
     * exercise related.
     */
    var exerciselist: [Exercisedef]
    var exerciseidset: Set<Int64>
    var exerciseid2exercise: [Int64: Exercisedef]

    /*
     * equipments related.
     */
    var equipment2exerciselist: [String: [Exercisedef]]
    var orderedequipmentlist: [String]

    /*
     * recent exercise list.
     */
    var recentexerciselist: [Exercisedef]
    var recentexerciseidset: Set<Int64>

    init(_ exerciselist: [Exercisedef]) {
        self.exerciselist = []
        exerciseidset = []
        exerciseid2exercise = [:]

        equipment2exerciselist = [:]
        orderedequipmentlist = []

        recentexerciselist = []
        recentexerciseidset = Set<Int64>()

        // 1、begin to initialize exercise data list.
        self.exerciselist = exerciselist
        exerciselist.forEach({
            let exerciseid = $0.id!
            exerciseidset.insert(exerciseid)
            exerciseid2exercise[exerciseid] = $0

        })

        // 2、equipment refresh
        refreshequipmentlist()

        // 3、recent usage
        refreshrecentexerciselist()
    }

    func refreshrecentexerciselist() {
        let calendar = Calendar.current

        // 获取近7天的数据
        let now = Date()
        let start = calendar.date(byAdding: .day, value: -21, to: now) ?? now
        let interval = DateInterval(start: start, end: now)

        let recentanalysisedexercises = AppDatabase.shared.queryanalysisedexercise(interval)
        if recentanalysisedexercises.isEmpty {
            return
        }

        var _recentexerciselist: [Exercisedef] = []

        recentanalysisedexercises.forEach {
            let exerciseid = $0.exerciseid

            if exerciseidset.contains(exerciseid) {
                if !recentexerciseidset.contains(exerciseid) {
                    let exerciseid = $0.exerciseid
                    recentexerciseidset.insert(exerciseid)
                    if let _exercisedef = exerciseid2exercise[exerciseid] {
                        _recentexerciselist.append(_exercisedef)
                    }
                }
            }
        }
        recentexerciselist = _recentexerciselist.sorted(by: { l, r in
            l.id! < r.id!
        })

        equipment2exerciselist["recently"] = recentexerciselist
    }

    func refreshequipmentlist() {
        equipment2exerciselist = Dictionary(grouping: exerciselist) {
            $0.equipmenttype
        }

        var _equipmenttypeset = Set<String>()
        Array(equipment2exerciselist.keys)
            .forEach { _eachid in
                let _type = Equipment.shared.ofequipment(_eachid).type
                _equipmenttypeset.insert(_type)
            }

        for each in LIBRARY_EQUIPMENTS {
            if _equipmenttypeset.contains(each) {
                orderedequipmentlist.append(each)
            }
        }
    }
}

let LIBRARY_EQUIPMENTS: [String] = ["barbell", "dumbbells", "smithmachine", "machine", "cable", "band", "bodyweight", "other"]
