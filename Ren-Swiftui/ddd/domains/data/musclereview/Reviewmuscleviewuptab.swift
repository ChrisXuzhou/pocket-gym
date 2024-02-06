//
//  Muscleradardetailviewuptab.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/5/10.
//


import SwiftUI

struct Muscleradardetailviewuptab: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var model: Reviewpanelmodel

    @Binding var present: Bool
    @Binding var selectedmuscleid: String
    var lastdays: Int

    var backbutton: some View {
        Button {
            present.toggle()
        } label: {
            Backarrow()
        }
        .padding(.trailing, 10)
    }

    @StateObject var viewswitch = Viewopenswitch()

    var uptitle: some View {
        HStack {
            let _title = preference.languagewithplaceholder("shortlastdays",
                                                            firstletteruppercase: false,
                                                            value: "\(lastdays)")

            let _muscle = preference.language(selectedmuscleid)

            LocaleText("\(_title), \(_muscle)")
        }
        .font(.system(size: UP_HEADER_TITLE_FONT_SIZE).bold())
    }

    var body: some View {
        HStack {
            backbutton

            Button {
                viewswitch.value.toggle()
            } label: {
                HStack(spacing: 10) {
                    SPACE

                    uptitle

                    //Image("upArrow")
                    Image(systemName: "chevron.down.circle.fill")
                        .renderingMode(.template)
                        .resizable()
                        //.rotationEffect(.degrees(180))
                        .frame(width: 19, height: 19)
                        .contentShape(Rectangle())
                        .foregroundColor(preference.theme)
                    
                    SPACE
                }
            }
        }
        .foregroundColor(NORMAL_LIGHTER_COLOR)
        .frame(height: MIN_UP_TAB_HEIGHT)
        .padding(.horizontal)
        .background(NORMAL_BG_COLOR.ignoresSafeArea())
        .sheet(isPresented: $viewswitch.value) {
            Muscleselectorsheet(
                present: $viewswitch.value, selectedmuscleid, usage: .formuscle) {
                selectedgroup, selectedmain in

                if selectedmain.isEmpty || selectedmain == "any" {
                    selectedmuscleid = selectedgroup
                } else {
                    selectedmuscleid = selectedmain
                }
            }
            // .frame(height: UIScreen.height * 2 / 3)
        }
    }
}
