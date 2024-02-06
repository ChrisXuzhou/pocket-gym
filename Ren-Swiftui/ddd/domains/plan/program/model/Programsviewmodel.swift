//
//  Programsviewmodel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/22.
//

import Foundation
import GRDB

extension AppDatabase {
    func observeprogramlist(
        onError: @escaping (Error) -> Void,
        onChange: @escaping ([Program]) -> Void) -> DatabaseCancellable {
        let observation = ValueObservation
            .tracking(
                Program.fetchAll
            )

        return observation.start(
            in: dbWriter,
            onError: onError,
            onChange: onChange)
    }
}

class Programsviewmodel: ObservableObject {
    var programs: [Program] = []
    var level2programlist: [Programlevel: [Program]] = [:]

    init() {
        observeprogramlist()
    }

    var programlistobservable: DatabaseCancellable?

    private func observeprogramlist() {
        programlistobservable = AppDatabase.shared.observeprogramlist(
            onError: { error in fatalError("Unexpected error: \(error)") },
            onChange: { [weak self] programs in
                guard let self = self else {
                    return
                }

                self.programs = programs
                self.level2programlist = Dictionary(grouping: programs, by: { $0.programlevel })

                self.objectWillChange.send()
            })
    }
}


/*

 programlist = AppDatabase.shared.queryprogramlist()
 level2programlist = Dictionary(grouping: programlist, by: { $0.programlevel })

 */
