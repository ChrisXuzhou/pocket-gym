//
//  DataviewModel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/4/7.
//

import Foundation

struct Stack {
    fileprivate var array: [(Int, Int)] = []

    func isempty() -> Bool {
        array.isEmpty
    }

    mutating func push(_ element: (Int, Int)) {
        // 2
        array.append(element)
    }

    mutating func pop() -> (Int, Int)? {
        // 2
        return array.popLast()
    }
}

let REVIEW_DAYS_KEY: String = "reviewdayskey"

class Reviewdatamodel: ObservableObject {
    var days: Int {
        didSet {
            DispatchQueue.main.async {
                self.refreshanalysisedexercises()
            }
        }
    }

    var analysisedlist: [Analysisedexercise]
    var muscleid2analysisedlist: [String: [Analysisedexercise]]

    init() {
        days = 7
        if let _cache = AppDatabase.shared.queryappcache(REVIEW_DAYS_KEY) {
            days = Int(_cache.cachevalue) ?? 7
        }

        analysisedlist = []
        muscleid2analysisedlist = [:]

        refreshanalysisedexercises()
    }

    func refreshanalysisedexercises() {
        if days < 1 {
            return
        }

        let end = Date()
        let start = Calendar.current.date(byAdding: .day, value: -days, to: end) ?? end
        let interval = DateInterval(start: start, end: end)

        analysisedlist = AppDatabase.shared.queryanalysisedlist(interval)
        muscleid2analysisedlist = Dictionary(grouping: analysisedlist, by: { $0.displayedgroupid ?? "notfound" })

        objectWillChange.send()
    }

    /*
     * variables
     */
    let lock = NSLock()
}

extension Reviewdatamodel {
    func adddays() {
        lock.lock()
        defer {
            lock.unlock()
        }

        days += 1

        objectWillChange.send()

        let _d = days
        DispatchQueue.global().async {
            var appcache = Appcache(cachekey: REVIEW_DAYS_KEY, cachevalue: "\(_d)")
            try! AppDatabase.shared.saveappcache(&appcache)
        }
    }

    func minusdays() {
        lock.lock()
        defer {
            lock.unlock()
        }

        if days >= 2 {
            days -= 1
            objectWillChange.send()

            let _d = days
            DispatchQueue.global().async {
                var appcache = Appcache(cachekey: REVIEW_DAYS_KEY, cachevalue: "\(_d)")
                try! AppDatabase.shared.saveappcache(&appcache)
            }
        }
    }
}
