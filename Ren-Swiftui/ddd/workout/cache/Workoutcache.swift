//
//  Workoutcache.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/7/23.
//

import Foundation

class Workoutcache {
    var exerciseid: Int64?
    var reps: String?
    var weight: String?

    init() {
    }
}

extension Workoutcache {
    func setreps(_ batcheachlog: inout Batcheachlog) {
        if let _r: Int = ofreps {
            batcheachlog.repeats = _r
        }
    }

    func setweight(_ batcheachlog: inout Batcheachlog) {
        if let _w: Double = ofweight {
            batcheachlog.weight = _w
        }
    }
}

extension Workoutcache {
    var ofreps: Int? {
        if let _reps = reps {
            return Int(_reps)
        }
        return nil
    }

    var ofweight: Double? {
        if let _weight = weight {
            return Double(_weight)
        }
        return nil
    }
}

extension Workoutcache {
    public static var shared = Workoutcache()
}
