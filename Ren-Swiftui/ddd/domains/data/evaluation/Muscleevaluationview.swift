//
//  Muscleevaluationview.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/10/26.
//


import SwiftUI

struct Muscleevaluationview: View {
    @EnvironmentObject var preference: PreferenceDefinition

    @Environment(\.presentationMode) var presentmode
    @StateObject var libraryexercise: Libraryexercisemodel

    /*
     * variables
     */
    @Binding var present: Bool
    @StateObject var libraryusage = Libraryusage(usage: .forview, libraryaction: Libraryaddexerciseaction())

    let muscleid: String

    init(_ muscleid: String, present: Binding<Bool>) {
        self.muscleid = muscleid
        _present = present

        _libraryexercise = StateObject(wrappedValue: Libraryexercisemodel(Set<String>([muscleid])))
    }

    var body: some View {
        ZStack {
            contentlayer

            // operationlayer
        }
        .environmentObject(libraryusage)
        .environmentObject(libraryexercise)
    }
}

extension Muscleevaluationview {
    var contentlayer: some View {
        VStack(spacing: 0) {
            uptabheader
            
            LOCAL_DIVIDER

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    hintpanel

                    Libraryexercisecontent()
                }
            }
        }
    }

    var operationlayer: some View {
        VStack {
            SPACE

            if let _array = libraryusage.libraryaction?.selectedarray {
                if !_array.isEmpty {
                    Muscleevaluationbutton()
                        .shadow(color: preference.themesecondarycolor, radius: 8)
                } else {
                    Muscleevaluationbutton(buttoncolor: NORMAL_GRAY_COLOR, disabled: true)
                        .shadow(color: NORMAL_CARD_SHADDOW_COLOR, radius: 8)
                }
            } else {
                Muscleevaluationbutton(buttoncolor: NORMAL_GRAY_COLOR, disabled: true)
                    .shadow(color: NORMAL_CARD_SHADDOW_COLOR, radius: 8)
            }
        }
    }
}

extension Muscleevaluationview {
    var uptabheader: some View {
        HStack {
            Button {
                present = false
                presentmode.wrappedValue.dismiss()
            } label: {
                CLOSE_IMG
            }
            .padding(.trailing, 10)

            SPACE

            LocaleText(muscleid)
                .font(.system(size: UP_HEADER_TITLE_FONT_SIZE).bold())
                .foregroundColor(NORMAL_LIGHTER_COLOR)

            SPACE

            SPACE.frame(width: 28)
        }
        .frame(height: MIN_UP_TAB_HEIGHT)
        .padding(.horizontal)
        .background(
            NORMAL_BG_CARD_COLOR.ignoresSafeArea()
        )
    }

    var hintpanel: some View {
        HStack(spacing: 0) {
            Text(preference.languagewithplaceholder("workoutsuggestionsdesc", value: preference.language(muscleid)))
                .multilineTextAlignment(.center)
                .lineSpacing(5)

            SPACE
        }
        .foregroundColor(NORMAL_LIGHTER_COLOR)
        .font(.system(size: DEFINE_FONT_SMALLER_SIZE + 1))
        .padding(.horizontal)
        .padding(.top)
    }
}

struct Muscleevaluationbutton: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var libraryusage: Libraryusage

    @StateObject var presetstartsheet = Viewopenswitch()

    var fontsize: CGFloat = DEFINE_FONT_SMALL_SIZE
    var width: CGFloat = UIScreen.width
    var height: CGFloat = LIBRARY_DOWNBAR_HEIGHT
    var buttoncolor: Color? = nil
    var isrounded: Bool = false
    var disabled: Bool = false

    var _buttoncolor: Color {
        if disabled {
            return NORMAL_GRAY_COLOR
        }

        if let _buttoncolor: Color = buttoncolor {
            return _buttoncolor
        } else {
            return preference.theme
        }
    }

    var body: some View {
        Button {
            presetstartsheet.value = true
        } label: {
            HStack {
                SPACE

                LocaleText("training")
                    .foregroundColor(.white)
                    .font(.system(size: fontsize).bold())

                SPACE
            }
            .frame(width: width, height: height)
            .background(
                VStack {
                    if isrounded {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundColor(_buttoncolor)
                    } else {
                        _buttoncolor
                    }
                }.ignoresSafeArea()
            )
        }
        .disabled(disabled)
        /*
         .partialSheet(isPresented: $presetstartsheet.value, iPhoneStyle: .themeStyle()) {
             Muscleevaluationtrainingsheet(present: $presetstartsheet.value)
                 .environmentObject(preference)
                 .environmentObject(libraryusage)
         }
         */
    }
}



struct Muscleevaluationtrainingsheet: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var trainingmodel: Trainingmodel
    @EnvironmentObject var libraryusage: Libraryusage

    @Binding var present: Bool

    /*
     * variables
     */
    @StateObject var showresultreminder = Viewopenswitch()
    @StateObject var presentquestion = Viewopenswitch()

    init(present: Binding<Bool>) {
        _present = present
    }

    func startnow() {
        let newedworkout =
            Workoutcreater(libraryusage.libraryaction?.selectedarray ?? [])
                .buildaplanworkout(preference.ofweightunit, name: "")

        _ = trainingmodel.opentraining(newedworkout, preference: preference)

        present = false
    }

    func makeaplan() {
        presentquestion.value.toggle()
    }

    var starbarview: some View {
        HStack(spacing: 10) {
            SPACE

            Button {
                makeaplan()
            } label: {
                Imagetextbutton(
                    img: Image("schedule").renderingMode(.template),
                    imgcolor: NORMAL_COLOR,
                    text: "makeaplan",
                    width: 120
                )
                .frame(width: BUTTON_START_WIDTH)
            }
            .fullScreenCover(isPresented: $presentquestion.value) {
                Muscletrainingmakeaplanquestion(present: $presentquestion.value) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        showresultreminder.value = true
                    }
                }
                .environmentObject(libraryusage)
                .environmentObject(preference)
            }

            Divider().padding(.horizontal, 5).frame(height: 40)

            Button {
                startnow()
            } label: {
                Imagetextbutton(
                    img: Image(systemName: "play.circle.fill"),
                    imgsize: 25,
                    imgcolor: NORMAL_COLOR,
                    text: "startnow",
                    width: 120
                )
                .frame(width: BUTTON_START_WIDTH)
            }

            SPACE
        }
        .frame(height: START_BAR_HEIGHT)
    }

    var body: some View {
        VStack {
            starbarview
        }
        .alert("\(preference.language("workoutsetreminder"))", isPresented: $showresultreminder.value) {
            Button("OK", role: .cancel) { }
        }
    }
}

struct Muscletrainingmakeaplanquestion: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var trainingmodel: Trainingmodel
    @EnvironmentObject var libraryusage: Libraryusage

    @Binding var present: Bool
    @State var startdate: Date = Date()

    var callback: () -> Void = {}

    /*
     * variables
     */

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
        present = false

        _ =
            Workoutcreater(libraryusage.libraryaction?.selectedarray ?? [])
                .buildaplanworkout(preference.ofweightunit, name: "", planday: startdate)
    }

    var confirmbutton: some View {
        Button {
            confirm()

            callback()
        } label: {
            Floatingbutton(
                label: "confirm",
                disabled: false,
                color: preference.theme
            )
            .padding(.vertical, NORMAL_CUSTOMIZE_BUTTON_VSPACING)
            .padding(.horizontal)
        }
    }

    var contentview: some View {
        VStack {
            SPACE.frame(height: MIN_UP_TAB_HEIGHT)

            Question("chooseyourtrainingdate")

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
