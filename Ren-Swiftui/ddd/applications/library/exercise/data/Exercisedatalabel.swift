//
//  Exercisedatalabel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/4/9.
//

import SwiftUI

struct Exercisedatalabel: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var model: ExercisedatalabellistModel

    let analysised: Analysisedexercise
    let exercise: Newdisplayedexercise?

    var showexerciselabel: Bool

    init(analysised: Analysisedexercise, showexerciselabel: Bool = true) {
        self.analysised = analysised
        self.showexerciselabel = showexerciselabel
        exercise = analysised.exercise
    }

    var exercisedataview: some View {
        HStack(alignment: .top) {
            if showexerciselabel {
                if let _exercise = analysised.exercise {
                    Exerciselabelvideo(exercise: _exercise)
                }
            } else {
                Text(analysised.workday.displayedonlytime)
                    .foregroundColor(NORMAL_GRAY_COLOR)
                    .font(.system(size: DEFINE_FONT_SMALL_SIZE - 2).bold())
                    .padding(.trailing)
                    .frame(height: 45)
            }

            HStack(spacing: 0) {
                Exercisedatalabeldata(
                    description: "volume",
                    value: preference.displayweight(analysised.volume),
                    focused: model.isfocused(.volume),
                    percent: model.percent(analysised.volume, type: .volume)
                )
                .onTapGesture {
                    model.focused = .volume
                }

                Exercisedatalabeldata(
                    description: "1rm",
                    value: preference.displayweight(analysised.onerm),
                    focused: model.isfocused(.onerm),
                    percent: model.percent(analysised.onerm, type: .onerm)
                )
                .onTapGesture {
                    model.focused = .onerm
                }

                Exercisedatalabeldata(
                    description: "maxweight",
                    value: preference.displayweight(analysised.maxweight),
                    focused: model.isfocused(.max),
                    percent: model.percent(analysised.maxweight, type: .max)
                )
                .onTapGesture {
                    model.focused = .max
                }

                SPACE
            }

            SPACE
        }
    }

    var body: some View {
        VStack(alignment: .leading) {
            exercisedataview
        }
    }
}

struct Exercisedatalabeldata: View {
    
    var description: String
    var value: String

    var focused: Bool
    var percent: Double

    var color: Color = NORMAL_GREEN_COLOR

    var body: some View {
        ZStack {
            GeometryReader {
                reader in
                if focused {
                    let fullwidth = reader.size.width
                    let width: CGFloat = fullwidth * percent

                    HStack {
                        Rectangle()
                            .foregroundColor(.white)
                            .frame(width: width)
                            .overlay(
                                LinearGradient(gradient:
                                    Gradient(colors: [color.opacity(0.8), color]),
                                    startPoint: .leading, endPoint: .trailing)
                            )

                        SPACE
                    }
                }

                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        LocaleText(description)
                            .font(.system(size: DEFINE_FONT_SMALL_SIZE - 4).bold())
                            .padding(.leading, 1)
                        
                        Text(value)
                            .lineLimit(1)
                            .minimumScaleFactor(0.01)

                    }
                    .font(.system(size: DEFINE_FONT_SMALL_SIZE - 2).bold())
                    .foregroundColor(
                        focused ? NORMAL_LIGHTER_COLOR : NORMAL_GRAY_COLOR
                    )

                    if focused {
                        SPACE
                    }
                }
                .frame(height: 48)
                .padding(.horizontal, 5)
            }
        }
        .frame(width: 60, height: 48)
    }
}
