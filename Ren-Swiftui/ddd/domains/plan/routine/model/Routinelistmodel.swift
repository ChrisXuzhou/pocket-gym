//
//  RoutinelistModel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/28.
//

import Foundation
import GRDB

extension AppDatabase {
    func observeroutinelist(
        source: Source = .system,
        onError: @escaping (Error) -> Void,
        onChange: @escaping ([Workout]) -> Void) -> DatabaseCancellable {
        let observation =
            ValueObservation
                .tracking(
                    Workout
                        .filter(Column("source") == source.rawValue)
                        .filter(Column("stats") == "template")
                        .orderedbyIddesc()
                        .fetchAll
                )

        return observation.start(
            in: dbWriter,
            onError: onError,
            onChange: onChange)
    }
}

class Routinelistmodel: ObservableObject {
    var source: Source

    var templatelist: [Workout]
    var level2templatelist: [Programlevel: [Workout]]

    var creatednewtemplate: Workout?
    @Published var newatemplateview = false

    init(_ source: Source = .system) {
        self.source = source

        templatelist = AppDatabase.shared.queryworkouts(stats: .template, source: source)
        level2templatelist = Dictionary(grouping: templatelist, by: {
            $0.oflevel
        })

        creatednewtemplate = nil
        newatemplateview = false

        observetemplates()
    }

    var templatelistobservable: DatabaseCancellable?

    private func observetemplates() {
        templatelistobservable = AppDatabase.shared.observeroutinelist(
            source: source,
            onError: { error in fatalError("Unexpected error: \(error)") },
            onChange: { [weak self] templatelist in
                self?.templatelist = templatelist
                self?.level2templatelist = Dictionary(grouping: templatelist, by: {
                    $0.oflevel
                })

                self?.objectWillChange.send()
            }
        )
    }

    func createanewtemplate() {
        var newedworkout = Workout(stats: .template, source: .user)
        try! AppDatabase.shared.saveworkout(&newedworkout)

        creatednewtemplate = newedworkout
        newatemplateview = true
    }
}
