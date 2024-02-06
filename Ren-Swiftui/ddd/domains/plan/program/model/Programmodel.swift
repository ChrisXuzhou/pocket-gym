//
//  Useprogram.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/4/1.
//

import Foundation
import GRDB

extension AppDatabase {
    func observeprogram(
        id: Int64,
        onError: @escaping (Error) -> Void,
        onChange: @escaping (Program?) -> Void) -> DatabaseCancellable {
        let observation =
            ValueObservation
                .tracking(
                    Program.filter(Column("id") == id)
                        .fetchOne
                )

        return observation.start(
            in: dbWriter,
            onError: onError,
            onChange: onChange)
    }

    func observeprogrameachlist(
        programid: Int64,
        onError: @escaping (Error) -> Void,
        onChange: @escaping ([Programeach]) -> Void) -> DatabaseCancellable {
        let observation = ValueObservation
            .tracking(
                Programeach
                    .filter(Column("programid") == programid)
                    .fetchAll
            )

        return observation.start(
            in: dbWriter,
            onError: onError,
            onChange: onChange)
    }
}

class Programmodel: ObservableObject {
    var program: Program
    var programeachlist: [Programeach]
    var daynum2programeachlist: [Int: [Programeach]]

    init(_ program: Program) {
        self.program = program
        programeachlist = []
        daynum2programeachlist = [:]

        observeprogram()
        observeprogrameachlist()
    }

    init(noobserveprogram program: Program) {
        self.program = program
        programeachlist = AppDatabase.shared.queryprogrameachlist(program.id!)
        daynum2programeachlist = Dictionary(grouping: programeachlist, by: { $0.daynum })
    }

    var programobservable: DatabaseCancellable?
    var programeachlistobservable: DatabaseCancellable?

    private func observeprogram() {
        if let programid = program.id {
            programobservable = AppDatabase.shared.observeprogram(
                id: programid,
                onError: { error in fatalError("Unexpected error: \(error)") },
                onChange: { [weak self] program in
                    if let _p = program {
                        self?.program = _p

                        self?.objectWillChange.send()
                    }
                })
        }
    }

    private func observeprogrameachlist() {
        if let programid = program.id {
            programeachlistobservable = AppDatabase.shared.observeprogrameachlist(
                programid: programid,
                onError: { error in fatalError("Unexpected error: \(error)") },
                onChange: { [weak self] programeachlist in
                    self?.programeachlist = programeachlist
                    self?.daynum2programeachlist = Dictionary(grouping: programeachlist, by: { $0.daynum })

                    self?.objectWillChange.send()
                })
        }
    }
}

class Programnameeditor: Texteditor {
    func save(_ newvalue: String?) {
        program.programname = newvalue ?? ""
        try! AppDatabase.shared.saveprogram(&program)
    }

    var program: Program

    init(_ program: Program) {
        self.program = program
    }
}

extension Programmodel {
    func buildaplan(_ startdate: Date, weightunit: Weightunit) {
        var plan = Plan(programid: program.id!, programname: program.programname)
        try! AppDatabase.shared.saveplan(&plan)
        let planid: Int64 = plan.id!

        let maxdaynum = program.days
        let daynum2programeachlist = daynum2programeachlist

        let calendar = Calendar.current

        for day in 1 ... maxdaynum {
            let trainingdate: Date = calendar.date(byAdding: .day, value: day - 1, to: startdate) ?? startdate

            if let programeachlist: [Programeach] = daynum2programeachlist[day] {
                for programeach in programeachlist {
                    let templateid = programeach.workoutid
                    if let template = AppDatabase.shared.queryworkout(templateid) {
                        template
                            .planer
                            .buildplantask(day: trainingdate, weightunit: weightunit, planid: planid, programname: program.programname)
                    }
                }
            }
        }
    }
}
