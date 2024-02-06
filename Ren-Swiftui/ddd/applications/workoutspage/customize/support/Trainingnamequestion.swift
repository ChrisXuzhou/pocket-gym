//
//  Trainingnamequestion.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/30.
//

import SwiftUI

struct Trainingnamequestion_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Trainingnamequestion(present: .constant(true))
                .environmentObject(CustomizeModel())
        }
    }
}

struct Trainingnamequestion: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var model: CustomizeModel

    @Binding var present: Bool

    init(present: Binding<Bool>) {
        _present = present
        log("init training name view")
    }

    var uptab: some View {
        VStack {
            UptabHeaderView(present: $present) {
            }
            .padding(.horizontal)
            .ignoresSafeArea(.keyboard)

            SPACE
        }
        .ignoresSafeArea(.keyboard)
    }

    var selectionview: some View {
        VStack {
            // Exercisevideo().padding(.bottom)

            Answertextfield(
                title: preference.language("name"),
                answer: $model.name
            )
            .contentShape(Rectangle())
            .ignoresSafeArea(.keyboard)
        }
    }

    var nextbutton: some View {
        Button {
            model.backandpresent()
        } label: {
            Floatingbutton(
                label: "customizeyourplan",
                disabled: model.name.isEmpty,
                color: preference.theme
            )
            .padding(.vertical, NORMAL_CUSTOMIZE_BUTTON_VSPACING).padding(.horizontal)
        }
        .disabled(model.name.isEmpty)
    }

    var contentview: some View {
        VStack(spacing: 0) {
            SPACE.frame(height: MIN_UP_TAB_HEIGHT)

            Question("pleasenametheplan")

            selectionview
                .padding(.vertical, NORMAL_CUSTOMIZE_UP_VSPACING)

            SPACE

            nextbutton
        }
        .ignoresSafeArea(.keyboard)
    }

    var body: some View {
        ZStack {
            
            NORMAL_BG_COLOR.ignoresSafeArea()
            
            contentview
            
            uptab
        }
        .onTapGesture {
            endtextediting()
        }
        .ignoresSafeArea(.keyboard)
    }
}
