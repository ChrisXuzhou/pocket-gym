//
//  Logtypeselectorsheet.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/5/16.
//

import SwiftUI
struct Logtypeselectorsheet_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Logtypeselectorsheet(present: .constant(false))
        }
    }
}

struct Logtypeselectorsheet: View {
    @EnvironmentObject var preference: PreferenceDefinition

    @Binding var present: Bool
    /*
     * group variables
     */
    @State var selected: String = ""
    var callback: (_ selected: String) -> Void = { _ in }

    var headerpanel: some View {
        HStack {
            SPACE

            LocaleText("logcontent")

            SPACE
        }
        .font(.system(size: DEFINE_FONT_SMALL_SIZE - 1))
        .foregroundColor(NORMAL_LIGHT_TEXT_COLOR)
        .frame(height: 40)
        .padding(.horizontal)
        .background(
            NORMAL_BG_CARD_COLOR.ignoresSafeArea()
        )
    }

    var body: some View {
        ZStack {
            NORMAL_BG_COLOR.ignoresSafeArea()

            VStack(spacing: 0) {
                headerpanel

                contentpanel

                SPACE
            }
        }
    }
}

extension Logtypeselectorsheet {
    var contentpanel: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                let options = [Logtype.repsandweight.rawValue, Logtype.reps.rawValue]

                ForEach(0 ..< options.count, id: \.self) {
                    idx in

                    let option = options[idx]
                    HStack {
                        LocaleText(option)

                        SPACE

                        if selected == option {
                            Image("checkmark")
                                .renderingMode(.template)
                                .resizable()
                                .frame(width: 20, height: 16, alignment: .center)
                                .aspectRatio(contentMode: .fill)
                                .foregroundColor(preference.theme)
                        }
                    }
                    .font(.system(size: DEFINE_FONT_SMALL_SIZE))
                    .foregroundColor(NORMAL_LIGHTER_COLOR)
                    .frame(height: SHEET_OPTION_HEIGHT)
                    .padding(.horizontal)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        callback(option)
                    }

                    if idx != options.count {
                        LOCAL_DIVIDER.padding(.leading)
                    }
                }
            }
        }
        // end of scroll
    }
}
