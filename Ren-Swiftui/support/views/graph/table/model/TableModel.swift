//
//  TableModel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/3.
//

import Foundation

struct Tablevalue {
    var first: String
    var firstfooter: String?

    var second: Double?
    var secondfooter: String?
}

enum Tablevaluetype {
    case tablevalue, tabletail
}

struct Tablevaluelist {
    var tablevaluetype: Tablevaluetype = .tablevalue
    var title: String
    var tablevaluelist: [Tablevalue?]
}
