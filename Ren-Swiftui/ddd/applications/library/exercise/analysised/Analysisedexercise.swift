import Foundation
import GRDB

public struct Analysisedexercise: Identifiable, Hashable, Equatable {
    public var id: Int64?
    var createtime: Date = Date()

    var exerciseid: Int64
    var workoutid: Int64
    var batchid: Int64
    var muscleid: String?

    var workday: Date

    /*
     * all analysised weight unit is 'kg'.
     */
    var volume: Double
    var onerm: Double

    var sets: Int
    var minrepeats: Int

    var minweight: Double
    var maxweight: Double
    
    /*
     * var maxweightrepeats: Int
     * var averagegapseconds: Int
     */
}

extension Analysisedexercise: Codable, FetchableRecord, MutablePersistableRecord {
    // Define database columns from CodingKeys
    fileprivate enum Columns {
        static let id = Column(CodingKeys.id)
    }

    /// Updates a player id after it has been inserted in the database.
    public mutating func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
}

extension AppDatabase {
    // save
    func saveAnalysisedexerciselist(_ analysisedlist: inout [Analysisedexercise]) throws {
        try dbWriter.write { db in
            for var each in analysisedlist {
                try each.save(db)
            }
        }
    }

    // delete
    func deleteAnalysisedexerciselist(workoutid: Int64) throws {
        try dbWriter.write { db in
            _ = try Analysisedexercise.filter(Column("workoutid") == workoutid).deleteAll(db)
        }
    }

    func deleteAnalysisedexerciselist() throws {
        try dbWriter.write { db in
            _ = try Analysisedexercise.deleteAll(db)
        }
    }
    
    func queryAnalysisedexerciselist(workoutids: [Int64]) -> [Analysisedexercise] {
        let analysisedlist: [Analysisedexercise] = try! dbWriter.read { db in
            try Analysisedexercise
                .filter(workoutids.contains(Column("workoutid")))
                .fetchAll(db)
        }
        return analysisedlist
    }

    func queryAnalysisedexerciselist(workoutid: Int64) -> [Analysisedexercise] {
        let analysisedlist: [Analysisedexercise] = try! dbWriter.read { db in
            try Analysisedexercise.filter(Column("workoutid") == workoutid).fetchAll(db)
        }
        return analysisedlist
    }

    func queryAnalysisedexerciselist(workoutid: Int64, batchid: Int64) -> [Analysisedexercise] {
        let analysisedlist: [Analysisedexercise] = try! dbWriter.read { db in
            try Analysisedexercise
                .filter(Column("batchid") == batchid)
                .filter(Column("workoutid") == workoutid)
                .fetchAll(db)
        }
        return analysisedlist
    }

    func queryanalysisedexercise(batchid: Int64, exerciseid: Int64) -> Analysisedexercise? {
        let analysised: Analysisedexercise? = try! dbWriter.read { db in
            try Analysisedexercise
                .filter(Column("batchid") == batchid)
                .filter(Column("exerciseid") == exerciseid)
                .fetchOne(db)
        }
        return analysised
    }

    func queryanalysisedlist(_ interval: DateInterval) -> [Analysisedexercise] {
        let start = interval.start
        let end = interval.end

        let analysisedlist: [Analysisedexercise] = try! dbWriter.read { db in
            try Analysisedexercise
                .filter((start ... end).contains(Column("workday")))
                .fetchAll(db)
        }
        return analysisedlist
    }

    func queryanalysisedexercise(_ interval: DateInterval, exerciseid: Int64) -> [Analysisedexercise] {
        let start = interval.start
        let end = interval.end

        let analysisedlist: [Analysisedexercise] = try! dbWriter.read { db in
            try Analysisedexercise
                .filter((start ... end).contains(Column("workday")))
                .filter(Column("exerciseid") == exerciseid)
                .fetchAll(db)
        }
        return analysisedlist
    }
    
    func queryanalysisedexercise(_ interval: DateInterval, muscleid: String) -> [Analysisedexercise] {
        let start = interval.start
        let end = interval.end

        let analysisedlist: [Analysisedexercise] = try! dbWriter.read { db in
            try Analysisedexercise
                .filter((start ... end).contains(Column("workday")))
                .filter(Column("muscleid") == muscleid)
                .fetchAll(db)
        }
        return analysisedlist
    }

    func queryanalysisedexercise(_ interval: DateInterval) -> [Analysisedexercise] {
        let start = interval.start
        let end = interval.end

        let analysisedlist: [Analysisedexercise] = try! dbWriter.read { db in
            try Analysisedexercise
                .filter((start ... end).contains(Column("workday")))
                .order(Column("workday").desc)
                .fetchAll(db)
        }
        return analysisedlist
    }

    func querylast20analysisedexercise(exerciseid: Int64, limit: Int = 30) -> [Analysisedexercise] {
        let analysisedlist: [Analysisedexercise] = try! dbWriter.read { db in
            try Analysisedexercise
                .filter(Column("exerciseid") == exerciseid)
                .order(Column("workday").desc)
                .limit(limit)
                .fetchAll(db)
        }
        return analysisedlist
    }

    func querylast20analysisedexercise(limit: Int = 30) -> [Analysisedexercise] {
        let analysisedlist: [Analysisedexercise] = try! dbWriter.read { db in
            try Analysisedexercise
                .order(Column("workday").desc)
                .limit(limit)
                .fetchAll(db)
        }
        return analysisedlist
    }

    func querylast20analysisedexercise(_ interval: DateInterval, limit: Int = 30) -> [Analysisedexercise] {
        let start = interval.start
        let end = interval.end

        let analysisedlist: [Analysisedexercise] = try! dbWriter.read { db in
            try Analysisedexercise
                .filter((start ... end).contains(Column("workday")))
                .order(Column("id").desc)
                .limit(limit)
                .fetchAll(db)
        }
        return analysisedlist
    }

}

extension Analysisedexercise {
    var displayedgroupid: String? {
        if let exercise: Newdisplayedexercise = Exerciselibrary.ofexercise(exerciseid) {
            return exercise.exercise.displayedgroupid
        }
        return nil
    }
    
    var displayedmainid: String? {
        if let exercise: Newdisplayedexercise = Exerciselibrary.ofexercise(exerciseid) {
            return exercise.exercise.displayedprimaryid
        }
        return nil
    }
    
    var ofmuscleid: String? {
        if let exercise: Newdisplayedexercise = Exerciselibrary.ofexercise(exerciseid) {
            return exercise.exercise.muscleid
        }
        return nil
    }
}

extension Analysisedexercise {
    var relatedbatch: Batch? {
        let batchid = self.batchid

        return AppDatabase.shared.querybatch(id: batchid)
    }
}

/*
 
 extension Analysisedexercise {
     var primarymuscle: String {
         if let exercise = Exerciselibrary.ofexercise(exerciseid) {
             return exercise.focusedtargetarea
         }
         return ""
     }
 }
 
 */
