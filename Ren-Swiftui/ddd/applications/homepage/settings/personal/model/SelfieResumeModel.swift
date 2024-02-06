//
//  SelfieModel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/2/19.
//

import Foundation

extension Selfie {
    
    var age: Int {
        let dateComponents = DateComponents(year: birthyear, month: birthmonth)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!
        let components = calendar.dateComponents([.year], from: date, to: Date())

        return components.year ?? 0
    }
}
