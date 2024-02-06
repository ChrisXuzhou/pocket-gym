//
//  BoardingPages.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/2/15.
//

import FloatingLabelTextFieldSwiftUI
import SwiftUI
import SwiftUIPager

struct BoardingPages_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            BoardingPages()
        }
    }
}

struct BoardingskipButton: View {
    @EnvironmentObject var model: Routermodel

    var body: some View {
        HStack {
            Button {
                model.finishedboarding(.skipped)
            } label: {
                LocaleText("skip")
                    .font(.system(size: DEFINE_FONT_SMALL_SIZE).bold())
                    .foregroundColor(NORMAL_BUTTON_COLOR)
                    .padding(.horizontal, 5)
            }
        }
    }
}

let BOARDING_TITLE_FONT_SIZE: CGFloat = 25
let BOARDING_INPUT_HEIGHT: CGFloat = 75
let BOARDING_INPUT_WIDTH: CGFloat = 190

struct BoardingPages: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var model: Routermodel

    @ObservedObject var boardingModel = BoardingModel()

    /*
     * variables
     */
    @State var presentnext = false

    var contentfontsize: CGFloat = DEFINE_FONT_SMALL_SIZE - 1

    var nextbutton: some View {
        Button {
            model.finishedboarding(.finished)
        } label: {
            Floatingbutton(
                label: "startnow",
                disabled: false,
                color: preference.theme
            )
            .padding(.bottom, NORMAL_CUSTOMIZE_BUTTON_VSPACING)
            .padding(.horizontal)
        }

    }

    var contentview: some View {
        VStack {
            SPACE.frame(height: MIN_UP_TAB_HEIGHT)

            Logosmall(showlogo: false, fontsize: DEFINE_FONT_BIG_SIZE)
                .padding()

            Exercisevideo()

            LocaleText(
                "appdescription",
                usefirstuppercase: false,
                linelimit: 10,
                alignment: .leading,
                linespacing: 5
            )
            .lineSpacing(3)
            .font(.system(size: contentfontsize))
            .foregroundColor(NORMAL_LIGHTER_COLOR)
            .padding(.vertical, 10)
            .padding(.horizontal)

            SPACE

            nextbutton
        }
        .onTapGesture(perform: {
            endtextediting()
        })
    }

    var body: some View {
        ZStack {
            NORMAL_BG_COLOR.ignoresSafeArea()

            contentview
        }
    }
}

struct BoardingQuestion: View {
    var question: String

    var body: some View {
        HStack {
            Text(question)
                .font(.system(size: BOARDING_TITLE_FONT_SIZE))
                .foregroundColor(.gray)
                .padding()
                .animationsDisabled()
                .padding(.bottom, 30)
        }
        .frame(width: 300)
    }
}

struct BoardingPickerInput: View {
    var label: String
    var value: Int
    var footer: String
    var isfocused = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(label)
                .font(.system(size: 15))
            VStack(spacing: 0) {
                HStack {
                    Text("\(value) \(footer)")
                        .font(.system(size: 17))
                        .foregroundColor(.blue)
                    Spacer()
                    Image("upArrow")
                        .renderingMode(.template)
                        .resizable()
                        .rotationEffect(.degrees(180))
                        .frame(width: 12, height: 12)
                }
                .padding(.bottom, 10)
                .padding(.top, 8)

                LocalDivider(color: isfocused ? .blue : Color(.systemGray), width: 0.5)
            }
            .foregroundColor(isfocused ? .blue : Color(.systemGray))
        }
        .foregroundColor(Color(.systemGray))
        .frame(width: BOARDING_INPUT_WIDTH, height: BOARDING_INPUT_HEIGHT + 10)
    }
}

/*
 var imglabel: some View {
     Image("bg_8")
         .resizable()
         .aspectRatio(contentMode: .fit)
         .frame(height: 200, alignment: .center)
 }
 */
