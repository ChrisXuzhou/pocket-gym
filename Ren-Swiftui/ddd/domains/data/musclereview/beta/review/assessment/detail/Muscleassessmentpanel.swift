//
//  Musclevaluepanel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/10/22.
//

import SwiftUI

struct Musclevaluepanel_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            VStack {
                Musclevaluepanel(muscleassess: mockmuscleassessment())
            }
            .padding(.horizontal, 10)
        }
    }
}

func mockmuscleassessment() -> Musclevalue {
    Musclevalue(muscleid: "serratus_anterior_pectoralis_minor", days: 3, rangedays: 10)
}

let MUSCLE_ASSESS_PANEL_HEIGHT: CGFloat = 50
let MUSCLE_ASSESS_PANEL_TEXT_WIDTH: CGFloat = 120

struct Musclevaluepanel: View {
    var muscleassess: Musclevalue

    var font: CGFloat = DEFINE_FONT_SMALL_SIZE
    var color: Color = NORMAL_THEME_COLOR

    var body: some View {
        HStack(spacing: 5) {
            HStack(spacing: 0) {
                LocaleText(muscleassess.muscleid, linelimit: 3, alignment: .leading)
                    .foregroundColor(NORMAL_LIGHTER_COLOR)
                    .font(.system(size: font))

                SPACE
            }
            .frame(width: MUSCLE_ASSESS_PANEL_TEXT_WIDTH)

            SPACE
            // percentbar
        }
        .frame(height: MUSCLE_ASSESS_PANEL_HEIGHT)
    }
}

/*
 
 extension Musclevaluepanel {
     var percentbar: some View {
         GeometryReader {
             reader in

             HStack {
                 Databackgroundshape(
                     color: color
                 )
                 .frame(width: (reader.size.width - 80) * (muscleassess.percent / 100))

                 Text("\(muscleassess.times),  \(String(format: "%.0f", muscleassess.percent))%")
                     .foregroundColor(NORMAL_LIGHTER_COLOR)
                     .font(.system(size: DEFINE_FONT_SMALL_SIZE).bold())

                 SPACE
             }
             .frame(height: reader.size.height - 1)
         }
     }
 }

 */
