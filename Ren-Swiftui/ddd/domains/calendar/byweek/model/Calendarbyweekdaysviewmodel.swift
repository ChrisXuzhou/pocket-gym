//
//  Calendarbyweekdaysviewmodel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/22.
//

import Foundation
import SwiftUIPager

class Calendarbyweekdaysviewmodel: ObservableObject {
    let days: [Int] = Array(-2000 ... 2000)
    let today = Date()
}


