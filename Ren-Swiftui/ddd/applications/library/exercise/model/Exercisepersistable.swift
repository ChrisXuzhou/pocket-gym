//
//  ExercisePersistable.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/4/20.
//

import Foundation
import GRDB

struct ExercisePersistable: Hashable, Codable, Identifiable {
    var id: Int64?

    /*
     * name related
     */
    var name: String
    var systemname: String

    /*
     * img related
     */
    var imgname: String

    var primarymuscle: String
    var secondarymuscles: String

    var equipments: String
    var calc: Caculateweight?
    var type: Logtype?
    var source: Source
    var deleted: Bool = false
}

extension ExercisePersistable: FetchableRecord, MutablePersistableRecord {
    public enum Columns {
        static let id = Column(CodingKeys.id)
    }

    public mutating func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
}

extension DerivableRequest where RowDecoder == ExercisePersistable {
    func orderedbyIddesc() -> Self {
        order(ExercisePersistable.Columns.id.desc)
    }
}

extension AppDatabase {
    func saveexercisepersistable(_ exercisepersistable: inout ExercisePersistable) throws {
        try dbWriter.write { db in
            try exercisepersistable.save(db)
        }
    }

    func saveexercisepersistables(_ exercisepersistables: inout [ExercisePersistable]) throws {
        try dbWriter.write { db in
            for var exercisepersistable in exercisepersistables {
                try exercisepersistable.save(db)
            }
        }
    }

    func deleteexercisesdangerous() throws {
        try dbWriter.write { db in
            _ = try ExercisePersistable.deleteAll(db)
        }
    }

    func deleteexercisepersistable(id: Int64) throws {
        try dbWriter.write { db in
            _ = try ExercisePersistable.deleteOne(db, id: id)
        }
    }

    func queryexercisepersistablelist(_ source: Source) -> [ExercisePersistable] {
        let exercisepersistables: [ExercisePersistable] = try! dbWriter.read { db in
            try ExercisePersistable
                .filter(Column("source") == source.rawValue)
                .order(Column("id"))
                .fetchAll(db)
        }
        return exercisepersistables
    }

    func queryexercisepersistablelist() -> [ExercisePersistable] {
        let exercisepersistables: [ExercisePersistable] = try! dbWriter.read { db in
            try ExercisePersistable
                .order(Column("id"))
                .fetchAll(db)
        }
        return exercisepersistables
    }

    func querynotdeletedexercisepersistablelist() -> [ExercisePersistable] {
        let exercisepersistables: [ExercisePersistable] = try! dbWriter.read { db in
            try ExercisePersistable
                .filter(Column("deleted") == false)
                .fetchAll(db)
        }
        return exercisepersistables
    }

    func queryexercisepersistable(id: Int64) -> ExercisePersistable? {
        let ret: ExercisePersistable? = try! dbWriter.read { db in
            try ExercisePersistable
                .fetchOne(db, id: id)
        }
        return ret
    }

    func queryrangeexercisepersistablelist(firstid: Int64, lastid: Int64) -> [ExercisePersistable] {
        let exercises: [ExercisePersistable] = try! dbWriter.read { db in
            try ExercisePersistable
                .filter(Column("id") <= lastid)
                .filter(Column("id") >= firstid)
                .fetchAll(db)
        }
        return exercises
    }

    func queryfirstexercise() -> ExercisePersistable? {
        let exercise: ExercisePersistable? = try! dbWriter.read { db in
            try ExercisePersistable
                .order(Column("id").asc)
                .limit(1)
                .fetchOne(db)
        }
        return exercise
    }

    func querylastexercise() -> ExercisePersistable? {
        let exercise: ExercisePersistable? = try! dbWriter.read { db in
            try ExercisePersistable
                .order(Column("id").desc)
                .limit(1)
                .fetchOne(db)
        }
        return exercise
    }
}

extension ExercisePersistable {
    var toexercisedef: Exercisedef {
        let secondarymuscles: [String] = self.secondarymuscles.components(separatedBy: ",").filter { !$0.isEmpty }
        let definedmuscle = DefMuscle(primary: primarymuscle, secondary: secondarymuscles)
        let equipmentlist: [String] =
            equipments
                .components(separatedBy: ",")
                .filter { !$0.isEmpty }
                .map({ $0.replacingOccurrences(of: " ", with: "").lowercased() })

        return Exercisedef(
            id: id ?? -1,
            username: name,
            systemname: systemname,
            imgname: imgname,
            muscle: definedmuscle,
            equipment: equipmentlist,
            calc: calc,
            source: source,
            type: type,
            deleted: deleted
        )
    }
}
