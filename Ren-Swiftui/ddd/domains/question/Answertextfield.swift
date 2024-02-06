//
//  Answertextfield.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/30.
//

import SwiftUI

struct Answertextfield_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Answertextfield(answer: .constant("name"))
        }
    }
}

struct Answertextfield: View {
    @EnvironmentObject var preference: PreferenceDefinition

    var title: String = ""
    @Binding var answer: String
    @FocusState var focused: Bool
    
    var body: some View {
        HStack {
            
            TextField(title, text: $answer)
                .focused($focused)
                .font(.system(size: DEFINE_FONT_SMALL_SIZE - 2).bold())
                .keyboardType(.default)
                .submitLabel(.done)

            SPACE
        }
        .foregroundColor(
            focused ?
                preference.theme : NORMAL_COLOR
        )
        .padding(.vertical, 10)
        .padding(.horizontal)
        .frame(height: NORMAL_ANSWER_INPUT_HEIGHT)
        .contentShape(Rectangle())
        .onTapGesture(perform: {
            focused = true
        })
        .background(
            RoundedRectangle(cornerRadius: 15)
                .stroke(
                    focused ?
                        preference.theme : NORMAL_LIGHT_GRAY_COLOR
                    ,
                    lineWidth: 1.5
                )
                .background(
                    focused ?
                        preference.themesecondarycolor.opacity(0.5) : .clear
                )
        )
        .padding(.horizontal)
    }
}
