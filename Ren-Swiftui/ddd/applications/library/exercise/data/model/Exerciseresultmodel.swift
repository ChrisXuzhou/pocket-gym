//
//  AchievementsModel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/2/28.
//

import Foundation

class Exerciseresultmodel: ObservableObject {
    @Published var type: Exercisedatatype = .volume

    let exercise: Exercisedef
    var analysisedlist: [Analysisedexercise]

    init(_ exercise: Exercisedef) {
        self.exercise = exercise
        analysisedlist = []
        
        refresh()
    }
    
    init(_ exercise: Exercisedef, analysisedlist: [Analysisedexercise]) {
        self.exercise = exercise
        self.analysisedlist = analysisedlist
    }

    func refresh() {
        let analysisedlist = AppDatabase.shared.querylast20analysisedexercise(exerciseid: exercise.id!)
        if analysisedlist.isEmpty {
            return
        }
        self.analysisedlist = analysisedlist.sorted(by: { l, r in
            l.workday > r.workday
        })

        objectWillChange.send()
    }
    
    
}
