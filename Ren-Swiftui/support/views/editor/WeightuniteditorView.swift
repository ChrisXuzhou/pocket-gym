//
//  WeightunitEditorView.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/2/20.
//

import SwiftUI

struct WeightunitEditorView_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            WeightuniteditorView(weightunit: .constant(.kg))
        }
    }
}

struct WeightuniteditorView: View {
    @Environment(\.presentationMode) var presentmode
    @EnvironmentObject var preference: PreferenceDefinition

    @Binding var weightunit: Weightunit
    let weightunitList: [Weightunit] = [.kg, .lb]

    var inputab: some View {
        GeometryReader {
            geometry in

            HStack(spacing: 0) {
                HStack(spacing: 0) {
                    Picker(selection: self.$weightunit,
                           label: Text("")) {
                        ForEach(weightunitList, id: \.self) { each in
                            Text("\(each.name)").tag(each)
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
                               color: preference.theme)
                    .padding(.horizontal)
            }
        }
    }
}
