//
//  Fromtemplatelabel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/8.
//

import SwiftUI

struct Fromtemplatelabel_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            VStack {
                SPACE

                Fromtemplatelabel()

                SPACE
            }
            .background(
                NORMAL_BG_COLOR
            )
        }
    }
}

let FROM_TEMPLATES_LABEL_HEIGHT: CGFloat = 150

struct Fromtemplatelabel: View {
    @EnvironmentObject var preference: PreferenceDefinition

    var body: some View {
        VStack(spacing: 0) {
            Labeltitle(
                title: preference.language(LANGUAGE_TRAINING_FROMTEMPLATES)
            )
            .padding(.horizontal)
            .padding(.vertical, 10)

            HStack {
                SPACE
            }
            .frame(height: FROM_TEMPLATES_LABEL_HEIGHT)
            .background(
                NORMAL_BG_CARD_COLOR
            )
        }
    }
}
