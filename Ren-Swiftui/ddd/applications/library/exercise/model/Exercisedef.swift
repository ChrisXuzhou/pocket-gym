//
//  Exercisedef.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/4/21.
//

import Foundation

struct ExerciseExtendOnlyJsonUse: Hashable, Codable {
    var en: String
    var cn: String
}

enum Caculateweight: String, Codable, CaseIterable {
    case single, double

    var label: String {
        switch self {
        case .single:
            return "1"
        case .double:
            return "2"
        }
    }

    static func of(_ label: String) -> Caculateweight {
        if label == "1" {
            return .single
        }
        return .double
    }
}

enum Logtype: String, Codable {
    case reps, repsandweight, duration

    func display(_ batcheachlog: Batcheachlogwrapper?, weightunit: Weightunit = .kg) -> String {
        if let _beacheachlog = batcheachlog?.batcheachlog {
            switch self {
            case .reps:
                return "\(_beacheachlog.repeats)"
            case .repsandweight:
                let weight = Weight(
                    value: _beacheachlog.weight,
                    weightunit: _beacheachlog.weightunit
                )
                let _value = String(format: "%.1f", weight.transformedto(weightunit: weightunit))

                return "\(_beacheachlog.repeats) x \(_value) \(weightunit.name)"

            case .duration:
                return "\(_beacheachlog.repeats.seconds2dayshourminuts)"
            }
        }

        return "-"
    }
}

struct Exercisedef: Hashable, Codable, Identifiable {
    var id: Int64?

    var username: String?
    var systemname: String?

    var imgname: String?

    var muscle: DefMuscle?
    var equipment: [String] = []

    var calc: Caculateweight?
    var source: Source?
    var type: Logtype?

    var deleted: Bool?
    var name: ExerciseExtendOnlyJsonUse?
}

extension Exercisedef {
    static func ofempty(_ muscleid: String) -> Exercisedef {
        var newed = Exercisedef(source: .user)
        newed.muscle = DefMuscle(primary: muscleid, secondary: [])

        return newed
    }
}

extension Exercisedef {
    var realname: String {
        let _username = username ?? ""
        if !_username.isEmpty {
            return _username
        }

        return systemname ?? ""
    }

    var _id: String {
        let _systemname: String = systemname ?? ""
        if !_systemname.isEmpty {
            return _systemname
        }

        return username ?? ""
    }

    var _vName: String {
        return imgname ?? ""
    }

    var _primarymuscleid: String {
        muscle?.primary.lowercased() ?? ""
    }

    var _primarymuscledef: Muscledef {
        _def(muscle?.primary.lowercased().replacingOccurrences(of: " ", with: "") ?? "chest")
    }

    var _primarymuscledefs: [Muscledef] {
        [_def(muscle?.primary.lowercased().replacingOccurrences(of: " ", with: "") ?? "chest")]
    }

    var _secondarymuscledefs: [Muscledef] {
        var muscles: [String] = []
        if let _secondary = muscle?.secondary {
            muscles.append(contentsOf: _secondary)
        }
        return muscles.map { _def($0) }
    }

    var _secondarymuscleids: [String] {
        var muscles: [String] = []
        if let _secondary = muscle?.secondary {
            muscles.append(contentsOf: _secondary)
        }
        return muscles
    }

    var _muscles: [String] {
        var muscles: [String] = []
        if let _muscle = muscle {
            muscles.append(_muscle.primary)
            muscles.append(contentsOf: _muscle.secondary)
        }
        return muscles
    }

    var _muscleDefs: [Muscledef] {
        var muscles: [String] = []
        if let _muscle = muscle {
            muscles.append(_muscle.primary)
            muscles.append(contentsOf: _muscle.secondary)
        }
        return muscles.map { _def($0) }
    }

    var primaryequipment: String {
        equipment.isEmpty ?
            "other" :
            (equipment[0].isEmpty ? "other" : equipment[0].lowercased())
    }

    var equipmenttype: String {
        let _id = equipment.first ?? "other"

        let _e = Equipment.shared.ofequipment(_id)
        return _e.type
    }

    var isdeleted: Bool {
        return deleted ?? false
    }
}

private func _def(_ muscle: String) -> Muscledef {
    Muscle.shared.identitymap[muscle.replacingOccurrences(of: " ", with: "").lowercased()]!
}

struct DefMuscle: Hashable, Codable {
    var primary: String
    var secondary: [String]
}

extension Exercisedef {
    func isPrimary(_ m: String) -> Bool {
        muscle?.primary == m
    }

    func isSecondary(_ m: String) -> Bool {
        muscle?.secondary.contains(m) ?? false
    }
}

extension Exercisedef {
    var toExercisePersistable: ExercisePersistable {
        let primary = muscle?.primary ?? "chest"
        let secondarys: String = muscle?.secondary.joined(separator: ",") ?? ""
        let equipments = equipment.joined(separator: ",").lowercased()

        return ExercisePersistable(
            id: id,
            name: username ?? "",
            systemname: systemname ?? "",
            imgname: imgname ?? "",
            primarymuscle: primary,
            secondarymuscles: secondarys,
            equipments: equipments,
            calc: calc,
            type: type,
            source: source ?? .user,
            deleted: isdeleted
        )
    }
}

extension Exercisedef: Equatable, Comparable {
    static func < (lhs: Exercisedef, rhs: Exercisedef) -> Bool {
        lhs.id! < rhs.id!
    }

    static func == (lhs: Exercisedef, rhs: Exercisedef) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Exercisedef {
    var relatedEquipments: [EquipmentDef] {
        if equipment.isEmpty {
            return []
        }

        var retRquipments: [EquipmentDef] = []
        for e in equipment {
            let dict = Equipment.shared.id2equipment
            if let found = dict[e._id] {
                retRquipments.append(found)
            }
        }
        return retRquipments
    }
}

extension Exercisedef {
    var ofcaculateweight: Caculateweight {
        calc ?? .double
    }

    func caculatevolume(_ batcheachlog: Batcheachlog) -> Weight {
        switch ofcaculateweight {
        case .single:
            return Weight(value: Double(batcheachlog.repeats) * batcheachlog.weight, weightunit: batcheachlog.weightunit)
        case .double:
            return Weight(value: Double(batcheachlog.repeats) * batcheachlog.weight * 2, weightunit: batcheachlog.weightunit)
        }
    }

    var logtype: Logtype {
        type ?? .repsandweight
    }

    func displayrecord(_ batcheachlog: Batcheachlogwrapper) -> String {
        return logtype.display(batcheachlog)
    }
}

extension Exercisedef {
    func related(_ muscle: String) -> Bool {
        let _primary = self.muscle?.primary.lowercased().replacingOccurrences(of: " ", with: "")
        if _primary == muscle {
            return true
        }
        return false
    }
}

extension Exerciselibrary {
    func ofmuscledeflist(_ defList: [Exercisedef]) -> [Muscledef] {
        var muscles = Set<String>()
        defList.forEach { muscles.insert($0._primarymuscleid) }

        if muscles.isEmpty {
            return []
        }

        var defList: [Muscledef] = []
        muscles.forEach {
            defList.append(_def($0))
        }

        return defList.sorted { l, r in
            l.id < r.id
        }
    }

    static func ofexercise(_ exerciseid: Int64) -> Newdisplayedexercise? {
        if let _exercise = AppDatabase.shared.queryNewexercisedef(exerciseid: exerciseid) {
            return Newdisplayedexercise(_exercise)
        }
        return nil
    }
}
