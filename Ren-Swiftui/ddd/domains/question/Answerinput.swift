//
//  Answerinput.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/29.
//

import SwiftUI

struct Answerinput_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            VStack {
                Answerinput(answer: "10")
                    .padding(.horizontal)
                Answerinput(answer: "10", focused: true)
                    .padding(.horizontal)
            }
        }
    }
}

let NORMAL_ANSWER_INPUT_HEIGHT: CGFloat = 40

struct Answerinput: View {
    
    @EnvironmentObject var preference: PreferenceDefinition

    var answer: String
    var descriptor: String? 
    var focused: Bool = false

    var body: some View {
        HStack {
            LocaleText(answer)
                .font(.system(size: DEFINE_FONT_SMALL_SIZE ).bold())
            
            SPACE
            
            Image(systemName: "chevron.down")
            
        }
        .foregroundColor(
            focused ?
                preference.theme : NORMAL_COLOR
        )
        .padding(10)
        .frame(height: NORMAL_ANSWER_INPUT_HEIGHT)
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
    }
}
