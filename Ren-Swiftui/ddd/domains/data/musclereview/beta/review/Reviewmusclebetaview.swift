//
//  Reviewmusclebetaview.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/11/21.
//

import SwiftUI

struct Reviewmusclebetaview_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Reviewmusclebetaview(days: 30)
        }
    }
}

class Reviewmusclebetamodel: ObservableObject {
    @Published var days: Int

    init(_ days: Int) {
        self.days = days
    }
}

struct Reviewmusclebetaview: View {
    @EnvironmentObject var preference: PreferenceDefinition

    @StateObject var librarymuscle = Librarynewdisplayedmuscle.shared
    @StateObject var model: Reviewmusclebetamodel

    init(days: Int) {
        _model = StateObject(wrappedValue: Reviewmusclebetamodel(days))
    }

    var body: some View {
        ZStack {
            NORMAL_BG_COLOR.ignoresSafeArea()

            VStack(spacing: 0) {
                upheader

                ScrollView(.vertical, showsIndicators: false) {
                    content
                }

                SPACE
            }
            .environmentObject(model)
        }
    }
}

extension Reviewmusclebetaview {
    var upheader: some View {
        Reviewmusclebetaviewuptab()
    }

    var noteheader: some View {
        HStack {
            let _text = preference.languagewithplaceholder("targetradarmapdesc", firstletteruppercase: false, value: "\(model.days)")

            Text(_text)
                .lineSpacing(8)
                .font(.system(size: DEFINE_FONT_SMALL_SIZE - 1, design: .rounded))
                .foregroundColor(NORMAL_LIGHT_TEXT_COLOR)
        }
        .padding(.top)
    }

    var content: some View {
        VStack {
            noteheader.padding(.horizontal, 10)

            SPACE.frame(height: 10)

            ForEach(0 ..< librarymuscle.groups.count, id: \.self) { idx in
                let group = librarymuscle.groups[idx]

                VStack(alignment: .leading, spacing: 10) {
                    LocaleText(group.displayedgroupid)
                        .font(.system(size: DEFINE_FONT_SMALL_SIZE).bold())
                        .foregroundColor(NORMAL_LIGHTER_COLOR)
                        .padding(.horizontal)
                        .padding(.vertical, 5)

                    Muscleradarcard(group.displayedgroupid, days: model.days)
                        .padding(.horizontal, 10)

                    if idx != (librarymuscle.groups.count - 1) {
                        LOCAL_DIVIDER.padding(.vertical, 5)
                    }
                }
            }

            COPYRIGHT

            SPACE.frame(height: MIN_DOWN_TAB_HEIGHT)
        }
    }
}

struct Reviewmusclebetaviewuptab: View {
    @Environment(\.presentationMode) var present
    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var model: Reviewpanelmodel

    /*
     * variables
     */
    @StateObject var editeswitch = Viewopenswitch()

    var body: some View {
        HStack {
            backbutton
            SPACE

            Text("\(preference.language("targetradarmap")), \(preference.languagewithplaceholder("lastdays", value: "\(model.days)"))")
                .font(.system(size: UP_HEADER_TITLE_FONT_SIZE).bold())
                .foregroundColor(NORMAL_LIGHTER_COLOR)

            SPACE
            editbutton
        }
        .padding(.horizontal)
        .frame(height: MIN_UP_TAB_HEIGHT)
        .background(NORMAL_UPTAB_BACKGROUND_COLOR.ignoresSafeArea())
    }

    var backbutton: some View {
        Button {
            present.wrappedValue.dismiss()
        } label: {
            Backarrow()
        }
        .padding(.trailing, 10)
    }

    var editbutton: some View {
        Button {
            editeswitch.value.toggle()
        } label: {
            Systemimage(name: "slider.horizontal.2.gobackward")
        }
        .padding(.leading, 10)
        .sheet(isPresented: $editeswitch.value) {
            Reviewmusclebetaeditor(days: model.days) { days in
                model.days = days
                model.objectWillChange.send()
                
                DispatchQueue.global().async {
                    var appcache = Appcache(cachekey: REVIEW_DAYS_KEY, cachevalue: "\(days)")
                    try! AppDatabase.shared.saveappcache(&appcache)
                }
            }
        }
    }
}

struct Reviewmusclebetaeditor: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @Environment(\.presentationMode) var present

    /*
     * variables
     */
    @State var days: Int
    var save: (_ days: Int) -> Void

    var body: some View {
        VStack {
            upheader

            ScrollView(.vertical, showsIndicators: false) {
                content
            }

            SPACE
        }
    }
}

let TIMERANGE_DAYS = [Int](1 ... 30)

extension Reviewmusclebetaeditor {
    var upheader: some View {
        HStack(alignment: .lastTextBaseline) {
            Button {
                withAnimation {
                    present.wrappedValue.dismiss()
                }
            } label: {
                LocaleText("cancel")
                    .foregroundColor(NORMAL_LIGHTER_COLOR)
                    .font(.system(size: DEFINE_FONT_SMALL_SIZE))
                    .frame(width: SHEET_BUTTON_WIDTH, alignment: .leading)
            }

            SPACE

            LocaleText("timerange")
                .font(
                    .system(size: DEFINE_SHEET_FONT_SIZE)
                        .bold()
                )
                .foregroundColor(NORMAL_LIGHTER_COLOR)

            SPACE

            Button {
                withAnimation {
                    save(days)
                    present.wrappedValue.dismiss()
                }
            } label: {
                Text(preference.language("save"))
                    .foregroundColor(preference.theme)
                    .font(.system(size: DEFINE_FONT_SMALL_SIZE))
                    .frame(width: SHEET_BUTTON_WIDTH, alignment: .trailing)
            }
        }
        .padding(.horizontal)
        .frame(height: SHEET_HEADER_HEIGHT)
        .background(NORMAL_BG_CARD_COLOR)
    }

    var content: some View {
        SettingPanel {
            VStack(spacing: 0) {
                Listitemlabel(keyortitle: "timerange") {
                    Text("\(days)")
                        .font(.system(size: DEFINE_FONT_SMALL_SIZE))
                }

                LIGHT_LOCAL_DIVIDER

                Picker(selection: $days, label: Text("")) {
                    ForEach(TIMERANGE_DAYS, id: \.self) {
                        each in

                        HStack(alignment: .lastTextBaseline, spacing: 1) {
                            Text("\(each)")
                                .tag(each)
                                .font(.system(size: DEFINE_FONT_SMALL_SIZE))
                        }
                        .tag(each)
                    }
                }
                .pickerStyle(.wheel)
                .compositingGroup()
            }
        }
    }
}
