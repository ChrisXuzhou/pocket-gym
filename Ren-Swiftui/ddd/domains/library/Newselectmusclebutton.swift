//
//  Newselectmusclebutton.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/10/10.
//


import SwiftUI

struct Newselectmusclebutton_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            ContentView()
        }
    }
}

struct Newselectmusclebutton: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var librarymodel: Librarybetamodel

    /*
     * function variables
     */
    @StateObject var viewswitch = Viewopenswitch()

    var body: some View {
        Button {
            endtextediting()
            viewswitch.value.toggle()
        } label: {
            Newselectbuttonlabel(
                label: label,
                fontcolor: librarymodel.focusedid.isEmpty ? NORMAL_LIGHTER_COLOR : .white,
                color: librarymodel.focusedid.isEmpty ? NORMAL_BG_BUTTON_COLOR : preference.theme
            )
        }
        .sheet(isPresented: $viewswitch.value) {
            Muscleselectorsheet(
                present: $viewswitch.value, librarymodel.focusedid) {
                selectedgroup, selectedmain in

                if !selectedmain.isEmpty && selectedmain != "any" {
                    librarymodel.focuse(selectedmain)
                } else if !selectedgroup.isEmpty && selectedgroup != "any" {
                    librarymodel.focuse(selectedgroup)
                } else {
                    librarymodel.focuse("")
                }
            }
        }
    }

    var label: String {
        if librarymodel.focusedid.isEmpty {
            return "anytarget"
        }

        if preference.oflanguage == .english {
            return librarymodel.focusedid
        }

        var label = ""

        if let displayedmuscle = Librarynewdisplayedmuscle.shared.dictionary[librarymodel.focusedid] {
            if let _f = displayedmuscle.father {
                label += "\(preference.language(_f.muscle.ident))/"
            }

            label += "\(preference.language(displayedmuscle.muscle.ident))"
        }

        return label
    }
}

struct Newselectequipmentbutton: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var librarymodel: Librarybetamodel

    /*
     * function variables
     */
    @StateObject var viewswitch = Viewopenswitch()

    var body: some View {
        Button {
            endtextediting()
            viewswitch.value.toggle()
        } label: {
            Newselectbuttonlabel(
                label: label,
                fontcolor: librarymodel.focusedequipment.isEmpty ? NORMAL_LIGHTER_COLOR : .white,
                color: librarymodel.focusedequipment.isEmpty ? NORMAL_BG_BUTTON_COLOR : preference.theme
            )
        }
        .sheet(isPresented: $viewswitch.value) {
            Equipmentselectorsheet(
                present: $viewswitch.value,
                selected: $librarymodel.focusedequipment,
                header: "anytype",
                options: ["any"] + EQUIPMENTS
            ) {
                selected in

                if !selected.isEmpty && selected != "any" {
                    librarymodel.focuseequipment(selected)
                } else {
                    librarymodel.focuseequipment("")
                }
            }
        }
    }

    var label: String {
        librarymodel.focusedequipment.isEmpty ? "anytype" : librarymodel.focusedequipment
    }
}

struct Newselectbuttonlabel: View {
    var label: String
    var fontcolor: Color = NORMAL_LIGHTER_COLOR
    var color: Color = NORMAL_BG_BUTTON_COLOR

    var body: some View {
        buttonlabel
    }

    var buttonlabel: some View {
        HStack(spacing: 5) {
            SPACE

            LocaleText(label, usefirstuppercase: false)

            SPACE
        }
        .foregroundColor(fontcolor)
        .font(.system(size: DEFINE_FONT_SMALL_SIZE - 1).bold())
        .frame(height: 35)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(color)
                .shadow(color: color.opacity(0.3), radius: 3)
        )
        .ignoresSafeArea(.keyboard)
    }
}
