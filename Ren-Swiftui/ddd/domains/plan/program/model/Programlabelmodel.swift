//
//  Programlabelmodel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/4/25.
//

import Foundation

class Programlabelmodel: ObservableObject {
    var program: Program?
    var programeachlist: [Programeach] = []
    
    init(_ program: Program?) {
        if let _program = program {
            self.program = _program
            self.programeachlist = AppDatabase.shared.queryprogrameachlist(_program.id!)
        }
    }

    func refresh() {
        
        if program == nil {
            return
        }
        
        let programid: Int64 = program!.id!
        
        self.program = AppDatabase.shared.queryprogram(id: programid)
        self.programeachlist = AppDatabase.shared.queryprogrameachlist(programid)
        
        self.objectWillChange.send()
    }
}
