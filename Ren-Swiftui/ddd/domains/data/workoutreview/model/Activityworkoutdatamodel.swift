//
//  Activityworkoutdatamodel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/5/9.
//

import Foundation

class Activityworkoutdatamodel: ObservableObject {
    
    var orderedanalysisedlist: [Analysisedexercise]
    
    init(_ analysisedlist: [Analysisedexercise]) {
        self.orderedanalysisedlist = analysisedlist.sorted(by: { l, r in
            l.workday > r.workday
        })
    }
    
}
