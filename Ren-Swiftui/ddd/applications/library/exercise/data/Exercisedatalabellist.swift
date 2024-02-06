//
//  Exercisedatalabellist.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/4/12.
//

import SwiftUI

struct Exercisedatalabellist_Previews: PreviewProvider {
    static var previews: some View {
        let analysisedexercises = [
            Analysisedexercise(exerciseid: 19009,
                               workoutid: -1,
                               batchid: -1,
                               workday: Date(),
                               volume: 2000, onerm: 100,
                               sets: 3,
                               minrepeats: 10,
                               minweight: 50, maxweight: 90),
        ]
        
        DisplayedView {
            Exercisedatalabellist(analysisedexercises)
        }
    }
}

struct Exercisedatalabellist: View {
    var analysisedlist: [Analysisedexercise]

    var workdaylist: [String]
    var workday2analysisedlist: [String: [Analysisedexercise]]

    var model: ExercisedatalabellistModel
    var showexerciselabel: Bool

    init(_ analysisedlist: [Analysisedexercise], showexerciselabel: Bool = true) {
        self.analysisedlist = analysisedlist
        self.showexerciselabel = showexerciselabel

        workday2analysisedlist =
            Dictionary(grouping: analysisedlist, by: { $0.workday.systemedyearmonthdate })

        workdaylist = Array(workday2analysisedlist.keys).sorted { l, r in
            l > r
        }
        model = ExercisedatalabellistModel(analysisedlist)
    }

    func workdayanalysisedlist(_ workday: String) -> [Analysisedexercise] {
        var analysisedlist: [Analysisedexercise] = workday2analysisedlist[workday] ?? []
        analysisedlist = analysisedlist.sorted(by: { l, r in
            l.workday > r.workday
        })

        return analysisedlist
    }

    var workdayexercisesview: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(workdaylist, id: \.self) {
                workday in

                bartitle(workday)


                let analysisedlist = workdayanalysisedlist(workday)
                ForEach(analysisedlist, id: \.id) {
                    analysised in

                    Exercisedatalabel(analysised: analysised, showexerciselabel: showexerciselabel)
                        .padding(.vertical)
                }
            }
        }
    }

    var body: some View {
        VStack {
            workdayexercisesview

            SPACE
        }
        .padding()
        .padding(.leading)
        .environmentObject(model)
    }
}
