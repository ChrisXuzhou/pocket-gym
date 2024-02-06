//
//  Reviewworkoutsviewmodel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/5/9.
//

import Foundation


class Reviewworkoutsviewmodel: ObservableObject {
    
    @Published var selectedtype: Exercisedatatype
    var analysisedexercises: [Analysisedexercisewrapper]
    
    init(analysisedexercises: [Analysisedexercisewrapper], selectedtype: Exercisedatatype = .onerm) {
        self.selectedtype = selectedtype
        self.analysisedexercises = analysisedexercises
    }
    
}
