//
//  LibraryModel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/2/22.
//

import Foundation
import GRDB
import SwiftUI

enum Viewusage: String {
    case select, onlyview
}

class Librarymodel: ObservableObject {
    init() {
        /*
         * new exercise
         */
        shownewaexercise = false
        newedexercisedefid = nil

        /*
         * def exercise list fetch
         */
        definedlist = AppDatabase.shared.queryexercisepersistablelist().map({ $0.toexercisedef })
        observeuserdefinedlist()
    }

    /*
     * new exercise
     */
    @Published var shownewaexercise: Bool
    var newedexercisedefid: Int64?
    var newedexercisedef: Exercisedef? {
        if let _id = newedexercisedefid {
            if let def = AppDatabase.shared.queryexercisepersistable(id: _id) {
                return def.toexercisedef
            }
        }
        return nil
    }

    /*
     * total exercise deflist
     */
    var definedlist: [Exercisedef]
    var observable: DatabaseCancellable?

    private func observeuserdefinedlist() {
        observable = AppDatabase.shared.observeexerciselist(
            onError: { error in fatalError("Unexpected error: \(error)") },
            onChange: { [weak self] persistablelist in

                self?.definedlist = persistablelist.map({ $0.toexercisedef })

                self?.objectWillChange.send()
            })
    }

    let lock = NSLock()
    /*
     * exercise filter
     */

    @Published var searchtext: String = ""
    @Published var selectedmuscletype: Muscleclassify = .mainmusclegroup
    @Published var selectedmuscle: String? // = "chest"

    var showmuscleselector: Bool = true
    func togglemuscleselector() {
        lock.lock()
        defer {
            lock.unlock()
        }

        showmuscleselector = !showmuscleselector
        objectWillChange.send()
    }

    var showmarked: Bool = false
    func toggleshowmarked() {
        lock.lock()
        defer {
            lock.unlock()
        }

        showmarked = !showmarked
        objectWillChange.send()
    }

    var showselected: Bool = false
    func toggleshowselected() {
        lock.lock()
        defer {
            lock.unlock()
        }

        showselected = !showselected
        objectWillChange.send()
    }

    @Published var selectedequipments = Set<String>()

    func searchedexerciselist(_ preference: PreferenceDefinition, _ exerciseactioncontext: Exerciseactioncontext) -> [Exercisedef] {
        log("[search] begin")
        let retlist = definedlist
            .filter {
                each in
                (searchtext.isEmpty || preference.language(each.realname).lowercased().contains(searchtext.lowercased().trimmingCharacters(in: .whitespaces)))
                    && (!showmarked || exerciseactioncontext.ismarked(each))
                    && (!showselected || exerciseactioncontext.isselected(each))
                    && (selectedmuscle == nil || each.related(selectedmuscle!))
                    && (selectedequipments.isEmpty || selectedequipments.contains(each.equipmenttype))
            }

        log("[search] end")
        return retlist
    }

    func refreshequipments(_ equipments: Set<String>) {
        selectedequipments = Set<String>(equipments)
    }

    func selectedequipmentstr(_ preference: PreferenceDefinition) -> String {
        if selectedequipments.isEmpty {
            return preference.language("allequipments")
        } else {
            return selectedequipments.map({ preference.language($0) }).joined(separator: ", ")
        }
    }
}

extension Librarymodel {
    static var shared = Librarymodel()
}
