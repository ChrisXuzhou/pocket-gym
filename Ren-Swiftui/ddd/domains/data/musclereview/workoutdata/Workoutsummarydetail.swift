//
//  Workoutsummarydetail.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/5/7.
//

import SwiftUI

struct Workoutsummarydetail_Previews: PreviewProvider {
    static var previews: some View {
        let mockedbatch = mockbatch()

        let analysisedexercises = [
            Analysisedexercise(id: 1,
                               exerciseid: 19009,
                               workoutid: -1,
                               batchid: -1,
                               workday: Date(),
                               volume: 2300, onerm: 100,
                               sets: 3,
                               minrepeats: 10,
                               minweight: 50, maxweight: 90),
            Analysisedexercise(id: 2,
                               exerciseid: 19009,
                               workoutid: -1,
                               batchid: -2,
                               workday: Date(),
                               volume: 2800, onerm: 100,
                               sets: 3,
                               minrepeats: 10,
                               minweight: 50, maxweight: 90),
            Analysisedexercise(id: 3,
                               exerciseid: 19009,
                               workoutid: -1,
                               batchid: -2,
                               workday: Date(),
                               volume: 2600, onerm: 100,
                               sets: 3,
                               minrepeats: 10,
                               minweight: 50, maxweight: 90),
            Analysisedexercise(id: 4,
                               exerciseid: 19009,
                               workoutid: -1,
                               batchid: -4,
                               workday: Date(),
                               volume: 2900, onerm: 100,
                               sets: 3,
                               minrepeats: 10,
                               minweight: 50, maxweight: 90),
        ]

        let model = Workoutsummarymodel(
            analysisedexercises
        )

        DisplayedView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    SPACE.frame(height: 200)

                    Workoutsummarydetail()
                }
                .environmentObject(model)
            }
        }
    }
}

struct Workoutsummarydatalabel: View {
    @EnvironmentObject var preference: PreferenceDefinition

    var type: Exercisedatatype
    var analysised: Analysisedexercise

    var value: String {
        let _a: Analysisedexercise = analysised
        var _y: Double = 0.0

        if type == .sets {
            _y = Double(_a.sets)
            return "\(Int(_y))"
        } else if type == .volume {
            _y = Weight(value: _a.volume, weightunit: .kg).transformedto(weightunit: preference.ofweightunit)
        } else if type == .max {
            _y = Weight(value: _a.maxweight, weightunit: .kg).transformedto(weightunit: preference.ofweightunit)
        } else if type == .onerm {
            _y = Weight(value: _a.onerm, weightunit: .kg).transformedto(weightunit: preference.ofweightunit)
        }

        return "\(String(format: "%.1f", _y)) \(preference.ofweightunit)"
    }

    var indicatorview: some View {
        VStack(spacing: 5) {
            LocaleText(type.name, uppercase: true)
                .font(.system(size: DEFINE_FONT_SMALL_SIZE - 2).bold())
                .foregroundColor(NORMAL_GRAY_COLOR)

            LocaleText(value)
                .font(.system(size: DEFINE_FONT_SMALL_SIZE - 2).bold())
                .foregroundColor(NORMAL_LIGHTER_COLOR)
                .padding(.horizontal, 3)
        }
    }

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(preference.themesecondarycolor.opacity(0.5))

            indicatorview
        }
        .frame(width: 80, alignment: .center)
    }
}

struct Workoutsummarydetail: View {
    @EnvironmentObject var model: Workoutsummarymodel
    var showexerciseinfo: Bool = true

    func ofbatch(_ batchid: Int64) -> Batch? {
        AppDatabase.shared.querybatch(id: batchid)
    }

    var body: some View {
        LazyVStack {
            let reversedanalysisedlist: [Analysisedexercise] = Array(model.analysisedlist.reversed())

            let count = reversedanalysisedlist.count

            ForEach(0 ..< count, id: \.self) {
                idx in

                let analysised = reversedanalysisedlist[idx]
                let batchid = analysised.batchid

                if let _batch = ofbatch(batchid) {
                    ZStack {
                        Exerciseresulteachbatchlabel(batch: _batch,
                                                     showexerciseinfo: showexerciseinfo)
                            .padding(.vertical)

                        HStack {
                            SPACE
                            VStack {
                                Workoutsummarydatalabel(type: model.type, analysised: analysised)
                                SPACE
                            }
                        }
                    }
                    .background(
                        NORMAL_BG_CARD_COLOR
                    )
                }
            }
        }
    }
}
