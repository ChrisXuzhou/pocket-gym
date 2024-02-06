//
//  ConfigandselfieViewModel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/2/18.
//

import Foundation
import GRDB

enum Settingtype {
    case config, selfie, others

    var label: String {
        switch self {
        case .config:
            return "preference"
        case .selfie:
            return "personal"
        case .others:
            return "other"
        }
    }
}

extension AppDatabase {
    func observeSelfie(
        onError: @escaping (Error) -> Void,
        onChange: @escaping ([Selfie]) -> Void) -> DatabaseCancellable {
        let observation = ValueObservation
            .tracking(
                Selfie
                    .order(Column("id").desc)
                    .fetchAll
            )

        return observation.start(
            in: dbWriter,
            onError: onError,
            onChange: onChange)
    }
}

extension Selfie {
    static func emptyselfie() -> Selfie {
        return Selfie(nick: "",
                      phone: "", gender: .other,
                      weight: 70, weightunit: .kg,
                      height: 180,
                      birthyear: 1990, birthmonth: 6)
    }
}

class Personalsettingsmodel: ObservableObject {
    @Published var selfie: Selfie

    init() {
        selfie = AppDatabase.shared.querySelfie() ?? Selfie.emptyselfie()
        observeSelfie()
    }

    var selfieObservable: DatabaseCancellable?

    private func observeSelfie() {
        selfieObservable = AppDatabase.shared.observeSelfie(
            onError: { error in fatalError("Unexpected error: \(error)") },
            onChange: { [weak self] selfieList in
                if selfieList.isEmpty {
                    return
                }
                self?.selfie = selfieList[0]
            })
    }

    func save() {
        var _s = selfie
        try! AppDatabase.shared.saveSelfie(&_s)
        /*
         
         DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
         }
         */
    }
}
