//
//  Trainingdaysquestiion.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/29.
//

import SwiftUI

struct Trainingdaysquestiion_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Trainingdaysquestion(present: .constant(true))
                .environmentObject(CustomizeModel())
        }
    }
}

let TRAINING_DAYS_RANGE_LIST = [Int](1 ... 30)

struct Trainingdaysquestion: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var model: CustomizeModel

    @Binding var present: Bool

    init(present: Binding<Bool>) {
        _present = present
        log("init training days view")
    }

    var uptab: some View {
        UptabHeaderView(present: $present) {
        }
        .padding(.horizontal)
    }

    @State var showselector = false

    var selectionview: some View {
        VStack {
            Exercisevideo()

            let days = preference.language("days")
            
            Answerinput(
                answer: "\(model.days)",
                descriptor: days,
                focused: showselector
            )
            .contentShape(Rectangle())
            .onTapGesture {
                showselector = true
            }
            .sheet(isPresented: $showselector) {
                Intseletctorsheet(
                    selected: $model.days,
                    rangelist: TRAINING_DAYS_RANGE_LIST,
                    rangedescriptor: days
                )
            }
            .padding(.horizontal, 10)
            
        }
    }

    @State var presentnext = false

    var nextbutton: some View {
        NavigationLink(isActive: $presentnext) {
            NavigationLazyView(
                Trainingnamequestion(present: $presentnext)
                    .environmentObject(preference)
                    .environmentObject(model)
                    .navigationBarHidden(true)
                    .navigationBarBackButtonHidden(true)
                    .ignoresSafeArea(.keyboard)
            )
        } label: {
            Floatingbutton(
                label: "next",
                disabled: false,
                color: preference.theme
            )
            .padding(.vertical, NORMAL_CUSTOMIZE_BUTTON_VSPACING).padding(.horizontal)
        }
        .isDetailLink(false)
    }

    var body: some View {
        VStack(spacing: 0) {
            uptab

            Question("howmanytrainingdaysdoesplancontains")

            selectionview
                .padding(.vertical, NORMAL_CUSTOMIZE_UP_VSPACING)

            SPACE

            nextbutton
        }
    }
}
