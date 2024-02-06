


import SwiftUI

struct Workoutviewuptab_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            ContentView()
        }
    }
}

func mockworkout() -> Workout {
    try! AppDatabase.shared.deleteworkout(id: -1)

    try! AppDatabase.shared.deletebatch(id: -1)
    var mockedbatch = mockbatch()
    try! AppDatabase.shared.savebatch(&mockedbatch)

    var mockedworkout = Workout(id: -1,
                                stats: .finished,
                                name: "Sample Workout",
                                begintime: Date(), endTime: Date())
    try! AppDatabase.shared.saveworkout(&mockedworkout)
    return mockedworkout
}

struct Workoutviewuptab: View {
    @EnvironmentObject var preference: PreferenceDefinition

    @EnvironmentObject var trainingmodel: Trainingmodel
    @EnvironmentObject var trainingpreference: TrainingpreferenceDefinition
    @EnvironmentObject var trainingtimer: Trainingtimer
    @EnvironmentObject var model: Workoutmodel

    /*
     * variables
     */
    @Binding var present: Bool
    @State var name: String

    /*
     * States:
     */
    @StateObject var finishlink = Viewopenswitch()
    @FocusState var editworkoutname: Bool

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                    present = false
                } label: {
                    Backarrow()
                        .padding(.trailing, 5)
                }

                namelabel

                SPACE

                if !model.batchnumberdictionary.isEmpty {
                    buttonslabel
                }
            }
            .padding(.horizontal)
            .frame(height: MIN_UP_TAB_HEIGHT)
            .background(background.ignoresSafeArea())
        }
    }

    var background: Color {
        if let _succeed = model.issucceed {
            return _succeed ? NORMAL_GREEN_COLOR.opacity(0.2) : NORMAL_RED_COLOR.opacity(0.2)
        }

        return NORMAL_BG_COLOR
    }
}

extension Workoutviewuptab {
    var namelabel: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .lastTextBaseline, spacing: 5) {
                TextField(
                    "\(preference.language("editworkoutname"))",
                    text: $name,
                    onEditingChanged: { begin in
                        if !begin {
                            self.model.savename(name)
                        }
                    }
                )
                .focused($editworkoutname)
                .font(
                    .system(size: UP_HEADER_TITLE_FONT_SIZE).bold()
                )
                .foregroundColor(NORMAL_LIGHTER_COLOR)
                .keyboardType(.default)
                .submitLabel(.done)

                SPACE
            }
            .contentShape(Rectangle())
            .onTapGesture {
                editworkoutname = true
            }

            if !model.isfinished {
                Trainingtimerlabel(
                    trainingtimer: trainingtimer,
                    fontsize: DEFINE_FONT_SMALLER_SIZE
                )
                .frame(height: 15)
            }
        }
    }

    var buttonslabel: some View {
        HStack {
            if model.workout.isinplan {
                startbutton
            } else {
                finishlinklabel
            }
        }
        .frame(width: 45)
    }

    var finishlinklabel: some View {
        NavigationLink(isActive: $finishlink.value) {
            NavigationLazyView(
                WorkoutfinishView(present: $finishlink.value, workoutname: name)
                    .environmentObject(preference)
                    .environmentObject(model)
                    .environmentObject(trainingmodel)
                    .environmentObject(trainingpreference)
                    .environmentObject(trainingtimer)
                    .navigationBarHidden(true)
                    .navigationBarBackButtonHidden(true)
            )

        } label: {
            HStack(spacing: 0) {
                SPACE
                LocaleText("finish")
                    .font(
                        .system(size: DEFINE_FONT_SIZE - 1)
                            .bold()
                    )
                    .foregroundColor(preference.theme)
                SPACE
            }
        }
        .isDetailLink(false)
    }

    var startbutton: some View {
        Button {
            trainingmodel.start()
        } label: {
            HStack(spacing: 0) {
                SPACE
                LocaleText("start")
                    .font(
                        .system(size: DEFINE_FONT_SIZE - 1)
                            .bold()
                    )
                    .foregroundColor(preference.theme)
                SPACE
            }
        }
    }
}
