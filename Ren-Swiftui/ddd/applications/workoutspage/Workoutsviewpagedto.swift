//
//  Workoutsviewpagedto.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/4/28.
//

import Foundation

class Workoutsviewpagedto: ObservableObject {
    @Published var pagedto: Workoutsviewmenupagedto

    init() {
        pagedto = .workouts

        if let _cache = AppDatabase.shared.queryappcache(PAGEDWORKOUTVIEW_KEY) {
            pagedto = Workoutsviewmenupagedto(rawValue: _cache.cachevalue) ?? .workouts
        }
    }
}
