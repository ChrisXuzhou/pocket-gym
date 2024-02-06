//
//  Pagedtoplanorroutine.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/4/28.
//

import Foundation

class Pagedtoplanorroutine: ObservableObject {
    @Published var pagedto: Planorroutine

    init() {
        pagedto = .plans

        if let _cache = AppDatabase.shared.queryappcache(TRAININGVIEW_PLANSORROUTINES_KEY) {
            pagedto = Planorroutine(rawValue: _cache.cachevalue) ?? .plans
        }
    }
}

enum Planorroutine: String, CaseIterable {
    case routines, plans // , systemroutine

    var index: Int {
        switch self {
        case .routines:
            return 0
        case .plans:
            return 1
        }
    }
}

func mockprogramlist() -> [Program] {
    try! AppDatabase.shared.deleteprograms()

    var programs: [Program] = [
        Program(
            id: -1,
            source: .system,
            programname: LANGUAGE_SCHEME_WHOLEBODY,
            programlevel: .beginner,
            programdescription:
            LANGUAGE_SCHEME_WHOLEBODY + "_description",
            trainings: 3,
            days: 7
        ),
        Program(
            id: -2,
            source: .system,
            programname: LANGUAGE_SCHEME_UPPERANDLOWER,
            programlevel: .intermediate,
            programdescription:
            LANGUAGE_SCHEME_UPPERANDLOWER + "_description",
            trainings: 4,
            days: 7
        ),
        Program(
            id: -3,
            source: .system,
            programname: LANGUAGE_SCHEME_PUSH_PULL_LEGS,
            programlevel: .intermediate,
            programdescription:
            LANGUAGE_SCHEME_PUSH_PULL_LEGS + "_description",
            trainings: 6,
            days: 7
        ),
        Program(
            id: -4,
            source: .system,
            programname: LANGUAGE_SCHEME_FOURDAY,
            programlevel: .intermediate,
            programdescription:
            LANGUAGE_SCHEME_FOURDAY + "_description",
            trainings: 4,
            days: 7
        ),
        Program(
            id: -5,
            source: .system,
            programname: LANGUAGE_SCHEME_FIVEDAY,
            programlevel: .advanced,
            programdescription:
            LANGUAGE_SCHEME_FIVEDAY + "_description",
            trainings: 5,
            days: 7
        ),
    ]

    try! AppDatabase.shared.saveprogramlist(&programs)

    return programs
}
