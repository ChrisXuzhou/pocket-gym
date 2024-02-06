//
//  WorkoutExporter.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/10/30.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

class WorkoutExporter {
    init(workoutid: Int64) {
        let workout = AppDatabase.shared.queryworkout(workoutid)!
        workoutmodel = Workoutmodel(workout)

        let preference = PreferenceDefinition.shared

        rows = [
            [
                preference.language("workoutname"),
                preference.language("setsnumber"),
                preference.language("exercisename"),
                preference.language("setnumber"),
                preference.language("weightkg"),
                preference.language("repeats"),
                preference.language("restime"),
            ],
        ]
    }

    init(workout: Workoutmodel) {
        workoutmodel = workout

        let preference = PreferenceDefinition.shared

        rows = [
            [
                preference.language("workoutname"),
                preference.language("setsnumber"),
                preference.language("exercisename"),
                preference.language("setnumber"),
                preference.language("weightkg"),
                preference.language("repeats"),
                preference.language("restime"),
            ],
        ]
    }

    /*
     * variables
     */
    var workoutmodel: Workoutmodel

    /*
     * csv results
     */
    var rows: [[String]] = []
}

extension WorkoutExporter {
    var workoutname: String {
        workoutmodel.workout.name ??
            (workoutmodel.workout.workday ?? workoutmodel.workout.createtime).displayedshoryearmonthdate
    }

    func processbatch(_ batch: Batchmodel, workoutname: String) -> [[String]] {
        /*
         * 1. exercise dict
         */
        var batchexercisedefs: [Newdisplayedexercise] = []
        batch.orderedbatchexercisedefs.forEach {
            if let _def = $0.exercisedef {
                batchexercisedefs.append(_def)
            }
        }
        let dictionary: [Int64: Newdisplayedexercise] = Dictionary(uniqueKeysWithValues: batchexercisedefs.map({ ($0.exercise.exerciseid ?? -999, $0) }))

        // todo each batchlog to print

        let setsnumber: Int = batch.batch.num

        var rows: [[String]] = []

        if let _maxnumber = batch.numberdictionary.keys.max() {
            /*
             ForEach(0 ... _maxnumber, id: \.self) {
                 num in
             */
            for num in 0 ... _maxnumber {
                let batcheachlogs = batch.numberdictionary[num] ?? []

                for log in batcheachlogs {
                    if let _exercise = dictionary[log.batcheachlog.exerciseid] {
                        let exercisename: String = _exercise.realname

                        let setnumber: Int = log.batcheachlog.num
                        let weightkg: Double = Weight(value: log.batcheachlog.weight, weightunit: log.batcheachlog.weightunit).transformedto(weightunit: .kg)
                        let repeats: Int = log.batcheachlog.repeats
                        let restseconds: Int = log.batcheachlog.rest ?? 0

                        let setrow: [String] = [workoutname,
                                                "\(setsnumber + 1)",
                                                exercisename, "\(setnumber + 1)", String(format: "%.1f", weightkg), "\(repeats)", "\(restseconds)"]

                        rows.append(setrow)
                    }
                }
            }
        }

        return rows
    }
}

extension WorkoutExporter {
    private func _exportcsv() -> String {
        let workoutname = workoutname

        if let maxnumber = workoutmodel.batchnumberdictionary.keys.max() {
            for number in 0 ... maxnumber {
                if let _batch = workoutmodel.batchnumberdictionary[number]?.first {
                    let eachrows: [[String]] = processbatch(_batch, workoutname: workoutname)
                    if !eachrows.isEmpty {
                        rows.append(contentsOf: eachrows)
                    }
                }
            }
        }

        /*
         * temp print csv
         */
        var retrows: [String] = []
        for row: [String] in rows {
            retrows.append(row.joined(separator: ","))
        }

        return retrows.joined(separator: "\n")
    }

    func exportcsv() -> URL? {
        if let url = exporturl {
            do {
                // print(url.absoluteURL)

                try _exportcsv().write(to: url, atomically: true, encoding: .utf8)
                // let input = try String(contentsOf: url)
            } catch {
                log(error.localizedDescription)
            }

            return url
        }

        return nil
    }
}

extension WorkoutExporter {
    var exporturl: URL? {
        do {
            let path = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)

            // just send back the first one, which ought to be the only one
            return path.appendingPathComponent("\(PreferenceDefinition.shared.language("exportdata")).csv").absoluteURL
        } catch {
            // print(error)
            
        }

        return nil
    }
}

func getDocumentsDirectory() -> URL? {
    // find all possible documents directories for this user
    do {
        let path = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)

        // just send back the first one, which ought to be the only one
        return path
    } catch {
        print(error)
    }

    return nil
}
