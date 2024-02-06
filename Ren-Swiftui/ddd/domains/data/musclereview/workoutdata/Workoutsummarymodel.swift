//
//  Workoutsummarymodel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/5/7.
//

import Foundation

class Workoutsummarymodel: ObservableObject {
    @Published var type: Exercisedatatype = .onerm

    var analysisedlist: [Analysisedexercise]
    
    init(_ analysisedlist: [Analysisedexercise]) {
        self.analysisedlist = analysisedlist
    }
    
    
    init(_ exercisedef: Exercisedef) {
        let analysisedlist = AppDatabase.shared.querylast20analysisedexercise(exerciseid: exercisedef.id!)
        if analysisedlist.isEmpty {
            self.analysisedlist = []
            return
        }
        
        self.analysisedlist = analysisedlist.sorted(by: { l, r in
            l.workday < r.workday
        })
    }
}
