//
//  ConfirmView.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/11.
//

import SwiftUI

struct ConfirmView_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            VStack {
                SPACE

                ConfirmView(present: .constant(true),
                            question: "Are You Single?") {
                    log("done .. ")
                }
            }
            .background(
                NORMAL_BG_COLOR
            )
        }
    }
}

let CONFIRM_QUESTION_FONT_SIZE: CGFloat = DEFINE_FONT_SMALL_SIZE
let CONFRIM_ITEM_HEIGHT: CGFloat = 55

struct ConfirmView: View {
    @Binding var present: Bool
    var question: String

    var callback: () -> Void

    var questionview: some View {
        HStack {
            SPACE
            Text(question)
                .foregroundColor(NORMAL_LIGHTER_COLOR)
                .font(.system(size: CONFIRM_QUESTION_FONT_SIZE).bold())
            SPACE
        }
        .frame(height: CONFRIM_ITEM_HEIGHT)
    }

    var confirmbutton: some View {
        HStack {
            SPACE
            Button {
                callback()
                present = false
            } label: {
                LocaleText(LANGUAGE_CONFIRM)
                    .foregroundColor(NORMAL_BLUE_COLOR)
                    .font(.system(size: CONFIRM_QUESTION_FONT_SIZE))
            }
            SPACE
        }
        .frame(height: CONFRIM_ITEM_HEIGHT)
    }

    var cancelbutton: some View {
        HStack {
            SPACE
            Button {
                present = false
            } label: {
                LocaleText("cancel")
                    .font(.system(size: DEFINE_FONT_SMALL_SIZE).bold())
                    .foregroundColor(NORMAL_BUTTON_COLOR)
            }
            SPACE
        }
        .frame(height: CONFRIM_ITEM_HEIGHT)
    }

    var body: some View {
        PopuptabView {
            VStack(spacing: 0) {
                questionview

                LocalDivider(color: NORMAL_LIGHT_GRAY_COLOR, width: 5).padding(0)

                confirmbutton

                LocalDivider(color: NORMAL_LIGHT_GRAY_COLOR, width: 1).padding(0)

                cancelbutton
            }
            .padding(.top)
        }
    }
}
