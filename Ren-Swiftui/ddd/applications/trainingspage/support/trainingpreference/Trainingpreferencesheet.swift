//
//  Trainingpersonalsheet.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/9.
//


import SwiftUI

struct Trainingpreferencesetting_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Trainingpreferencesheet(mockworkout())
                .environmentObject(TrainingpreferenceDefinition())
        }
    }
}

let SHEET_BUTTON_WIDTH: CGFloat = 100

struct Trainingpreferencesheet: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var trainingpreference: TrainingpreferenceDefinition

    @Environment(\.presentationMode) var present

    @StateObject var model: Trainingpreferencesheetmodel

    init(_ workout: Workout) {
        _model = StateObject(wrappedValue: Trainingpreferencesheetmodel(workout))
    }

    var cancelbutton: some View {
        Button {
            withAnimation {
                present.wrappedValue.dismiss()
            }
        } label: {
            Backarrow()
        }
        .foregroundColor(NORMAL_LIGHTER_COLOR)
    }

    var uptabview: some View {
        HStack(alignment: .lastTextBaseline) {
            cancelbutton
            SPACE

            LocaleText("trainingpreferencesettings")
                .font(.system(size: DEFINE_FONT_SMALL_SIZE).bold())
                .foregroundColor(NORMAL_LIGHTER_COLOR)

            SPACE
            Backarrow().hidden()
        }
        .frame(height: SHEET_HEADER_HEIGHT)
        .padding(.horizontal)
        .background(NORMAL_BG_CARD_COLOR.ignoresSafeArea())
    }

    @State var editingweightunit = false
    var weightunitview: some View {
        Listitemlabel( // img: Image("dumbbell"),
            imgsize: 18,
            keyortitle: preference.language(LANGUAGE_WEIGHTUNIT),
            value: trainingpreference.weightunit.name
        ) {
        }
        .onTapGesture {
            editingweightunit.toggle()
            workoutnameeditorfocused = false
        }
    }

    func save(_ newweightunit: Weightunit) {
        // do nothing.
        // trainingpreference.workoutmodel?.switchweightunit(newweightunit)
    }

    @State var showintervalrestseditor = false
    var intervalrestsecondsview: some View {
        Listitemlabel( // img: Image("clock"),
            imgsize: 18,
            keyortitle: preference.language(LANGUAGE_INTERVALRESTSECONDS),
            value: "\(trainingpreference.intervalrestinsecs)"
        ) {}
            .onTapGesture {
                showintervalrestseditor.toggle()
                workoutnameeditorfocused = false
            }
            .fullScreenCover(isPresented: $showintervalrestseditor) {
                TextfieldditorView(textfield: .number,
                                   value: "\(trainingpreference.intervalrestinsecs)",
                                   title: preference.language("restime"),
                                   editor: trainingpreference)
            }
    }

    var finishbuttonswitch: some View {
        Listitemlabel(
            // img: Image("check"),
            imgsize: 16,
            keyortitle: preference.language(LANGUAGE_TRAINING_USE_FINISHBUTTON)
        ) {
            Toggle(
                "",
                isOn: $trainingpreference.isusingcheckbutton
            )
            .toggleStyle(
                SwitchToggleStyle(tint: preference.themeprimarycolor)
            )
        }
    }

    var batchnotesview: some View {
        HStack(spacing: 0) {
            Warmup()
                .foregroundColor(NORMAL_WARMUP_COLOR)
                .padding(.horizontal)

            LocaleText("warmupnote", usefirstuppercase: false)
                .foregroundColor(NORMAL_GRAY_COLOR)
                .font(.system(size: DEFINE_FONT_SMALLER_SIZE))

            SPACE
        }
        .padding(.top)
    }

    var trainingpreferenceview: some View {
        VStack {
            HStack {
                bartitle("trainingpreference")
                SPACE
            }
            .padding(.top)
            .padding(.horizontal)

            weightunitview

            intervalrestsecondsview

            finishbuttonswitch

            batchnotesview
        }
    }

    var workoutnameview: some View {
        VStack {
            HStack {
                bartitle("workoutname")
                SPACE
            }
            .padding(.top)
            .padding(.horizontal)

            inputtab
        }
    }

    @FocusState var workoutnameeditorfocused: Bool
    var inputtab: some View {
        HStack {
            TextField("", text: $model.workoutname,
                      onEditingChanged: { _ in
                          model.save()
                      }
            )
            .font(.system(size: DEFINE_FONT_SMALL_SIZE - 1))
            .frame(alignment: .leading)
            .foregroundColor(NORMAL_COLOR)
            .focused($workoutnameeditorfocused)
            .keyboardType(.default)
            .submitLabel(.done)

            SPACE

            if workoutnameeditorfocused {
                Button {
                    model.workoutname = ""
                } label: {
                    Image(systemName: "multiply.circle.fill")
                        .foregroundColor(Color(.systemGray4))
                }
            }
        }
        .padding(.horizontal)
        .frame(height: LIST_ITEM_HEIGHT)
        .contentShape(Rectangle())
        .onTapGesture {
            workoutnameeditorfocused = true
        }
        .background(NORMAL_BG_CARD_COLOR)
    }

    var body: some View {
        ZStack {
            NORMAL_BG_COLOR.ignoresSafeArea()

            VStack {
                uptabview

                ScrollView(.vertical, showsIndicators: false) {
                    // move 'workout name' outside
                    // workoutnameview

                    trainingpreferenceview

                    SPACE.frame(height: UIScreen.height / 3)
                }
            }
            .onTapGesture {
                endtextediting()
            }
        }
    }
}
