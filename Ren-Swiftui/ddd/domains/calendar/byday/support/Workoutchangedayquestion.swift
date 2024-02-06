//
//  Workoutchangedayquestion.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/7/18.
//

import SwiftUI

struct Workoutchangedayquestion_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Workoutchangedayquestion(present: .constant(false))
        }
    }
}

struct Workoutchangedayquestion: View {
    @EnvironmentObject var templatemodel: Workoutandeachlogmodel
    @EnvironmentObject var preference: PreferenceDefinition

    @Binding var present: Bool
    @State var startdate: Date = Date()

    var uptab: some View {
        VStack {
            UptabHeaderView(present: $present) {
            }
            .padding(.horizontal)

            SPACE
        }
    }

    @State var showselectdateview = false
    var selectionview: some View {
        VStack {
            Exercisevideo()
                .padding(.bottom)

            Answerinput(
                answer: startdate.displayedyearmonthdate,
                descriptor: "",
                focused: showselectdateview
            )
            .contentShape(Rectangle())
            .onTapGesture {
                showselectdateview = true
            }
            .sheet(isPresented: $showselectdateview) {
                DatepickerView(selecteddate: $startdate)
                    .environmentObject(preference)
            }
            .padding(.horizontal)
        }
    }

    func confirm() {
        let _workoutid = templatemodel.workout.id!

        var _workoutday = startdate
        _workoutday = Calendar.current.date(byAdding: .second, value: +5, to: _workoutday) ?? Date()

        templatemodel.workout.workday = _workoutday

        try! AppDatabase.shared.saveworkout(&templatemodel.workout)

        DispatchQueue.main.async {
            let analysisedmuscles = AppDatabase.shared.queryAnalysisedmuscles(workoutid: _workoutid)
            var _analysisedmuscles: [Analysisedmuscle] = []
            for var analysised in analysisedmuscles {
                analysised.workday = _workoutday
                _analysisedmuscles.append(analysised)
            }
            try! AppDatabase.shared.saveAnalysisedmuscles(&_analysisedmuscles)

            let analysisedexercises = AppDatabase.shared.queryAnalysisedexerciselist(workoutid: _workoutid)
            var _analysisedexercises: [Analysisedexercise] = []
            for var analysised in analysisedexercises {
                analysised.workday = startdate
                _analysisedexercises.append(analysised)
            }
            try! AppDatabase.shared.saveAnalysisedexerciselist(&_analysisedexercises)
        }

        present = false
    }

    var confirmbutton: some View {
        Button {
            confirm()
        } label: {
            Floatingbutton(
                label: "confirm",
                disabled: false,
                color: preference.theme
            )
            .padding(.vertical, NORMAL_CUSTOMIZE_BUTTON_VSPACING).padding(.horizontal)
        }
    }

    var contentview: some View {
        VStack {
            SPACE.frame(height: MIN_UP_TAB_HEIGHT)

            Question("changedate")

            selectionview
                .padding(.vertical, NORMAL_CUSTOMIZE_UP_VSPACING)

            SPACE

            confirmbutton
        }
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
