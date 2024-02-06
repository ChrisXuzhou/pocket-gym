//
//  Muscleradarsummaryview.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/5/9.
//


import SwiftUI

struct Muscleradarsummaryview_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Muscleradarsummaryview()
                .environmentObject(Muscleradardetailmodel("chest", days: 7, workouttimes: 10))
        }
    }
}

let DEFAULT_SUMMARY_TITLE_HEIGHT: CGFloat = 40
let DEFAULT_SUMMARY_VALUE_HEIGHT: CGFloat = 60

struct Muscleradarsummaryview: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var model: Muscleradardetailmodel

    /*
     * variables
     */
    @StateObject var moreexerciseswitch = Viewopenswitch()

    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    SPACE.frame(height: 30)

                    indicatorslabel

                    exercisegroupedlabel

                    SPACE.frame(height: UIScreen.height / 3)
                }
                .padding(.horizontal)
                .padding(.top, 5)
            }

            linkmore
        }
    }
}

extension Muscleradarsummaryview {
    var indicatorslabel: some View {
        HStack {
            SPACE

            MuscleradarsummaryviewIndicator(
                description: "workoutdata",
                value: "\(model.workouttimes)"
            )

            SPACE

            MuscleradarsummaryviewIndicator(
                description: "exercisedata",
                value: "\(model.exerciseids.count)"
            )

            SPACE
        }
        .frame(height: 180)
        .background(NORMAL_BG_CARD_COLOR)
        .clipShape(
            RoundedRectangle(cornerRadius: 12)
        )
        .shadow(color: NORMAL_CARD_SHADDOW_COLOR, radius: 10, y: 8)
    }

    var exercisegroupedlabel: some View {
        Muscleradarsummaryexercises()
    }

    var linkmore: some View {
        VStack {
            SPACE

            HStack {
                SPACE

                Button(action: {
                    moreexerciseswitch.value.toggle()
                }, label: {
                    Text("\(preference.languagewithplaceholder("moreexercisefortarget", value: preference.language(model.muscleid)))")
                        .font(.system(size: DEFINE_FONT_SMALL_SIZE))
                        .foregroundColor(preference.theme)
                })
                .fullScreenCover(isPresented: $moreexerciseswitch.value) {
                    NavigationView {
                        Muscleevaluationview(model.muscleid, present: $moreexerciseswitch.value)
                            .navigationBarHidden(true)
                            .navigationBarBackButtonHidden(true)
                    }
                }

                SPACE
            }
            .frame(height: MIN_DOWN_TAB_HEIGHT)
            .background(NORMAL_BG_COLOR.ignoresSafeArea())
        }
    }
}

struct MuscleradarsummaryviewIndicator: View {
    var description: String
    var value: String

    var body: some View {
        VStack(spacing: 5) {
            SPACE

            LocaleText(value)
                .font(.system(size: DEFINE_FONT_BIGGEST_SIZE + 2).bold())

            LocaleText(description)
                .font(.system(size: DEFINE_FONT_SMALLER_SIZE - 2).bold())
                .foregroundColor(NORMAL_LIGHTER_COLOR.opacity(0.6))

            SPACE
        }
        .foregroundColor(NORMAL_LIGHTER_COLOR)
        .frame(width: UIScreen.width / 3)
    }
}
