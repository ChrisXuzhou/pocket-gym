//
//  MuscleLink.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/2/22.
//

import SwiftUI

struct Musclelink_Previews: PreviewProvider {
    static var previews: some View {
        let muscle = Muscle.shared.definedlist[3]

        DisplayedView {
            VStack {
                Musclelink(muscle: muscle, highlight: true)

                Musclelink(muscle: muscle)
            }
        }
    }
}

extension PersonalDefinition {
    func muscleimg(_ id: String) -> String {
        switch ofgender {
        case .male:
            return "male_" + id
        case .female:
            return "female_" + id
        case .other:
            return "female_" + id
        }
    }
}

let MUSCLE_TEXT_WIDTH: CGFloat = 62
let MUSCLE_IMG_SIZE: CGFloat = 50
let MUSCLE_TEXT_FONT_SIZE: CGFloat = DEFINE_FONT_SMALL_SIZE - 6

struct Musclelink: View {
    @StateObject var personal = PersonalDefinition()
    @EnvironmentObject var preference: PreferenceDefinition

    var muscle: Muscledef

    var displaysize: CGFloat = MUSCLE_IMG_SIZE

    var highlight = false
    var showtext = true

    var body: some View {
        VStack(spacing: 0) {
            let img = Image(personal.muscleimg(muscle.id))

            Circleimage(image: img)
                .padding(2)
                .overlay(
                    VStack {
                        if highlight {
                            Circle()
                                .stroke(
                                    preference.theme,
                                    lineWidth: 2
                                )
                        }
                    }
                )
                .frame(width: displaysize, height: displaysize)
                .padding(.horizontal, 4)
                .padding(.vertical, 4)

            if showtext {
                Text(preference.language(muscle.id))
                    .foregroundColor(highlight ? preference.theme : NORMAL_LIGHTER_COLOR)
                    .lineLimit(1)
                    .minimumScaleFactor(0.01)
                    .padding(.vertical, 2)
                    .font(
                        .system(size: MUSCLE_TEXT_FONT_SIZE)
                            .bold()
                    )
                    .frame(width: MUSCLE_TEXT_WIDTH)
            }
        }
        .frame(minWidth: 58)
    }
}
