//
//  Guideview.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/11/7.
//

import SwiftUI

struct Guideview_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Guideview()
        }
    }
}

struct Guideview: View {
    @Environment(\.presentationMode) var present
    @EnvironmentObject var preference: PreferenceDefinition

    /*
     * variables
     */
    var fontsize: CGFloat = DEFINE_FONT_SMALL_SIZE
    
    var body: some View {
        ZStack {
            NORMAL_BG_COLOR.ignoresSafeArea()
            
            VStack {
                upheader

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        newtrainingpanel

                        newroutinepanel

                        planpanel

                        Feedbacklabel().padding(.vertical, 30)
                    }
                    .padding(10)
                }
            }
        }
    }
}

extension Guideview {
    var upheader: some View {
        HStack {
            Button {
                present.wrappedValue.dismiss()
            } label: {
                Backarrow()
            }

            SPACE

            LocaleText("quickstartguide")
                .font(.system(size: UP_HEADER_TITLE_FONT_SIZE).bold())
                .foregroundColor(NORMAL_LIGHTER_COLOR)

            SPACE

            SPACE.frame(width: 15)
        }
        .frame(height: MIN_UP_TAB_HEIGHT)
        .padding(.horizontal)
    }

    var newtrainingpanel: some View {
        ZStack {
            NORMAL_BG_CARD_COLOR

            VStack(alignment: .leading, spacing: 10) {
                bartitle("startquest")

                LOCAL_DIVIDER

                /*
                 Trainingbutton(img: Image(systemName: "plus"))
                     .padding()
                 */

                LocaleText("startanswer", usefirstuppercase: false)
                    .font(.system(size: fontsize))
                    .foregroundColor(NORMAL_LIGHTER_COLOR)
                    .padding(.top)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 20)
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    var newroutinepanel: some View {
        ZStack {
            NORMAL_BG_CARD_COLOR

            VStack(alignment: .leading, spacing: 10) {
                bartitle("routinequest")

                LOCAL_DIVIDER

                /*
                 HStack(spacing: 10) {
                     Newroutinebuttonwrapper(
                         label: preference.language("routine"),
                         img: Image(systemName: "plus.circle"),
                         color: preference.theme
                     )

                     Newroutinebuttonwrapper(
                         label: preference.language("folder"),
                         img: Image(systemName: "folder.badge.plus"),
                         fontclor: preference.theme,
                         color: NORMAL_BG_BUTTON_COLOR
                     )
                 }
                 */

                LocaleText("routineanswer", usefirstuppercase: false)
                    .font(.system(size: fontsize))
                    .foregroundColor(NORMAL_LIGHTER_COLOR)
                    .padding(.top)

                SPACE
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 20)
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    var planpanel: some View {
        ZStack {
            NORMAL_BG_CARD_COLOR

            VStack(alignment: .leading, spacing: 10) {
                bartitle("planquest")

                LOCAL_DIVIDER

                LocaleText("plananswer", usefirstuppercase: false)
                    .font(.system(size: fontsize))
                    .foregroundColor(NORMAL_LIGHTER_COLOR)
                    .padding(.top)

                SPACE
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 20)
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
