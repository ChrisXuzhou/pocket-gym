//
//  Muscleselectorsheet.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/10/11.
//

import SwiftUI

struct Muscleselectorsheet_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            VStack {
                Muscleselectorsheet(present: .constant(true), "chest")
            }
        }
    }
}

enum Muscleselectorusage {
    case forquery, formuscle
}

struct Muscleselectorsheet: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @Environment(\.presentationMode) var presentmode

    @Binding var present: Bool
    @StateObject var library = Librarynewdisplayedmuscle.shared

    /*
     * variables
     */
    var usage: Muscleselectorusage
    var callback: (_ selectedgroup: String, _ selectedmain: String) -> Void

    init(present: Binding<Bool>, _ selected: String,
         usage: Muscleselectorusage = .forquery,
         callback: @escaping (_ selectedgroup: String, _ selectedmain: String) -> Void = { _, _ in }) {
        _present = present
        self.usage = usage
        self.callback = callback

        if let _s = Librarynewdisplayedmuscle.shared.dictionary[selected] {
            if let _f = _s.father {
                _selectedgroup = .init(initialValue: _f.muscle.ident)
                _selectedmain = .init(initialValue: _s.muscle.ident)
            } else {
                _selectedgroup = .init(initialValue: _s.muscle.ident)
            }
        }
    }

    func closeandcallback() {
        callback(selectedgroup, selectedmain)

        present = false
    }

    /*
     * group variables
     */
    @State var selectedgroup: String = "any"

    var groupoptions: [String] {
        if usage == .formuscle {
            return library.groups.map({ $0.muscle.ident })
        }

        return ["any"] + library.groups.map({ $0.muscle.ident })
    }

    /*
     * main variables
     */
    @State var selectedmain: String = "any"

    var header: String = "targetarea"

    var mainoptions: [String] {
        let children: [Newdisplayedmusclewrapper] = library.dictionary[selectedgroup]?.children ?? []
        let _mainoptions: [String] = children.map({ $0.muscle.ident })

        return ["any"] + _mainoptions
    }

    var body: some View {
        VStack(spacing: 0) {
            headerpanel

            VStack {
                HStack {
                    groupoptionpanel

                    VERTICAL_DIVIDER.padding(.vertical)

                    mainoptionpanel
                }

                SPACE

                Button {
                    closeandcallback()
                } label: {
                    Floatingbutton(label: "confirm",
                                   disabled: false,
                                   color: preference.theme).padding(.horizontal)
                }
                // .border(Color.red)
            }
            .padding(.top)
            .background(
                NORMAL_BG_COLOR.ignoresSafeArea()
            )
        }
    }
}

extension Muscleselectorsheet {
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

    var groupoptionpanel: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 5) {
                let groupoptions = groupoptions

                ForEach(0 ..< groupoptions.count, id: \.self) {
                    idx in

                    let option = groupoptions[idx]
                    HStack {
                        LocaleText(option)

                        SPACE

                        if selectedgroup == option {
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
                        selectedgroup = option
                        selectedmain = "any"
                    }
                }
            }
        }
    }

    var mainoptionpanel: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 5) {
                ForEach(0 ..< mainoptions.count, id: \.self) {
                    idx in

                    let option = mainoptions[idx]
                    HStack {
                        LocaleText(option)

                        SPACE

                        if selectedmain == option {
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
                        selectedmain = option

                        closeandcallback()
                    }

                    /*

                     if idx != mainoptions.count {
                         LOCAL_DIVIDER.padding(.leading)
                     }

                     */
                }
            }
        }
    }
}
