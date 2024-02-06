//
//  Exercisetrainedtimespanel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/4/10.
//

import SwiftUI

struct Exercisetrainedtimespanel: View {
    let exercise: Newdisplayedexercise

    var percent: Double
    var display: String

    var color: Color = NORMAL_THEME_COLOR

    var description: some View {
        GeometryReader {
            reader in

            HStack {
                Databackgroundshape(
                    color: color
                )
                .frame(width: (reader.size.width - 80) * percent)

                LocaleText(display)
                    .foregroundColor(NORMAL_LIGHTER_COLOR)
                    .font(.system(size: DEFINE_FONT_SMALL_SIZE).bold())

                SPACE
            }
            .frame(height: 59)
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            LocaleText(exercise.realname)
                .foregroundColor(NORMAL_LIGHT_TEXT_COLOR)
                .font(.system(size: DEFINE_FONT_SMALLER_SIZE - 1))

            HStack(alignment: .center, spacing: 10) {
                Exerciselabelvideo(
                    exercise: exercise,
                    showlink: true,
                    showexercisedetailink: true,
                    lablewidth: 120,
                    lableheight: 60
                )
                
                description
            }
        }
    }
}
