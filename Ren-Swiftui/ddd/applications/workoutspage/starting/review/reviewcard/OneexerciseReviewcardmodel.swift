//
//  OneexerciseReviewcardmodel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/6/12.
//

import Foundation

let VALUE_TYPES: [Exercisedatatype] = [.onerm, .volume]

class OneexerciseReviewcardmodel: ObservableObject {
    /*
     * to display
     */
    var before: Analysisedexercise?
    var tocompare: Analysisedexercise?

    var exercise: Newdisplayedexercise?

    /*
     * range
     */
    var exerciseids: [Int64]
    @Published var focusedid: Int64

    init(_ exerciseids: Set<Int64>) {
        self.exerciseids = Array(exerciseids)
        focusedid = exerciseids.randomElement() ?? exerciseids.first!

        type = .onerm

        reinitialize(focusedid)
    }

    func reinitialize(_ exerciseid: Int64) {
        exercise = exerciseid.ofexercisedef

        let lastpair = AppDatabase.shared.querylast20analysisedexercise(exerciseid: exerciseid, limit: 2)

        if let _first = lastpair.first {
            tocompare = _first
        }

        if lastpair.count > 1 {
            if let _last = lastpair.last {
                before = _last
            }
        }

        generategraphvalues()

        objectWillChange.send()
    }

    var type: Exercisedatatype

    /*
     * function variables
     */
    var title: String = ""
    var description: String = ""
    var left: Double = 0.0
    var leftdate: Date = Date()
    var right: Double = 0.0
    var rightdate: Date = Date()
}

extension OneexerciseReviewcardmodel {
    func refresh() {
        if exerciseids.isEmpty {
            return
        }

        if let _idx = exerciseids.firstIndex(of: focusedid) {
            let _next = _idx < exerciseids.count - 1 ? _idx + 1 : 0
            focusedid = exerciseids[_next]
        }
        
        //type = VALUE_TYPES.randomElement() ?? .onerm
        
        reinitialize(focusedid)
    }
}

extension OneexerciseReviewcardmodel {
    var ofunit: Weightunit? {
        type == .sets ? nil : PreferenceDefinition.shared.ofweightunit
    }

    var isinit: Bool {
        type == .sets
    }

    func generategraphvalues() {
        guard let _tocompare = tocompare else {
            return
        }

        if let _exercise = _tocompare.exercise {
            title = _exercise.realname
        }

        // rightdate = _tocompare.createtime
        rightdate = _tocompare.workday

        let _ramdom: Exercisedatatype = type
        description = _ramdom.name

        var _right: Double = 0.0

        switch _ramdom {
        case .max:
            _right = _tocompare.maxweight
        case .onerm:
            _right = _tocompare.onerm
        case .volume:
            _right = _tocompare.volume
        case .sets:
            right = Double(_tocompare.sets)
        }

        if _ramdom != .sets {
            right = Weight(value: _right, weightunit: .kg).transformedto(weightunit: PreferenceDefinition.shared.ofweightunit)
        }

        if let _last = before {
            leftdate = _last.workday

            var _left: Double = 0.0

            switch _ramdom {
            case .max:
                _left = _last.maxweight
            case .onerm:
                _left = _last.onerm
            case .volume:
                _left = _last.volume
            case .sets:
                left = Double(_last.sets)
            }

            if _ramdom != .sets {
                left = Weight(value: _left, weightunit: .kg).transformedto(weightunit: PreferenceDefinition.shared.ofweightunit)
            }
        }
    }
}

extension Int64 {
    var ofexercisedef: Newdisplayedexercise? {
        if let _d = AppDatabase.shared.queryNewexercisedef(exerciseid: self) {
            return Newdisplayedexercise(_d)
        }
        return nil
    }
}
