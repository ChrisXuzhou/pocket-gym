//
//  Equipmentselectorsheet.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/10/11.
//

import SwiftUI

struct Equipmentselectorsheet_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Equipmentselectorsheet(
                present: .constant(true),
                selected: .constant("dumbbell"),
                header: "Any Type?",
                options: ["dumbbell", "barbell", "cable"]
            )
        }
    }
}

let SHEET_OPTION_HEIGHT: CGFloat = 45

struct Equipmentselectorsheet: View {
    @Environment(\.presentationMode) var presentmode
    @EnvironmentObject var preference: PreferenceDefinition

    @Binding var present: Bool
    @Binding var selected: String

    var header: String
    var options: [String]
    var callback: (_ selected: String) -> Void = { _ in }

    var body: some View {
        VStack(spacing: 0) {
            headerpanel

            VStack {
                ScrollView(.vertical, showsIndicators: false) {
                    optionpanel

                    SPACE.frame(height: 80)
                }
                .padding(.vertical, 5)
            }
            .background(
                NORMAL_BG_COLOR.ignoresSafeArea()
            )
        }
    }
}

extension Equipmentselectorsheet {
    var headerpanel: some View {
        HStack {
            Button {
                presentmode.wrappedValue.dismiss()
                present = false
            } label: {
                CLOSE_IMG
            }

            SPACE

            LocaleText(header)

            SPACE
            
            SPACE.frame(width: 30)
        }
        .font(.system(size: DEFINE_FONT_SMALL_SIZE - 1))
        .foregroundColor(NORMAL_LIGHT_TEXT_COLOR)
        .frame(height: MIN_UP_TAB_HEIGHT)
        .padding(.horizontal)
        .background(
            NORMAL_BG_CARD_COLOR.ignoresSafeArea()
        )
    }

    var optionpanel: some View {
        VStack(spacing: 0) {
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

                    present = false
                }

                if idx != options.count {
                    LOCAL_DIVIDER.padding(.leading)
                }
            }
        }
    }
}
