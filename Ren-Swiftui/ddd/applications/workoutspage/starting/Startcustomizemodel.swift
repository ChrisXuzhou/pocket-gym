//
//  Startcustomizemodel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/6/11.
//

import Foundation

enum Daysrange: String, Codable, CaseIterable {
    case lessthan3days, three, four, five, morethan5days

    var days: Int {
        switch self {
        case .lessthan3days:
            return 2
        case .three:
            return 3
        case .four:
            return 4
        case .five:
            return 5
        case .morethan5days:
            return 6
        }
    }
}

class Startcustomizemodel: ObservableObject {
    @Published var level: Programlevel = .beginner
    @Published var daysrange: Daysrange = .lessthan3days

    @Published var present = false

}
