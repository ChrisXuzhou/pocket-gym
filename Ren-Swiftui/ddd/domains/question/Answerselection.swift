//
//  Answerselection.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/29.
//

import SwiftUI

struct Answerselection_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            VStack {
                Answerselection(
                    answer: "Beginner",
                    description: "Lack of exerice, need something easy to get started"
                )

                Answerselection(
                    answer: "Beginner",
                    description: "Lack of exerice, need something easy to get started",
                    focused: true
                )
            }
            .padding()
        }
    }
}

let NORMAL_SELECTION_HEIGHT: CGFloat = 80

struct Answerselection: View {
    @EnvironmentObject var preference: PreferenceDefinition

    var answer: String
    var answerfontsize: CGFloat = DEFINE_FONT_SMALL_SIZE
    var description: String?

    var focused: Bool = false
    var height: CGFloat = NORMAL_SELECTION_HEIGHT

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                
                LocaleText(answer)
                    .font(.system(size: answerfontsize).bold())
                    .foregroundColor(
                        focused ?
                            preference.theme : NORMAL_LIGHTER_COLOR
                    )
                
                SPACE
            }

            if let _d = description {
                LocaleText(_d, linelimit: 5)
                    .font(.system(size: DEFINE_FONT_SMALLER_SIZE))
                    .foregroundColor(
                        focused ?
                            preference.theme : NORMAL_GRAY_COLOR
                    )
                    .padding(.vertical, 5)
            }

        }
        .padding(.vertical, 10)
        .padding(.horizontal)
        .frame(height: height)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .stroke(
                    focused ?
                        preference.theme : NORMAL_LIGHT_GRAY_COLOR
                    ,
                    lineWidth: 1.5
                )
                .background(
                    focused ?
                    preference.themesecondarycolor.opacity(0.5) : .clear
                )
        )
    }
}
