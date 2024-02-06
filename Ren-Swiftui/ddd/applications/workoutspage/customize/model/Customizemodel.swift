//
//  Customizemodel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/29.
//

import Foundation
import SwiftUI

class CustomizeModel: ObservableObject {
    @Published var name: String = ""
    @Published var level: Programlevel?
    @Published var days: Int = 7

    @Published var present = false
    @Published var presentprogram = false
    
    @Published var createdprogram: Program?
    
    func reset() {
        
        createdprogram = nil
        name = ""
        level = nil
        days = 7
    }
    
    func backandpresent() {
        
        present = false
        presentprogram = true
        createdprogram = nil
        
        // objectWillChange.send()
    }

    func newaprogram() {
        if createdprogram != nil {
            return
        }

        DispatchQueue.main.async {
            var program = Program(
                programname: self.name,
                programlevel: self.level ?? .beginner,
                days: self.days
            )

            try! AppDatabase.shared.saveprogram(&program)
            self.createdprogram = program

            log("new a program")
        }
    }
}

let NORMAL_CUSTOMIZE_BUTTON_VSPACING: CGFloat = 30
let NORMAL_CUSTOMIZE_UP_VSPACING: CGFloat = 50
