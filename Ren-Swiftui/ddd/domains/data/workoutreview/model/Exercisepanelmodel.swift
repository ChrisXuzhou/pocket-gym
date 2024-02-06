//
//  Exercisepanelmodel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/9/19.
//

import Foundation
import SwiftUI

class Exercisepanelmodel: ObservableObject {
    var exercise: Newdisplayedexercise
    var videoview: AnyView

    init(_ exercise: Newdisplayedexercise) {
        self.exercise = exercise
        
        videoview = AnyView(
            VideoView(v: exercise.exercise.imgname, rate: 1.5)
        )
        
    }
}
