//
//  Newexerciselibrary.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/10/4.
//

import Foundation

class Keyexercise: ObservableObject {
    var key: String
    var exercises: [Newdisplayedexercise]

    init(key: String, exercises: [Newdisplayedexercise]) {
        self.key = key
        self.exercises = exercises.sorted(by: { l, r in
            l.exercise.ident < r.exercise.ident
        })
    }
}

class Newdisplayedexercise: ObservableObject {
    var exercise: Newexercisedef

    init(_ exercise: Newexercisedef) {
        self.exercise = exercise
    }
}

extension Newdisplayedexercise: Equatable {
    static func == (lhs: Newdisplayedexercise, rhs: Newdisplayedexercise) -> Bool {
        lhs.exercise.id == rhs.exercise.id
    }
}

extension Newdisplayedexercise {
    var realname: String {
        if exercise.name != nil && !(exercise.name?.isEmpty ?? true) {
            return exercise.name ?? ""
        }

        return PreferenceDefinition.shared.language(exercise.ident)
    }

    func displayequipments(_ preference: PreferenceDefinition) -> String {
        preference.language(exercise.equipmentidx)
        /*
         Array(exercise.equipmentids.split(separator: "/"))
         .map({ preference.language($0.lowercased()) })
         .joined(separator: ", ")
         */
    }

    var focusedmuscleid: String {
        exercise.muscleid
    }

    var focuseddisplayedgroupid: String {
        exercise.displayedgroupid
    }

    var focusedtargetarea: String {
        if exercise.displayedprimaryid.isEmpty {
            return exercise.displayedgroupid
        }
        return exercise.displayedprimaryid
    }
    
    func displaygroupid(_ preference: PreferenceDefinition) -> String {
        preference.language(exercise.displayedgroupid)
    }

    func displaytargetarea(_ preference: PreferenceDefinition) -> String {
        if exercise.displayedprimaryid.isEmpty {
            return preference.language(exercise.displayedgroupid)
        }
        return preference.language(exercise.displayedprimaryid)
    }

    func displayfulltargetarea(_ preference: PreferenceDefinition) -> String {
        if !exercise.displayedprimaryid.isEmpty {
            return "\(preference.language(exercise.displayedprimaryid))(\(preference.language(exercise.displayedgroupid)))"
        }
        return preference.language(exercise.displayedgroupid)
    }
}

extension Newdisplayedexercise {
    func calculateload(reps: Int, weight: Double) -> Double {
        switch exercise.weighttype {
        case .single:
            return Double(reps) * weight
        case .double:
            return Double(reps) * weight * 2
        }
    }

    func caculatevolume(_ batcheachlog: Batcheachlog) -> Weight {
        let weight = batcheachlog.ofloadweight.transformedto(weightunit: batcheachlog.weightunit)

        switch exercise.weighttype {
        case .single:
            return Weight(value: Double(batcheachlog.repeats) * weight, weightunit: batcheachlog.weightunit)
        case .double:
            return Weight(value: Double(batcheachlog.repeats) * weight * 2, weightunit: batcheachlog.weightunit)
        }
    }
}

