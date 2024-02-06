//
//  Question.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/29.
//

import SwiftUI

struct Question_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            VStack {
                Question("Choose your Fitness Goal", suffix: " ?")

                SPACE
            }
        }
    }
}

struct Question: View {
    @EnvironmentObject var preference: PreferenceDefinition

    init(_ question: String, suffix: String = "") {
        self.question = question
        self.suffix = suffix
    }

    var question: String
    var suffix: String

    var body: some View {
        HStack(spacing: 3) {
            Text(preference.language(question, firstletteruppercase: false) + suffix)
                .tracking(0.5)
                .lineSpacing(8)
                .lineLimit(2)
                .minimumScaleFactor(0.01)
                .multilineTextAlignment(.center)
        }
        .font(.system(size: DEFINE_FONT_BIG_SIZE ).bold())
        .foregroundColor(NORMAL_COLOR)
        .padding(.horizontal)
    }
}
