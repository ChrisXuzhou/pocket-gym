//
//  Settinglanguageview.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/11/25.
//

import SwiftUI

struct Settingdetailview_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Settingdetailview(
                name: "theme",
                selectedoption: "blue",
                options: ["blue", "pink"],
                convert: {
                    option in
                    if let _tc = Themecolor(rawValue: option) {
                        return AnyView(Themecolorlabel(themecolor: _tc))
                    }

                    return AnyView(EmptyView())
                }) { _ in
                }
        }

        DisplayedView {
            Settingdetailview(
                name: "language",
                selectedoption: "english",
                options: ["english", "简体中文"]) { _ in
                }
        }
    }
}

struct Settingdetailview: View {
    @Environment(\.presentationMode) var presentmode

    var name: String
    @State var selectedoption: String
    var options: [String]

    /*
     * variables
     */
    @StateObject var showheader = Viewopenswitch()

    var convert: ((_ option: String) -> AnyView)? = nil
    var callback: (_ option: String) -> Void

    var body: some View {
        ZStack {
            NORMAL_BG_COLOR.ignoresSafeArea()

            VStack(spacing: 0) {
                upheader

                ScrollView(.vertical, showsIndicators: false) {
                    GeometryReader {
                        geometry in

                        if geometry.frame(in: .global).minY >= 80 {
                            hiddenbar
                        }
                    }

                    scrollheader

                    optionsview
                }

                SPACE
            }
        }
    }
}

/*
 *
 */
extension Settingdetailview {
    var upheader: some View {
        HStack(spacing: 10) {
            Button {
                presentmode.wrappedValue.dismiss()
            } label: {
                Backarrow()
            }

            SPACE

            if showheader.value {
                LocaleText(name)
                    .font(.system(size: UP_HEADER_TITLE_FONT_SIZE).bold())
                    .foregroundColor(NORMAL_LIGHTER_COLOR)
            }

            SPACE

            SPACE.frame(width: 18)
        }
        .frame(height: MIN_UP_TAB_HEIGHT)
        .padding(.horizontal)
        .background(NORMAL_BG_COLOR)
    }

    var scrollheader: some View {
        HStack {
            LocaleText(
                name,
                usefirstuppercase: false,
                alignment: .center,
                usescale: false
            )
            .foregroundColor(NORMAL_LIGHTER_COLOR)
            .font(.system(size: DEFINE_FONT_BIGGEST_SIZE + 8).weight(.heavy))

            SPACE
        }
        .frame(height: MIN_UP_TAB_HEIGHT)
        .padding(.horizontal)
    }

    var hiddenbar: some View {
        Text(" ")
            .frame(width: UIScreen.width, height: 2)
            .contentShape(Rectangle())
            .onAppear {
                self.showheader.value = false
            }
            .onDisappear {
                self.showheader.value = true
            }
    }
}

extension Settingdetailview {
    var optionsview: some View {
        SettingPanel {
            VStack(spacing: 0) {
                ForEach(0 ..< options.count, id: \.self) {
                    idx in

                    let option = options[idx]

                    HStack {
                        if let _c = convert {
                            Listitemlabel(
                                sampleview: _c(option),
                                keyortitle: option) {
                                    if selectedoption == option {
                                        Image(systemName: "checkmark")
                                            .font(.system(size: DEFINE_FONT_SMALL_SIZE).bold())
                                            .foregroundColor(PreferenceDefinition.shared.theme)
                                    }
                                }

                        } else {
                            Listitemlabel(
                                keyortitle: option) {
                                    if selectedoption == option {
                                        Image(systemName: "checkmark")
                                            .font(.system(size: DEFINE_FONT_SMALL_SIZE).bold())
                                            .foregroundColor(PreferenceDefinition.shared.theme)
                                    }
                                }
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        self.selectedoption = option

                        DispatchQueue.main.async {
                            self.callback(option)
                        }

                        /*
                         DispatchQueue(label: "option selected", qos: .background).async {
                             self.callback(option)
                         }
                         */
                    }

                    if idx != options.count - 1 {
                        LIGHT_LOCAL_DIVIDER
                    }
                }
            }
        }
    }
}
