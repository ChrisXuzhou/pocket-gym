//
//  Folderroutinesmodel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/9/5.
//

import Foundation
import GRDB

extension AppDatabase {
    func observeallroutines(
        onError: @escaping (Error) -> Void,
        onChange: @escaping ([Workout]) -> Void) -> DatabaseCancellable {
        let observation =
            ValueObservation
                .tracking(
                    Workout
                        .filter(Column("stats") == "template")
                        .filter(Column("source") == "user")
                        .orderedbyIddesc()
                        .fetchAll
                )

        return observation.start(
            in: dbWriter,
            onError: onError,
            onChange: onChange)
    }
}

let EMPTY_FOLDER_ID: Int64 = -999
let EMPTY_FOLDER = Folder(id: EMPTY_FOLDER_ID, parentid: nil, name: "myroutines")
let EMPTY_FOLDER_WRAPPER = Folderwrapper(EMPTY_FOLDER)

class Folderroutinesmodel: ObservableObject {
    var folderid2routines: [Int64: [Routine]] = [:]
    var id: Int64 = 0

    init() {
        observealltemplates()
    }

    /*
     * temp vars
     */
    var templates: [Routine] = []
    var focusedtemplates: [Routine] = []
    var templatesobservable: DatabaseCancellable?

    private func observealltemplates() {
        templatesobservable = AppDatabase.shared.observeallroutines(
            onError: { error in fatalError("Unexpected error: \(error)") },
            onChange: { [weak self] templates in

                guard let _self = self else {
                    return
                }
                
                _self.templates = templates.map({ Routine($0) })
                _self.focusedtemplates = _self.templates.filter({ $0.isfocused })
                _self.initializefolderroutines()
            }
        )
    }

    func initializefolderroutines() {
        folderid2routines = [:]
        if templates.isEmpty {
            objectWillChange.send()
            return
        }
        
        folderid2routines = Dictionary(grouping: templates) { $0.folderid ?? EMPTY_FOLDER_ID }
        id = id + 1

        objectWillChange.send()
    }

    var roottemplates: [Routine] {
        folderid2routines[EMPTY_FOLDER_ID] ?? []
    }
    
    func searchroutines(_ folderid: Int64, focused: Bool = false) -> [Routine] {
        if let _routines = folderid2routines[folderid] {
            if focused {
                return _routines.filter { $0.isfocused }
            } else {
                return _routines
            }
        }
        return []
    }
}

extension Folderroutinesmodel {
    static var shared = Folderroutinesmodel()
}
