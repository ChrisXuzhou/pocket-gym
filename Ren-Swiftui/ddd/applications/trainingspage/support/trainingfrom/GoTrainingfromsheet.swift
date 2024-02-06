//
//  GoTrainingfromView.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/8.
//

import SwiftUI

struct GoTrainingfromsheet_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            GoTrainingfromsheet()
        }
    }
}

let GOTRAINING_BUTTON_WIDTH: CGFloat = 150
let GOTRAINING_BUTTON_HEIGHT: CGFloat = 50

struct GoTrainingfromsheet: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @Environment(\.presentationMode) var present

    var uptabview: some View {
        HStack(alignment: .lastTextBaseline) {
            Button {
                withAnimation {
                    present.wrappedValue.dismiss()
                }
            } label: {
                LocaleText("cancel")
            }
            .foregroundColor(NORMAL_COLOR)

            Spacer()
        }
        .frame(height: SHEET_HEADER_HEIGHT)
        .padding(.horizontal)
        .background(NORMAL_BG_CARD_COLOR)
    }

    var todaysplanview: some View {
        Fromplanlabel()
    }

    var fromtemplatesview: some View {
        Fromtemplatelabel()
    }

    var gotrainingbutton: some View {
        HStack {
            SPACE
            LocaleText("starttraining")
                .foregroundColor(.white)
                .font(.system(size: DEFINE_FONT_SMALL_SIZE))
            SPACE
        }
        .frame(width: GOTRAINING_BUTTON_WIDTH, height: GOTRAINING_BUTTON_HEIGHT)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(preference.themeprimarycolor)
        )
    }

    var body: some View {
        VStack {
            uptabview

            SPACE

            /*

             todaysplanview

             fromtemplatesview

              */

            gotrainingbutton

            SPACE
        }
        .background(NORMAL_BG_COLOR)
    }
}
