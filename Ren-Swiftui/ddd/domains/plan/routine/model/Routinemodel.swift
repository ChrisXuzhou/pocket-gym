//
//  Routineviewmodel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/5/8.
//

import Foundation

enum Routinestate {
    case template, workout

    var routineusage: Routineusage {
        switch self {
        case .template:
            return Routineusage.usetemplate
        case .workout:
            return Routineusage.onlyview
        }
    }
    
    /*
     case .result:
        return Routineusage.onlyview
     */
}

enum Vieweditable: String, Codable {
    case onlyview, editable
}

class Routineviewmodel: ObservableObject {
    
    let state: Routinestate
    // let plantask: Plantask?
    /*
     * only when state is .template
     */
    let templateusage: Routineusage?

    // , plantask: Plantask? = nil
    init(state: Routinestate, templateusage: Routineusage? = nil, editing: Bool = true) {
        self.state = state
        self.templateusage = templateusage

        vieweditatble = editing ? Vieweditable.editable : Vieweditable.onlyview
    }

    // @Deprated
    @Published var vieweditatble = Vieweditable.onlyview

    func switcheditable() {
        if vieweditatble == .onlyview {
            vieweditatble = .editable
        } else {
            vieweditatble = .onlyview
        }
    }

    var isvieweditable: Bool {
        vieweditatble == .editable
    }
}
