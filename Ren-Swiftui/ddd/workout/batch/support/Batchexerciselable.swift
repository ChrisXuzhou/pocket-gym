//
//  Batchexerciselable.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/9.
//

import SwiftUI

let BATCH_EXERCISE_LABEL_HEIGHT: CGFloat = 60 + 6
let BATCH_EXERCISE_LABEL_TITLE_WIDTH: CGFloat = 120

struct Batchexerciselable: View {
    @EnvironmentObject var trainingpreference: TrainingpreferenceDefinition
    @EnvironmentObject var batchfocused: Logfocused

    @EnvironmentObject var batchmodel: Batchmodel

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                ForEach(batchmodel.orderedbatchexercisedefs, id: \.batchexercisedef.id) {
                    batchexercisedef in

                    displayeachexercise(batchexercisedef)
                }
            }

            progresslabel
        }
        .frame(height: BATCH_EXERCISE_LABEL_HEIGHT * CGFloat(batchmodel.orderedbatchexercisedefs.count))
    }
}

let NORMAL_VIDEO_WIDTH: CGFloat = 120
let NORMAL_VIDEO_HEIGHT: CGFloat = 60

extension Batchexerciselable {
    var progresslabel: some View {
        HStack {
            SPACE

            let _p = batchmodel.progress
            Process(first: _p.0, second: _p.1)
        }
    }

    func displayeachexercise(_ batchexercisedef: Batchexercisedefwrapper) -> some View {
        HStack(spacing: 0) {
            if let exercise = batchexercisedef.batchexercisedef.ofexercisedef {
                Exerciselabelvideo(
                    exercise: exercise,
                    showlink: true,
                    showexercisedetailink: true,
                    lablewidth: NORMAL_VIDEO_WIDTH,
                    lableheight: NORMAL_VIDEO_HEIGHT
                )
                .id(batchexercisedef.batchexercisedef.id!)

                LocaleText(exercise.realname)
                    .frame(alignment: .leading)
                    .foregroundColor(NORMAL_LIGHTER_COLOR)
                    .padding(.leading, 10)
                    .font(
                        .system(size: DEFINE_FONT_SMALLER_SIZE, design: .rounded)
                            .bold()
                    )
            }

            SPACE

            SPACE.frame(width: PROCESS_WIDTH)
        }
        .frame(height: BATCH_EXERCISE_LABEL_HEIGHT)
    }
}
