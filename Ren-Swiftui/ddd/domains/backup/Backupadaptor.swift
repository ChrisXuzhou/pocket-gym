//
//  Backupadaptor.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/10/28.
//

import CloudKit
import Foundation

struct Recordpackage {
    var id: Int64
    var json: String
    var createtime: Date = Date()
}

extension Recordpackage {
    var ckrecordid: CKRecord.ID {
        return CKRecord.ID(recordName: "Record\(id)")
    }
}

struct Exercisepackage {
    var id: Int64
    var json: String
    var createtime: Date = Date()
}

extension Exercisepackage {
    var ckrecordid: CKRecord.ID {
        return CKRecord.ID(recordName: "Exercise\(id)")
    }
}

class Backupadaptor {
    /*
     * cloud check.
     */
    func checkcloud(callback: @escaping (Bool, String?) -> Void) {
        let record = CKRecord(recordType: "Checkpackage", recordID: CKRecord.ID(recordName: "Checkpackage1"))

        record["id"] = 1
        record["createtime"] = Date()

        Icloudadaptor.shared.save([record]) {
            successed, msg in

            log("\(successed): \(msg ?? "")")

            callback(successed, msg)
        }

        log("[backup] Check Package finished.")
    }

    /*
     * backup workout.
     */
    private func savebackup(_ package: Recordpackage) {
        let record = CKRecord(recordType: "Recordpackage", recordID: package.ckrecordid)
        record["id"] = package.id
        record["createtime"] = package.createtime
        record["json"] = package.json

        Icloudadaptor.shared.save([record]) {
            successed, msg in

            log("\(successed): \(msg ?? "")")
        }
    }

    /*
     * backup exercise.
     */
    private func savebackup(_ package: Exercisepackage) {
        let record = CKRecord(recordType: "Exercisepackage", recordID: package.ckrecordid)
        record["id"] = package.id
        record["createtime"] = package.createtime
        record["json"] = package.json

        Icloudadaptor.shared.save([record])
    }
}

class RecordWorkout: Codable {
    var workout: Workout?

    /*
     * workout related.
     */
    var batchs: [Batch] = []
    var batcheexercisedefs: [Batchexercisedef] = []
    var batcheachlogs: [Batcheachlog] = []

    /*
     * analysised related.
     */
    var analysisedexercises: [Analysisedexercise] = []
    var analysisedmuscles: [Analysisedmuscle] = []
}

class RecordExercise: Codable {
    var exercise: Newexercisedef

    init(exercise: Newexercisedef) {
        self.exercise = exercise
    }
}

extension Backupadaptor {
    /*
     * save related workouts.
     */
    func saveWorkout(_ workoutid: Int64?) {
        if workoutid == nil {
            return
        }

        let _workoutid = workoutid!

        let record = RecordWorkout()

        if let _workout = AppDatabase.shared.queryworkout(_workoutid) {
            record.workout = _workout

            /*
             * workouts:
             */
            record.batchs = AppDatabase.shared.querybatchlist(workoutid: _workoutid)
            record.batcheexercisedefs = AppDatabase.shared.querybatchexercisedeflist(workoutid: _workoutid)
            record.batcheachlogs = AppDatabase.shared.querybatcheachloglist(workoutid: _workoutid)

            /*
             * analysiseds:
             */
            record.analysisedmuscles = AppDatabase.shared.queryAnalysisedmuscles(workoutid: _workoutid)
            record.analysisedexercises = AppDatabase.shared.queryAnalysisedexerciselist(workoutid: _workoutid)

            /*
             * tojson
             */
            let encodedData = try! JSONEncoder().encode(record)
            let json: String = String(data: encodedData, encoding: .utf8) ?? ""

            if !json.isEmpty {
                savebackup(Recordpackage(id: _workoutid, json: json))
            }
        }

        log("[backup] Record/Workout finished.")
    }

    func deleteWorkout(_ workoutid: Int64?) {
        if workoutid == nil {
            return
        }

        let _workoutid = workoutid!
        Icloudadaptor.shared.save([], deleteds: [CKRecord.ID(recordName: "Record\(_workoutid)")])
    }

    /*
     * save new exercise
     */
    func saveExercise(_ exerciseid: Int64) {
        let _exerciseid = exerciseid

        if let _exercisedef = AppDatabase.shared.queryNewexercisedef(exerciseid: _exerciseid) {
            let record = RecordExercise(exercise: _exercisedef)

            /*
             * tojson
             */
            let encodedData = try! JSONEncoder().encode(record)
            let json: String = String(data: encodedData, encoding: .utf8) ?? ""

            if !json.isEmpty {
                savebackup(Exercisepackage(id: _exerciseid, json: json))
            }
        }
    }

    func deleteExercise(_ exerciseid: Int64?) {
        if exerciseid == nil {
            return
        }

        let _exerciseid = exerciseid!
        Icloudadaptor.shared.save([], deleteds: [CKRecord.ID(recordName: "Exercise\(_exerciseid)")])
    }
}

extension Backupadaptor {
    static var shared = Backupadaptor()
}

extension Backupadaptor {
    /*
     * query related.
     */
    func recoverexercisebackups(_ minworkoutid: Int64) {
        let predicate = NSPredicate(format: "id > %i", minworkoutid)
        let query = CKQuery(recordType: "Exercisepackage", predicate: predicate)

        Icloudadaptor.shared.queryRecords(query: query) { results in

            for result in results {
                if let _json: String = result["json"] {
                    do {
                        let data = Data(_json.utf8)
                        let decoder = JSONDecoder()
                        let recordexercise = try decoder.decode(RecordExercise.self, from: data)

                        self.handlerecordexercise(recordexercise)

                    } catch let jsonError as NSError {
                        log("JSON decode failed: \(jsonError)")
                        return false
                    } catch {
                        log("decode data error.")
                        return false
                    }
                }
            }

            log("[recover] exercise successed.")

            return true
        }
    }

    private func handlerecordexercise(_ recordexercise: RecordExercise) {
        var _exercise: Newexercisedef = recordexercise.exercise

        try! AppDatabase.shared.saveNewexercisedef(&_exercise)
        log("[recover] exercise \(_exercise.id ?? -999)")
    }

    /*
     * query related.
     */
    func recoverrecordbackups(_ minworkoutid: Int64) {
        let predicate = NSPredicate(format: "id > %i", minworkoutid)
        let query = CKQuery(recordType: "Recordpackage", predicate: predicate)

        Icloudadaptor.shared.queryRecords(query: query) { results in

            for result in results {
                if let _json: String = result["json"] {
                    do {
                        let data = Data(_json.utf8)
                        let decoder = JSONDecoder()
                        let recordworkout = try decoder.decode(RecordWorkout.self, from: data)

                        self.handlerecordworkout(recordworkout)

                    } catch let jsonError as NSError {
                        log("JSON decode failed: \(jsonError)")
                        return false
                    } catch {
                        log("decode data error.")
                        return false
                    }
                }
            }

            log("[recover] record successed.")

            return true
        }
    }

    private func handlerecordworkout(_ recordworkout: RecordWorkout) {
        if var _workout = recordworkout.workout {
            /*
             * workout
             */
            try! AppDatabase.shared.saveworkout(&_workout)

            try! AppDatabase.shared.savebatchs(&recordworkout.batchs)
            try! AppDatabase.shared.savebatchexercisedefs(&recordworkout.batcheexercisedefs)
            try! AppDatabase.shared.savebatcheachlogs(&recordworkout.batcheachlogs)

            /*
             * analysiseds
             */
            try! AppDatabase.shared.saveAnalysisedmuscles(&recordworkout.analysisedmuscles)
            try! AppDatabase.shared.saveAnalysisedexerciselist(&recordworkout.analysisedexercises)

            log("[recover] workout \(_workout.id ?? -999)")
        }
    }
}
