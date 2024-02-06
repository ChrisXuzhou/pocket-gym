//
//  Muscledescriptor.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/4/6.
//

import Foundation

class Muscledescripor {
    var muscleid: String
    var graphmuscleid: String
    var analysisedlist: [Analysisedmuscle]

    init(muscleid: String,
         graphmuscleid: String,
         analysisedlist: [Analysisedmuscle]) {
        self.muscleid = muscleid
        self.graphmuscleid = graphmuscleid
        self.analysisedlist = analysisedlist
    }
}

extension Muscledescripor {
    var _muscleid: Int {
        Muscle.shared.ofmuscle(muscleid)?._id ?? -1
    }
}
