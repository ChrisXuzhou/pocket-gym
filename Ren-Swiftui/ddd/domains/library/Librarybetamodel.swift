//
//  Librarybetamodel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/10/4.
//

import Foundation

let LIBRARY_FOCUED_MUSCLE: String = "libraryfocusedmuscle"
let LIBRARY_FOCUED_EQUIPMENT: String = "libraryfocusedequipment"

class Librarybetamodel: ObservableObject {
    /*
     * key text word
     */
    @Published var searchtext: String = "" {
        didSet {
            Libraryexercisemodel.shared.fetchandrefresh(self)
        }
    }

    /*
     * muscle filter
     * @Published var focusedmusclegroupid: String = COMPOUND
     */
    @Published var focusedid: String = ""

    /*
     * equipment filter
     * @Published var focusedequipment: String = EQUIPMENT
     */
    @Published var focusedequipment: String = ""

    init() {
        /*
         * filters
         */
        focusedid = COMPOUND
        
        if let _cache = AppDatabase.shared.queryappcache(LIBRARY_FOCUED_MUSCLE) {
            focusedid = _cache.cachevalue
        }
        
        if let _cache = AppDatabase.shared.queryappcache(LIBRARY_FOCUED_EQUIPMENT) {
            focusedequipment = _cache.cachevalue
        }
    }
    
    func focuse(_ mident: String) {
        focusedid = mident

        DispatchQueue.global().async {
            var cached = Appcache(
                cachekey: LIBRARY_FOCUED_MUSCLE,
                cachevalue: mident
            )

            try! AppDatabase.shared.saveappcache(&cached)
        }

        Libraryexercisemodel.shared.fetchandrefresh(self)
    }

    func focuse(_ m: Newdisplayedmusclewrapper) {
        focusedid = m.muscle.ident

        DispatchQueue.global().async {
            var cached = Appcache(
                cachekey: LIBRARY_FOCUED_MUSCLE,
                cachevalue: m.muscle.ident
            )

            try! AppDatabase.shared.saveappcache(&cached)
        }

        Libraryexercisemodel.shared.fetchandrefresh(self)
    }

    func isfocused(_ m: Newdisplayedmusclewrapper) -> Bool {
        if m.muscle.ident == focusedid {
            return true
        }

        if m.isgroup {
            for child in m.children {
                if child.muscle.ident == focusedid {
                    return true
                }
            }
        }

        return false
    }
    
    func focuseequipment(_ e: String) {
        focusedequipment = e

        DispatchQueue.global().async {
            var cached = Appcache(
                cachekey: LIBRARY_FOCUED_EQUIPMENT,
                cachevalue: e
            )

            try! AppDatabase.shared.saveappcache(&cached)
        }

        Libraryexercisemodel.shared.fetchandrefresh(self)
    }
}

extension Librarybetamodel {
    static var shared = Librarybetamodel()
}
