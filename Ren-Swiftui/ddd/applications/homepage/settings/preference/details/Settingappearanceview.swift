//
//  Settingappearanceview.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/11/26.
//

import SwiftUI

struct Settingappearanceview_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Settingappearanceview(name: "appearance")
                .environmentObject(General())
        }
    }
}

struct Settingappearanceview: View {
    @Environment(\.presentationMode) var presentmode
    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var model: General

    var name: String

    /*
     * variables
     */
    @StateObject var showheader = Viewopenswitch()

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

                    content
                }

                SPACE
            }
        }
    }
}

/*
 *
 */
extension Settingappearanceview {
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

extension Settingappearanceview {
    var content: some View {
        SettingPanel {
            VStack {
                appearancesystem

                if !model.usesystemappearence {
                    LIGHT_LOCAL_DIVIDER
                    appearance
                }
            }
        }
    }

    var appearancesystem: some View {
        Listitemlabel(
            keyortitle: "usesystem"
        ) {
            Toggle(
                "", isOn: $model.usesystemappearence.onChange(
                    { newvalue in
                        model.usesystemappearence = newvalue
                        model.save()
                    }
                )
            )
            .toggleStyle(SwitchToggleStyle(tint: preference.theme))
        }
    }

    var appearance: some View {
        Listitemlabel(
            keyortitle: LANGUAGE_DARKMODE
        ) {
            Toggle("", isOn: $model.isdarkmode.onChange(
                { newvalue in
                    model.appearance = newvalue ? .dark : .light
                    model.save()
                }))
                .toggleStyle(SwitchToggleStyle(tint: preference.theme))
        }
    }
}
