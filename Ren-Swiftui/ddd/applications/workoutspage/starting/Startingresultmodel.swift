//
//  Startingresultmodel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/6/11.
//

import Foundation

class Startingresultmodel: ObservableObject {
    @Published var level: Programlevel
    @Published var daysrange: Daysrange

    var program: Program?

    init(level: Programlevel, daysrange: Daysrange) {
        self.level = level
        self.daysrange = daysrange
        
        findsuitableprogram()
    }

    func findsuitableprogram() {
        let programlist = AppDatabase.shared.queryprogramlist(level)
        if programlist.isEmpty {
            return
        }

        let trainingdays2programlist: [Int: [Program]] = Dictionary(grouping: programlist, by: {
            let _programid: Int64 = $0.id ?? -1

            let programeachlist = AppDatabase.shared.queryprogrameachlist(_programid)
            return abs(programeachlist.count - daysrange.days)
        })

        for _idx in 0 ..< 4 {
            if let retlist = trainingdays2programlist[_idx] {
                if !retlist.isEmpty {
                    if let _random = retlist.randomElement() {
                        program = _random
                        return
                    }
                }
            }
        }
    }
}
