//
//  Reviewcardcontentmodel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/6/11.
//

import Foundation

class Reviewcardcontentmodel: ObservableObject {
    var left: Double
    var right: Double

    var title: String
    var description: String

    var weightunit: Weightunit?
    
    var lefttime: Date?
    var righttime: Date?
    var vname: String?

    init(left: Double, right: Double,
         title: String, description: String,
         weightunit: Weightunit? = nil,
         lefttime: Date? = nil,
         righttime: Date? = nil,
         vname: String? = nil
    ) {
        self.left = left
        self.right = right
        self.title = title
        self.description = description

        self.weightunit = weightunit
        
        self.lefttime = lefttime
        self.righttime = righttime
        
        self.vname = vname

        calculate()
    }

    var max: Double = 0.0
    var lefty: Double = 0.0
    var righty: Double = 0.0

    var delta: Double = 0.0

    func calculate() {
        max = left > right ? left : right

        lefty = (left / max)

        righty = (right / max) 

        delta = right - left
    }
}
