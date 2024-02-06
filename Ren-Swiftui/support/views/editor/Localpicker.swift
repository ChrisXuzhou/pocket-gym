//
//  Localpicker.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/9/29.
//

import SwiftUI

struct Localpicker_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Localpicker(selected: .constant("canada"), options: ["canada", "us"])
        }
    }
}

struct Localpicker: View {
    @Environment(\.presentationMode) var presentmode
    @EnvironmentObject var preference: PreferenceDefinition

    @Binding var selected: String

    var options: [String]

    var inputab: some View {
        GeometryReader {
            geometry in

            HStack(spacing: 0) {
                HStack(spacing: 0) {
                    Picker(selection: $selected,
                           label: Text("")) {
                        ForEach(options, id: \.self) { each in
                            Text(each).tag(each)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(width: geometry.size.width,
                           height: geometry.size.height, alignment: .center)
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
