//
//  ExercisedatalabellistModel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/4/12.
//

import Foundation

class ExercisedatalabellistModel: ObservableObject {
    @Published var focused: Exercisedatatype = .volume

    func isfocused(_ type: Exercisedatatype) -> Bool {
        focused == type
    }

    var volumerange: Maxandmin
    var onermrange: Maxandmin
    var maxweightrange: Maxandmin
    var setsrange: Maxandmin

    func percent(_ value: Double, type: Exercisedatatype) -> Double {
        let range = ofrange(type)
        return range.ofpercent(value)
    }

    func ofrange(_ type: Exercisedatatype) -> Maxandmin {
        switch type {
        case .onerm:
            return onermrange
        case .max:
            return maxweightrange
        case .volume:
            return volumerange
        case .sets:
            return setsrange
        }
    }

    init(_ analysisedlist: [Analysisedexercise]) {
        volumerange = Maxandmin(max: 0, min: 99999)
        onermrange = Maxandmin(max: 0, min: 99999)
        maxweightrange = Maxandmin(max: 0, min: 99999)
        setsrange = Maxandmin(max: 0, min: 99999)

        analysisedlist.forEach { analysised in
            if analysised.volume < volumerange.min {
                volumerange.min = analysised.volume
            }
            if analysised.volume > volumerange.max {
                volumerange.max = analysised.volume
            }

            if analysised.onerm < onermrange.min {
                onermrange.min = analysised.onerm
            }
            if analysised.onerm > onermrange.max {
                onermrange.max = analysised.onerm
            }

            if analysised.maxweight < maxweightrange.min {
                maxweightrange.min = analysised.maxweight
            }
            if analysised.maxweight > maxweightrange.max {
                maxweightrange.max = analysised.maxweight
            }

            if Double(analysised.sets) < setsrange.min {
                setsrange.min = Double(analysised.sets)
            }
            if Double(analysised.sets) > setsrange.max {
                setsrange.max = Double(analysised.sets)
            }
        }
    }
}

struct Maxandmin {
    var max: Double
    var min: Double

    func ofpercent(_ value: Double) -> Double {
        let delta = (max - min)

        if delta == 0 {
            return 1
        }

        return 0.7 + 0.3 * (value - min) / delta
    }
}
