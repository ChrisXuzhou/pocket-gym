//
//  ReferenceDefinition.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/2/20.
//

import Foundation
import GRDB
import SwiftUI

class PersonalDefinition: ObservableObject {
    var selfie: Selfie?

    init() {
        let _s = AppDatabase.shared.querySelfie()
        selfie = _s
        observeSelfie()
    }

    static func decideThemecolor(_ gender: Gender) -> Color {
        switch gender {
        case .male:
            return Color("Theme")
        case .female:
            return Color("ThemePink")
        case .other:
            return .purple
        }
    }

    var selfieObservable: DatabaseCancellable?

    private func observeSelfie() {
        selfieObservable = AppDatabase.shared.observeSelfie(
            onError: { error in fatalError("Unexpected error: \(error)") },
            onChange: { [weak self] selfieList in

                if selfieList.isEmpty {
                    return
                }

                let _s = selfieList[0]
                self?.selfie = _s

                self?.objectWillChange.send()
            })
    }

    var ofgender: Gender {
        selfie?.gender ?? .male
    }

    var ofweight: Weight {
        let _weight = selfie?.weight ?? 0
        return Weight(value: Double(_weight), weightunit: selfie?.weightunit ?? .kg)
    }
}

extension PersonalDefinition {
    static var shared = PersonalDefinition()
}
