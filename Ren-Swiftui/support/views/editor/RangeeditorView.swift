//
//  PercenteditorView.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/27.
//

import SwiftUI

struct Intseletctorsheet_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Intseletctorsheet(
                selected: .constant(5),
                rangelist: [2, 3, 5, 8, 10],
                rangedescriptor: "%"
            )
        }
    }
}

struct Intseletctorsheet: View {
    @Environment(\.presentationMode) var presentmode
    @EnvironmentObject var preference: PreferenceDefinition

    @Binding var selected: Int
    /*
     * percent range.
     */
    var rangelist: [Int]
    var rangedescriptor: String

    var inputab: some View {
        GeometryReader {
            geometry in

            HStack(spacing: 0) {
                SPACE

                HStack {
                    Picker(selection: self.$selected, label: Text("")) {
                        ForEach(rangelist, id: \.self) { each in
                            Text("\(each)").tag(each)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(width: geometry.size.width / 2, height: geometry.size.height, alignment: .center)

                    Text(rangedescriptor)
                        .font(.system(size: 17))
                        .foregroundColor(Color(.systemGray))
                }

                SPACE
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
                               color: preference.theme)
                    .padding(.horizontal)
            }
        }
    }
}
