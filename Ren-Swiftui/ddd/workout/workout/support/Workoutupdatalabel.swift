//
//  Workoutupdatalabel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/5/6.
//

import GRDB
import SwiftUI

class Workoutupdatalabelmodel: ObservableObject {
    var workoutid: Int64

    /*
     * values to display
     */
    var volumekg: Double = 0.0
    var sets: Int = 0

    /*
     * temp values
     */
    var batcheachlogs: [Batcheachlog] = []
    var batcheachlogsobservable: DatabaseCancellable?

    init(_ workoutid: Int64) {
        self.workoutid = workoutid
        observebatcheachlogs()
    }

    private func refresh() {
        volumekg = 0.0
        sets = 0

        if batcheachlogs.isEmpty {
            return
        }

        for batcheachlog in batcheachlogs {
            if batcheachlog.isfinished {
                /*
                 * sets
                 */
                sets += 1

                /*
                 * volumekg add
                 */
                let exerciseid = batcheachlog.exerciseid
                if let _exercise = Exerciselibrary.ofexercise(exerciseid) {
                    let weight = _exercise.caculatevolume(batcheachlog)
                    volumekg += weight.askgweight
                }
            }
        }

        objectWillChange.send()
    }

    private func observebatcheachlogs() {
        batcheachlogsobservable = AppDatabase.shared.observebatcheachloglist(
            workoutid: workoutid,
            onError: { error in fatalError("Unexpected error: \(error)") },
            onChange: { [weak self] batcheachlogs in

                guard let self = self else { return }

                self.batcheachlogs = batcheachlogs
                self.refresh()

            })
    }

    func ofvolume(_ weightunit: Weightunit, showunit: Bool = true) -> String {
        let value = Weight(value: volumekg, weightunit: .kg).transformedto(weightunit: weightunit)
        return showunit ?
            "\(String(format: "%.1f", value)) \(weightunit.name)" :
            "\(String(format: "%.1f", value))"
    }
}

struct Workoutupdatalabel: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var trainingpreference: TrainingpreferenceDefinition

    @EnvironmentObject var trainingtimer: Trainingtimer

    @StateObject var model: Workoutupdatalabelmodel

    init(workoutid: Int64) {
        _model = StateObject(wrappedValue: Workoutupdatalabelmodel(workoutid))
    }

    let VALUE_SPACING: CGFloat = 12
    let headercolor: Color = NORMAL_LIGHTER_COLOR.opacity(0.5)
    let headerfont: CGFloat = DEFINE_FONT_SMALLER_SIZE - 1

    var body: some View {
        VStack {
            GeometryReader {
                reader in

                let width = reader.size.width / 7
                HStack(spacing: 0) {
                    Incidatorpanel(description: "duration") {
                        Trainingtimerlabel(
                            trainingtimer: trainingtimer,
                            fontsize: DEFINE_FONT_SIZE
                        )
                    }
                    .frame(width: width * 3)

                    Incidatorpanel(description: "\(preference.language("volume")) \(trainingpreference.weightunit.name)") {
                        Text(model.ofvolume(trainingpreference.weightunit, showunit: false))
                            .font(.system(size: DEFINE_FONT_SMALL_SIZE).weight(.heavy))
                            .foregroundColor(NORMAL_LIGHTER_COLOR)
                    }
                    .frame(width: width * 3)

                    Incidatorpanel(description: "sets") {
                        Text("\(model.sets)")
                            .font(.system(size: DEFINE_FONT_SMALL_SIZE).weight(.heavy))
                            .foregroundColor(NORMAL_LIGHTER_COLOR)
                    }
                    .frame(width: width)
                }
            }
        }
        .frame(height: WORKOUT_DATA_HEIGHT)
    }
}

let WORKOUT_DATA_HEIGHT: CGFloat = 75
let WORKOUT_DATA_SPACE: CGFloat = 12

struct Incidatorpanel<Content>: View where Content: View {
    var headercolor: Color
    var headerfont: CGFloat
    var description: String

    let content: () -> Content

    init(headercolor: Color = NORMAL_LIGHTER_COLOR.opacity(0.5),
         headerfont: CGFloat = DEFINE_FONT_SMALLER_SIZE - 1,
         description: String,
         @ViewBuilder content: @escaping () -> Content) {
        /*
         * header
         */
        self.headercolor = headercolor
        self.headerfont = headerfont
        self.description = description

        self.content = content
    }

    var body: some View {
        VStack(alignment: .leading, spacing: WORKOUT_DATA_SPACE) {
            HStack {
                LocaleText(description)
                    .font(.system(size: headerfont).bold())
                    .foregroundColor(
                        headercolor
                    )
                SPACE
            }

            self.content()
                .frame(height: 17)
                .padding(.leading, 1)
        }
        .padding(.vertical)
    }
}
