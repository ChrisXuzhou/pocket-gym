//
//  WorkoutfinishView.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/5/11.
//

import SwiftUI

struct WorkoutfinishView_Previews: PreviewProvider {
    static var previews: some View {
        let timer = Trainingtimer()
        let mockedworkout = mockworkout()

        let model = Workoutmodel(
            mockedworkout
        )

        DisplayedView {
            WorkoutfinishView(present: .constant(true), workoutname: "")
                .environmentObject(TrainingpreferenceDefinition())
                .environmentObject(model)
                .environmentObject(timer)
                .environmentObject(Trainingmodel())
                .onAppear {
                    timer.start()
                }
        }
    }
}

struct WorkoutfinishView: View {
    @EnvironmentObject var preference: PreferenceDefinition

    @EnvironmentObject var trainingmodel: Trainingmodel
    @EnvironmentObject var trainingpreference: TrainingpreferenceDefinition
    @EnvironmentObject var trainingtimer: Trainingtimer
    @EnvironmentObject var model: Workoutmodel

    @Binding var present: Bool
    @State var workoutname: String

    var uptab: some View {
        UptabHeaderView(present: $present, title: "saveworkout") {
        }
        .padding(.horizontal)
    }

    var workoutnameview: some View {
        VStack {
            HStack {
                Pencile(imgsize: 16)
                    .foregroundColor(NORMAL_BUTTON_COLOR)
                    .offset(y: 2)

                TextField(
                    "\(preference.language("workoutname"))",
                    text: $workoutname,
                    onEditingChanged: { begin in
                        if !begin {
                            self.model.savename(workoutname)
                        }
                    }
                )
                .foregroundColor(NORMAL_LIGHTER_COLOR)
                .keyboardType(.default)
                .submitLabel(.done)

                SPACE
            }
            .font(.system(size: DEFINE_FONT_SIZE).bold())
            .padding()
        }
    }

    var datatab: some View {
        Workoutupdatalabel(workoutid: model.workout.id!)
            .padding(.horizontal)
    }

    var begintimetab: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let _begintime = model.workout.begintime {
                HStack {
                    LocaleText("begintime")
                        .font(.system(size: DEFINE_FONT_SMALL_SIZE - 2).bold())
                        .foregroundColor(NORMAL_GRAY_COLOR)

                    SPACE
                }

                HStack(spacing: 15) {
                    LocaleText(_begintime.systemedyearmonthdate)
                    LocaleText(_begintime.displayedonlytime)
                    SPACE
                }
                .font(.system(size: DEFINE_FONT_SMALL_SIZE).bold())
                .foregroundColor(preference.theme)
            }
        }
        .frame(height: 80)
        .padding(.horizontal)
    }

    @State var showclosingconfirmdialog = false
    var savebutton: some View {
        Button {
            endtraining()
        } label: {
            Floatingbutton(label: "save", fontcolor: .white, color: preference.theme)
        }
        .confirmationDialog(
            Text(preference.language("completetraining") + "?"),
            isPresented: $showclosingconfirmdialog,
            titleVisibility: .visible
        ) {
            Button {
                endtraining()
            } label: {
                LocaleText("OK")
            }
        }
    }

    @State var showdiscardingconfirmdialog = false
    var discardbutton: some View {
        Button {
            endtraining(discard: true)
        } label: {
            Floatingbutton(label: "discard", fontcolor: NORMAL_RED_COLOR, color: NORMAL_BG_GRAY_COLOR)
        }
        .confirmationDialog(
            Text(preference.language("discardtraining") + "?"),
            isPresented: $showdiscardingconfirmdialog,
            titleVisibility: .visible
        ) {
            Button {
                endtraining(discard: true)
            } label: {
                LocaleText("OK")
            }
        }
    }

    var opbuttons: some View {
        VStack(spacing: 10) {
            savebutton

            discardbutton
        }
        .padding(.horizontal, 10)
    }

    var body: some View {
        ZStack {
            NORMAL_BG_COLOR.ignoresSafeArea()

            VStack(spacing: 0) {
                uptab

                workoutnameview

                datatab

                begintimetab

                SPACE

                opbuttons
            }
        }
        .ignoresSafeArea(.keyboard)
        .onTapGesture {
            endtextediting()
        }
    }

    func endtraining(discard: Bool = false) {
        trainingtimer.stop()

        trainingmodel.stop(discard: discard)
    }
}

class Workoutnameeditor: Texteditor {
    var workout: Workout

    init(_ workout: Workout) {
        self.workout = workout
    }

    func save(_ newvalue: String?) {
        var _workout = workout
        _workout.name = newvalue
        try! AppDatabase.shared.saveworkout(&_workout)
    }
}
