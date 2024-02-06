//
//  HeighteditorView.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/2/19.
//

import SwiftUI

struct HeighteditorView_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            HeighteditorView(height: .constant(175))
        }
    }
}

struct HeighteditorView: View {
    @Environment(\.presentationMode) var presentmode
    @EnvironmentObject var preference: PreferenceDefinition
    @Binding var height: Int
    /*
     * height related.
     */
    let heightList = [Int](90 ..< 240)

    var inputab: some View {
        GeometryReader {
            geometry in

            HStack(spacing: 0) {
                HStack {
                    Picker(selection: self.$height, label: Text("")) {
                        ForEach(heightList, id: \.self) { each in
                            Text("\(each)").tag(each)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(width: geometry.size.width,
                           height: geometry.size.height, alignment: .center)

                    /*

                     Text("cm")
                         .font(.system(size: 17))
                         .foregroundColor(Color(.systemGray))

                     */
                }
            }
        }
    }

    var body: some View {
        VStack {
            SPACE

            LocaleText("yourheight")
                .font(.system(size: DEFINE_FONT_SIZE))
                .foregroundColor(NORMAL_LIGHTER_COLOR)

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
