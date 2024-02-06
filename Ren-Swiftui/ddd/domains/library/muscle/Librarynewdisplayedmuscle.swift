//
//  Musclelibary.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/10/4.
//

import Foundation
import GRDB

class Newdisplayedmusclewrapper: ObservableObject {
    var muscle: Newdisplayedmuscle
    var children: [Newdisplayedmusclewrapper] = []

    var father: Newdisplayedmusclewrapper?

    init(_ muscle: Newdisplayedmuscle, children: [Newdisplayedmusclewrapper] = [], father: Newdisplayedmusclewrapper? = nil) {
        self.muscle = muscle
        self.children = children
        self.father = father
    }

    var isgroup: Bool {
        father == nil
    }
}

extension Newdisplayedmusclewrapper: Equatable {
    static func == (lhs: Newdisplayedmusclewrapper, rhs: Newdisplayedmusclewrapper) -> Bool {
        lhs.muscle.id == rhs.muscle.id
    }
}

extension Newdisplayedmusclewrapper {
    var displayedgroupid: String {
        if let _father = father {
            return _father.muscle.ident
        }
        return muscle.ident
    }

    var displayedmainid: String {
        return muscle.ident
    }

    var graphmuscleid: String {
        switch muscle.ident {
        case "chest_upper":
            return "chest"
        case "chest_middle":
            return "chest"
        case "chest_lower":
            return "chest"
        case "chest_others":
            return "chest"

        case "shoulders_front_middle":
            return "shoulders"
        case "shoulders_rear":
            return "shoulders"
        case "shoulders_rotator_cuff":
            return "shoulders"

        case "whole_back":
            return "back"
        case "latissimus_dorsi":
            return "back"
        case "trapezius":
            return "trapezius"
        case "biceps":
            return "biceps"
        case "brachialis_brachioradialis":
            return "biceps"
        case "triceps":
            return "triceps"

        case "quadriceps":
            return "quadriceps"
        case "hamstrings":
            return "hamstrings"
        case "glutes":
            return "glutes"

        case "abs":
            return "abs"
        case "lowerback":
            return "lowerback"
        case "obliques":
            return "obliques"

        case "calves":
            return "calves"
        case "forearms":
            return "forearms"
        case "adductors":
            return "adductors"

            /*

         case "abductors":
             return "abductors"
         case "neck":
             return "neck"
             */

        default:
            return muscle.ident
        }
    }
}

class Librarynewdisplayedmuscle: ObservableObject {
    /*
     * displayed top muscles
     */
    var groups: [Newdisplayedmusclewrapper] = []

    /*
     * newident : displayed muscle wrapper
     */
    var dictionary: [String: Newdisplayedmusclewrapper] = [:]

    init() {
        fetchandprganize()
    }
}

extension Librarynewdisplayedmuscle {
    func fetchandprganize() {
        let all: [Newdisplayedmusclewrapper] =
            AppDatabase.shared.queryNewdisplayedmuscles().map({ Newdisplayedmusclewrapper($0) })

        dictionary = Dictionary(uniqueKeysWithValues: all.map({ ($0.muscle.ident, $0) }))

        let rootdictionary: [String: Newdisplayedmusclewrapper] =
            Dictionary(uniqueKeysWithValues: all.filter({ $0.muscle.groupid == nil }).map({ ($0.muscle.ident, $0) }))

        let maindictionary: [String: [Newdisplayedmusclewrapper]] =
            Dictionary(grouping: all.filter({ $0.muscle.groupid != nil }), by: { $0.muscle.groupid ?? "" })

        all.forEach { m in
            if m.muscle.groupid == nil {
                // group type
                groups.append(m)

                if let _children = maindictionary[m.muscle.ident] {
                    m.children = _children
                }
            } else {
                // sub type
                if let _p = rootdictionary[m.muscle.groupid!] {
                    m.father = _p
                }
            }
        }
    }

    var musclegroupids: [String] {
        groups.map({ $0.displayedgroupid }).filter({ $0 != "any" && $0 != COMPOUND })
    }

    var musclegroups: [Newdisplayedmusclewrapper] {
        groups.filter({ $0.displayedgroupid != "any" && $0.displayedgroupid != COMPOUND })
    }
}

extension Librarynewdisplayedmuscle {
    static var shared = Librarynewdisplayedmuscle()
}

extension Newmuscledef {
    var groupid: String {
        Librarynewdisplayedmuscle.shared.dictionary[displayedid]?.displayedgroupid ?? COMPOUND
    }
}

class Musclelibrary {
    var muscles: [Newmuscledef] = []

    /*
     * muscleid: Newmuscledef
     */
    var dictionary: [String: Newmuscledef] = [:]
    /*
     * groupid: [Newmuscledef]
     */
    var groupdictionary: [String: [Newmuscledef]] = [:]

    init() {
        let all = AppDatabase.shared.queryNewmuscledefs()
        if all.isEmpty {
            return
        }

        muscles = all
        dictionary = Dictionary(uniqueKeysWithValues: all.map { ($0.ident, $0) })
        groupdictionary = Dictionary(grouping: all, by: { $0.groupid })
    }
}

extension Musclelibrary {
    static var shared = Musclelibrary()
}
