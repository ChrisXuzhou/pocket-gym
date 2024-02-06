//
//  LanguageeditorView.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/2/20.
//

import SwiftUI

struct LanguageeditorView_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            LanguageeditorView(language: .constant(.simpledchinese))
        }
    }
}

struct LanguageeditorView: View {
    @Environment(\.presentationMode) var presentmode
    @EnvironmentObject var preference: PreferenceDefinition

    @Binding var language: Language

    let preferenceList: [Language] = [.english, .simpledchinese]

    var inputab: some View {
        GeometryReader {
            geometry in

            HStack(spacing: 0) {
                HStack(spacing: 0) {
                    Picker(selection: $language,
                           label: Text("")) {
                        ForEach(preferenceList, id: \.self) { each in
                            Text("\(each.name)").tag(each)
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
                               color: preference.theme)
                    .padding(.horizontal)
            }
        }
    }
}
