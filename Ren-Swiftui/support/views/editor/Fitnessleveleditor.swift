//
//  Fitnessleveleditor.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/5/31.
//

import SwiftUI

struct Fitnessleveleditor_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Fitnessleveleditor(level: .constant(.beginner))
        }
    }
}

struct Fitnessleveleditor: View {
    @Environment(\.presentationMode) var presentmode
    @EnvironmentObject var preference: PreferenceDefinition
    @Binding var level: Programlevel

    var inputab: some View {
        GeometryReader {
            geometry in

            HStack(spacing: 0) {
                HStack(spacing: 0) {
                    Picker(selection: self.$level,
                           label: Text("")) {
                        ForEach(Programlevel.allCases, id: \.self) { each in
                            LocaleText("\(each.rawValue)")
                                .tag(each)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                    .compositingGroup()
                    .clipped()
                }
            }
        }
    }

    var body: some View {
        VStack {
            SPACE
            inputab.frame(height: NORMAL_POPUP_HEIGHT)
            SPACE

            Button {
                presentmode.wrappedValue.dismiss()

            } label: {
                Floatingbutton(label: "confirm",
                               disabled: false,
                               color: preference.theme).padding(.horizontal)
            }
        }
    }
}
