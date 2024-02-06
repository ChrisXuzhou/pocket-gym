//
//  Answernumberfield.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/4/21.
//

import SwiftUI

struct Answernumberfield_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            HStack {
                Answernumberfield(answer: .constant("reps"))
                Answernumberfield(answer: .constant("weights laped"))
            }
            .padding(.horizontal)
        }
    }
}

enum Numbertype {
    case digit, integer
}

struct Answernumberfield: View {
    @EnvironmentObject var preference: PreferenceDefinition

    var numbertype: Numbertype = .digit
    var title: String = ""
    @Binding var answer: String
    var answerfontsize: CGFloat = DEFINE_FONT_SMALL_SIZE - 2
    
    @FocusState var focused: Bool
    
    
    var descriptor: String?
    var alwaysshowdescriptor: Bool = false

    var body: some View {
        HStack {
            TextField(title, text: $answer)
                .keyboardType(.default)
                .submitLabel(.done)
                .focused($focused)
                .if (numbertype == .digit) {
                    $0.keyboardType(.decimalPad)
                }
                .if (numbertype == .integer) {
                    $0.keyboardType(.numberPad)
                }
                .font(.system(size: answerfontsize).bold())
            
            SPACE
            
            if alwaysshowdescriptor || !answer.isEmpty {
                if let _descriptor = descriptor {
                    LocaleText(_descriptor)
                        .font(.system(size: answerfontsize - 2))
                        .foregroundColor(NORMAL_GRAY_COLOR)
                    
                }
            }
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
    }
}
