//
//  Settingresttimerview.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/11/26.
//

import SwiftUI

struct Settingresttimerview_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Settingresttimerview(name: "resttimer")
                .environmentObject(Preference())
        }
    }
}

let SOUND_TRACKS = ["track1", "track2", "track3"]
let REST_INTERVAL_FACTORS = [Int](1 ... 120)
let REST_INTERVAL_SECS = [-1] + REST_INTERVAL_FACTORS.map({ $0 * 5 })

struct Settingresttimerview: View {
    @Environment(\.presentationMode) var presentmode
    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var model: Preference

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
extension Settingresttimerview {
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

extension Settingresttimerview {
    var content: some View {
        SettingPanel {
            VStack(spacing: 0) {
                /*
                 
                     tracks

                     LIGHT_LOCAL_DIVIDER
                 */

                duration
            }
        }
    }

    var tracks: some View {
        NavigationLink {
            Settingdetailview(
                name: "soundeffect",
                selectedoption: model.notifysoundeffect,
                options: SOUND_TRACKS) {
                    option in

                    model.notifysoundeffect = option
                    // model.save()
                }
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
        } label: {
            Listitemlabel(keyortitle: "soundeffect", value: model.notifysoundeffect) {
            }
        }
    }

    var duration: some View {
        VStack(spacing: 0) {
            Listitemlabel(keyortitle: "duration") {
                Text(displaytime(model.restinterval))
                    .font(.system(size: DEFINE_FONT_SIZE, design: .monospaced))
                    .foregroundColor(preference.theme)
                    .padding(.trailing, 5)
            }

            LIGHT_LOCAL_DIVIDER

            Picker(selection: $model.restinterval, label: Text("")) {
                ForEach(REST_INTERVAL_SECS, id: \.self) {
                    each in

                    HStack(alignment: .lastTextBaseline, spacing: 1) {
                        Text(displaytime(each))
                            .tag(each)
                            .font(.system(size: DEFINE_FONT_SMALL_SIZE, design: .monospaced))
                    }
                    .tag(each)
                }
            }
            .pickerStyle(.wheel)
            .compositingGroup()
        }
    }
    
    func displaytime(_ time: Int) -> String {
        if time < 0 {
            return preference.language("none")
        } else {
            return "\(String(format: "%02d", time / 60)):\(String(format: "%02d", time % 60))"
        }
    }
}
