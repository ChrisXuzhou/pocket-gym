//
//  Muscleradarmodeldetail.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/10/23.
//

import SwiftUI

struct Muscleradarmodeldetail_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            ScrollView {
                Muscleradarmodeldetail(muscleassess: mockmuscleassess())
                    .padding(.top, 300)
                    .padding(.horizontal, 10)
            }
        }
    }
}

func mockmuscleassess() -> Muscleradarmodel {
    Muscleradarmodel(
        groupid: "chest",
        score: 60,
        assesslist: [mockmuscleassessment()]
    )
}

struct Muscleradarmodeldetail: View {
    @EnvironmentObject var preference: PreferenceDefinition

    var muscleassess: Muscleradarmodel

    /*
     * variables
     */
    var scorefont: CGFloat = 45
    var scoresubfont: CGFloat = DEFINE_FONT_SMALL_SIZE
    var scoredescfont: CGFloat = DEFINE_FONT_SMALLER_SIZE

    var body: some View {
        VStack {
            scorepanel

            muscleasesslist

            SPACE.frame(height: 60)
        }
        .padding(.horizontal, 10)
        .background(
            NORMAL_BG_CARD_COLOR
        )
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(color: NORMAL_CARD_SHADDOW_COLOR, radius: 20)
    }
}

extension Muscleradarmodeldetail {
    var scorepanel: some View {
        ZStack {
            VStack(spacing: 15) {
                
                LocaleText("workoutscore", usefirstuppercase: false, alignment: .center)
                    .font(.system(size: scoredescfont))
                    .foregroundColor(NORMAL_LIGHTER_COLOR)
                    .frame(width: 320)
                
                ZStack {
                    Text("\(String(format: "%.0f", muscleassess.score))")
                        .font(.system(size: scorefont).weight(.heavy))
                        .foregroundColor(preference.theme)
                }
                .frame(height: 80)
            }
            .frame(height: 160)
            .padding(.top)
        }
    }
}

extension Muscleradarmodeldetail {
    var muscleassessheader: some View {
        HStack(spacing: 5) {
            HStack(spacing: 0) {
                LocaleText("musclename")
                
                // LocaleText(preference.ofcolon)

                SPACE
            }
            .frame(width: MUSCLE_ASSESS_PANEL_TEXT_WIDTH)

            LocaleText("setsandpercent")

            SPACE
        }
        .foregroundColor(NORMAL_LIGHT_TEXT_COLOR)
        .font(.system(size: DEFINE_FONT_SMALLER_SIZE))
    }

    var muscleasesslist: some View {
        VStack {
            muscleassessheader

            LOCAL_DIVIDER

            ForEach(muscleassess.values, id: \.muscleid) {
                assess in

                Musclevaluepanel(muscleassess: assess)
            }
        }
        .padding(.vertical)
    }
}
