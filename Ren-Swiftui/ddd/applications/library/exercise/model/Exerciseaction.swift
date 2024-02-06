//
//  Exerciseactioncontext.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/2/23.
//

import Foundation
import GRDB

extension AppDatabase {
    func observeMarkedexerciseidlist(
        onError: @escaping (Error) -> Void,
        onChange: @escaping ([Exerciseconfig]) -> Void) -> DatabaseCancellable {
        let observation = ValueObservation
            .tracking(
                Exerciseconfig
                    .filter(Column("mark") == "focused")
                    .fetchAll
            )

        return observation.start(
            in: dbWriter,
            onError: onError,
            onChange: onChange)
    }
}

class Exerciseactioncontext: ObservableObject {
    let Viewusage: Viewusage?

    /*
     * select or mark action
     */
    @Published var checkedexerciseidlist: Set<Int64>
    @Published var markedexerciseidlist: Set<Int64>

    init(Viewusage: Viewusage? = .onlyview) {
        self.Viewusage = Viewusage

        checkedexerciseidlist = []
        markedexerciseidlist = []

        // 1、marked exercises
        refreshMarkedexerciselist()
        observeMarkedexerciselist()
    }

    func refreshMarkedexerciselist() {
        let configlist = AppDatabase.shared.queryFocusedexerciseconfigList()
        if configlist.isEmpty {
            return
        }
        markedexerciseidlist = Set<Int64>(configlist.map { $0.exerciseid })
    }

    var markedexerciselistObservable: DatabaseCancellable?

    private func observeMarkedexerciselist() {
        markedexerciselistObservable = AppDatabase.shared.observeMarkedexerciseidlist(
            onError: { error in fatalError("Unexpected error: \(error)") },
            onChange: { [weak self] markedexercises in
                self?.markedexerciseidlist = Set<Int64>(markedexercises.map { $0.exerciseid })
            })
    }

    var selectedexerciselist: [Newdisplayedexercise] {
        var selectedexerciselist: [Newdisplayedexercise] = []
        for checked in checkedexerciseidlist {
            if let _checked = AppDatabase.shared.queryNewexercisedef(exerciseid: checked) {
                selectedexerciselist.append(
                    Newdisplayedexercise(_checked)
                )
            }
        }
        return selectedexerciselist
    }
}

extension Exerciseactioncontext: ExerciselabelAware {
    func labelusage() -> Viewusage {
        return Viewusage ?? .onlyview
    }

    func isselected(_ exercise: Exercisedef) -> Bool {
        checkedexerciseidlist.contains(exercise.id!)
    }

    func selectorunselect(_ exercise: Exercisedef) {
        if !showselect {
            return
        }

        if isselected(exercise) {
            checkedexerciseidlist.remove(exercise.id!)
        } else {
            checkedexerciseidlist.insert(exercise.id!)
        }
    }

    func ismarked(_ exercise: Exercisedef) -> Bool {
        markedexerciseidlist.contains(exercise.id!)
    }

    func markorunmark(_ exercise: Exercisedef) {
        if ismarked(exercise) {
            try! AppDatabase.shared.deleteFocusedexerciseconfig(exercise.id!)
        } else {
            var exerciseconfig = Exerciseconfig(exerciseid: exercise.id!, mark: .focused)
            try! AppDatabase.shared.saveExerciseconfig(&exerciseconfig)
        }
    }

    var showselect: Bool {
        Viewusage != .onlyview
    }

    func canselect() -> Bool {
        return showselect
    }

    var showonlyview: Bool {
        Viewusage == .onlyview
    }
}

extension Exerciseactioncontext {
    static var shared = Exerciseactioncontext()
}
