//
//  EquipmentKeyexercise.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/10/6.
//

import Foundation

class EquipmentKeyexercise: ObservableObject {
    var equipmentid: String
    /*
     * key: keyexercises
     */
    var dictionary: [String: Keyexercise] = [:]

    init(_ equipmentid: String, exercises: [Newdisplayedexercise]) {
        self.equipmentid = equipmentid

        let key2exercises = Dictionary(grouping: exercises, by: { $0.exercise.key })
        key2exercises.forEach { (key: String, eachkeyexercises: [Newdisplayedexercise]) in
            dictionary[key] = Keyexercise(key: key, exercises: eachkeyexercises)
        }
    }

    var keys: [String] {
        Array(
            dictionary.keys.sorted { l, r in
                
                if l == "others" {
                    return "zz" < r
                } else if r == "others" {
                    return l < "zz"
                }
                
                return l < r
            }
        )
    }
}
