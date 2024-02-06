//
//  Fitnesslevelquestion.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/29.
//

import SwiftUI

struct Fitnesslevelquestion_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Fitnesslevelquestion(present: .constant(true))
        }
        .environmentObject(CustomizeModel())
    }
}

struct Fitnesslevelquestion: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var model: CustomizeModel

    @Binding var present: Bool
    
    
    init(present: Binding<Bool>) {
        self._present = present
        log("init fitness view")
    }

    var uptab: some View {
        UptabHeaderView(present: $present) {
        }
        .padding(.horizontal)
    }

    var selectionview: some View {
        VStack {
            Answerselection(
                answer: Programlevel.beginner.rawValue,
                description: Programlevel.beginner.description,
                focused: model.level == .beginner
            )
            .onTapGesture {
                model.level = .beginner
            }

            Answerselection(
                answer: Programlevel.intermediate.rawValue,
                description: Programlevel.intermediate.description,
                focused: model.level == .intermediate
            )
            .onTapGesture {
                model.level = .intermediate
            }

            Answerselection(
                answer: Programlevel.advanced.rawValue,
                description: Programlevel.advanced.description,
                focused: model.level == .advanced
            )
            .onTapGesture {
                model.level = .advanced
            }
        }
        .padding(.horizontal)
    }

    @State var presentnext = false
    var nextbutton: some View {
        
        Button {
            model.backandpresent()
        } label: {
            Floatingbutton(
                label: "confirm",
                disabled: model.level == nil,
                color: preference.theme
            )
            .padding(.vertical, NORMAL_CUSTOMIZE_BUTTON_VSPACING).padding(.horizontal)
        }
        .disabled(model.level == nil)

        
    }

    var body: some View {
        VStack(spacing: 0) {
            uptab

            Question("describethefitnesslevel")

            selectionview.padding(.vertical, NORMAL_CUSTOMIZE_UP_VSPACING)

            SPACE

            nextbutton
        }
    }
}
