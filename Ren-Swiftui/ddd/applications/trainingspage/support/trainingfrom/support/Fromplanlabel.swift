//
//  Fromplanlabel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/8.
//

import SwiftUI

struct Fromplanlabel_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            VStack {
                Spacer()

                Fromplanlabel()

                Spacer()
            }
            .background(
                NORMAL_BG_COLOR
            )
        }
    }
}

let FROM_PLAN_LABEL_HEIGHT: CGFloat = 60

struct Fromplanlabel: View {
    @EnvironmentObject var preference: PreferenceDefinition

    var body: some View {
        VStack(spacing: 0) {
            Labeltitle(
                title: preference.language(LANGUAGE_TRAINING_TODAY)
            )
            .padding(.horizontal)
            .padding(.vertical, 10)

            HStack {
                SPACE
            }
            .frame(height: FROM_PLAN_LABEL_HEIGHT)
            .background(
                NORMAL_BG_CARD_COLOR
            )
        }
    }
}
