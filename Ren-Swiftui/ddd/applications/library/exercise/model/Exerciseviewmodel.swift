//
//  Exerciseviewmodel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/4/20.
//

import Foundation
import GRDB
import SwiftUI

class Exerciseviewmodel: ObservableObject {

    var video: AnyView
    
    init(_ exercise: Newdisplayedexercise) {
        self.video = AnyView(
            VideoView(v: exercise.exercise.imgname, rate: 1.5)
        )
    }
}
