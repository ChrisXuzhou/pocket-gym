//
//  Newexercisedef.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/10/4.
//
import Foundation
import GRDB

struct Newexercisedef: Hashable, Codable, Identifiable {
    var id: Int64?

    var ident: String
    var exerciseid: Int64?
    var key: String
    /*
     * name variables
     */
    var name: String?
    var imgname: String

    /*
     * muscle variables
     *
     */
    var muscleid: String

    var displayedprimaryid: String
    var displayedgroupid: String
    // seperated by ,
    var displayedsecondaryids: String

    /*
     * equipments
     */
    var equipmentidx: String
    // seperated by ,
    var equipmentids: String

    /*
     * others
     */
    var weighttype: Caculateweight
    var source: Source
    var logtype: Logtype

    /*
     * deleted bool
     */
    var deleted: Bool = false
    var cn: String?
    var en: String?
}

extension Newexercisedef: FetchableRecord, MutablePersistableRecord {
    public enum Columns {
        static let id = Column(CodingKeys.id)
    }

    public mutating func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
}

extension AppDatabase {
    func saveNewexercisedef(_ exercise: inout Newexercisedef) throws {
        try dbWriter.write { db in
            try exercise.save(db)
        }
    }

    func saveNewexercisedefs(_ exercises: inout [Newexercisedef]) throws {
        try dbWriter.write { db in
            for var exercise in exercises {
                try exercise.save(db)
            }
        }
    }
    
    func deleteNewexercisedef(_ def: Newexercisedef) throws {
        try dbWriter.write { db in
            _ = try def.delete(db)
        }
    }

    func deleteNewexercisedefs() throws {
        try dbWriter.write { db in
            _ = try Newexercisedef.deleteAll(db)
        }
    }

    func queryNewexercisedefs() -> [Newexercisedef] {
        let exercisesdefs: [Newexercisedef] = try! dbWriter.read { db in
            try Newexercisedef.fetchAll(db)
        }
        return exercisesdefs
    }

    func queryNewexercisedefs(_ muscleids: Set<String>) -> [Newexercisedef] {
        let exercisesdefs: [Newexercisedef] = try! dbWriter.read { db in
            try Newexercisedef
                .filter(muscleids.contains(Column("muscleid")))
                .fetchAll(db)
        }
        return exercisesdefs
    }

    func queryNewexercisedefs(_ equipmentid: String) -> [Newexercisedef] {
        let exercisesdefs: [Newexercisedef] = try! dbWriter.read { db in
            try Newexercisedef
                .filter(Column("equipmentidx") == equipmentid)
                .fetchAll(db)
        }
        return exercisesdefs
    }

    func queryNewexercisedefs(_ key: String, equipmentid: String) -> [Newexercisedef] {
        let exercisesdefs: [Newexercisedef] = try! dbWriter.read { db in
            try Newexercisedef
                .filter(Column("key") == key)
                .filter(Column("equipmentidx") == equipmentid)
                .fetchAll(db)
        }
        return exercisesdefs
    }

    func queryNewexercisedef(id: Int64) -> Newexercisedef? {
        let exercisesdef: Newexercisedef? = try! dbWriter.read { db in
            try Newexercisedef
                .filter(Column("id") == id)
                .fetchOne(db)
        }
        return exercisesdef
    }

    func queryNewexercisedef(exerciseid: Int64) -> Newexercisedef? {
        let exercisesdef: Newexercisedef? = try! dbWriter.read { db in
            try Newexercisedef
                .filter(Column("exerciseid") == exerciseid)
                .fetchOne(db)
        }
        return exercisesdef
    }

    func queryNewexercisedef(equipmentid: Int64) -> Newexercisedef? {
        let exercisesdef: Newexercisedef? = try! dbWriter.read { db in
            try Newexercisedef
                .filter(Column("equipmentidx") == equipmentid)
                .fetchOne(db)
        }
        return exercisesdef
    }
}
