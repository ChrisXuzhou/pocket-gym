//
//  Exercisevieweditor.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/6/3.
//


import SwiftUI

struct Exercisevieweditor_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Exercisevieweditor(Libraryexercisemodel.shared.all.first!)
        }
    }
}

struct Exercisevieweditor: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @Environment(\.presentationMode) var presentmode

    init(_ exercise: Newdisplayedexercise, header: String = "editexercise",
         callback: @escaping (_ exercise: Newdisplayedexercise) -> Void = { _ in }) {
        title = header

        let copied = exercise.exercise
        originexercise = exercise
        self.exercise = Newdisplayedexercise(copied)

        // name
        _exercisename = .init(initialValue: copied.name ?? "")

        self.callback = callback
    }

    var originexercise: Newdisplayedexercise
    @ObservedObject var exercise: Newdisplayedexercise

    /*
     * function variables
     */
    var title: String

    var callback: (_ exercise: Newdisplayedexercise) -> Void

    /*
     * exercise name related.
     */
    @State var exercisename: String = ""
    @FocusState var exercisepanelisfocused: Bool

    /*
     * options
     */
    @StateObject var targetareaswitch = Viewopenswitch()
    @StateObject var equipmentswitch = Viewopenswitch()
    @StateObject var logtypeswitch = Viewopenswitch()
    @StateObject var weighttypeswitch = Viewopenswitch()

    var body: some View {
        ZStack {
            NORMAL_BG_COLOR.ignoresSafeArea()

            VStack {
                upheader

                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        bartitle("details").padding(.horizontal)

                        exercisenamepanel
                    }

                    VStack {
                        bartitle("options").padding(.horizontal)

                        targetareapanel

                        equipmentpanel

                        logcontentpanel

                        weightmultiplyerpanel
                    }
                }

                SPACE
            }
        }
        .onTapGesture {
            endtextediting()
        }
    }
}

extension Exercisevieweditor {
    func save() {
        /*
         * 1. save exercse
         */
        exercise.exercise.name = exercisename
        if exercise.exercise.ident.isEmpty {
            exercise.exercise.ident = exercisename.lowercased().replacingOccurrences(of: " ", with: "_")
        }

        try! AppDatabase.shared.saveNewexercisedef(&exercise.exercise)

        /*
         * 2、exercise backup
         */
        if let _exerciseid = exercise.exercise.exerciseid {
            DispatchQueue.global().async {
                Backupadaptor.shared.saveExercise(_exerciseid)
            }
        }

        /*
         * 3、callback to origin exercise
         */
        originexercise.exercise = exercise.exercise

        /*
         * 4、notify view refresh
         */
        originexercise.objectWillChange.send()

        presentmode.wrappedValue.dismiss()

        callback(originexercise)
    }
}

/*
 * upheader
 */
extension Exercisevieweditor {
    /*
     * op header
     */
    var upheader: some View {
        HStack(alignment: .lastTextBaseline) {
            Button {
                withAnimation {
                    presentmode.wrappedValue.dismiss()
                }
            } label: {
                LocaleText("cancel")
                    .foregroundColor(NORMAL_LIGHTER_COLOR)
                    .font(.system(size: DEFINE_FONT_SMALL_SIZE))
                    .frame(width: SHEET_BUTTON_WIDTH, alignment: .leading)
            }

            SPACE

            LocaleText(title)
                .font(.system(size: UP_HEADER_TITLE_FONT_SIZE))
                .foregroundColor(NORMAL_COLOR)

            SPACE

            Button {
                withAnimation {
                    save()
                }
            } label: {
                Text(preference.language("save"))
                    .foregroundColor(preference.theme)
                    .font(.system(size: DEFINE_FONT_SMALL_SIZE))
                    .frame(width: SHEET_BUTTON_WIDTH, alignment: .trailing)
            }
        }
        .font(.system(size: DEFINE_SHEET_FONT_SIZE))
        .padding(.horizontal)
        .frame(height: SHEET_HEADER_HEIGHT)
        .background(NORMAL_BG_CARD_COLOR)
    }

    /*
     * exercise name editor
     */
    var exercisenamepanel: some View {
        HStack {
            TextField(
                "\(preference.language("exercisename"))",
                text: $exercisename
            )
            .font(.system(size: DEFINE_FONT_SMALL_SIZE))
            .frame(alignment: .leading)
            .foregroundColor(NORMAL_LIGHTER_COLOR)
            .focused($exercisepanelisfocused)
            .keyboardType(.default)
            .submitLabel(.done)

            SPACE

            if exercisepanelisfocused {
                Button {
                    exercisename = ""
                } label: {
                    Image(systemName: "multiply.circle.fill")
                        .foregroundColor(NORMAL_BUTTON_COLOR)
                }
            }
        }
        .padding(.horizontal)
        .frame(height: LIST_ITEM_HEIGHT)
        .contentShape(Rectangle())
        .onTapGesture {
            exercisepanelisfocused = true
        }
        .background(NORMAL_BG_CARD_COLOR)
    }

    /*
     * opntions
     */
    var targetareapanel: some View {
        Listitemlabel(
            imgsize: 18,
            keyortitle: "targetarea",
            value: exercise.displaytargetarea(preference),
            showarrow: false
        ) {
        }
        .background {
            NORMAL_BG_CARD_COLOR
        }
        .contentShape(Rectangle())
        .onTapGesture {
            targetareaswitch.value.toggle()
        }
        .sheet(isPresented: $targetareaswitch.value) {
            Muscleselectorsheet(
                present: $targetareaswitch.value, exercise.focusedtargetarea) {
                selectedgroup, selectedmain in

                if !selectedgroup.isEmpty && selectedgroup != "any" {
                    exercise.exercise.displayedgroupid = selectedgroup
                }

                if selectedgroup == "any" {
                    exercise.exercise.displayedgroupid = ""
                }

                if !selectedmain.isEmpty && selectedmain != "any" {
                    exercise.exercise.displayedprimaryid = selectedmain
                }

                if selectedmain == "any" {
                    exercise.exercise.displayedprimaryid = ""
                }

                exercise.objectWillChange.send()
            }
        }
    }

    var equipmentpanel: some View {
        Listitemlabel(
            imgsize: 18,
            keyortitle: LANGUAGE_EQUIPMENT,
            value: exercise.displayequipments(preference),
            showarrow: false
        ) {
        }
        .background {
            NORMAL_BG_CARD_COLOR
        }
        .id(exercise.exercise.equipmentidx)
        .contentShape(Rectangle())
        .onTapGesture {
            equipmentswitch.value.toggle()
        }
        .sheet(isPresented: $equipmentswitch.value) {
            Equipmentselectorsheet(
                present: $equipmentswitch.value,
                selected: $exercise.exercise.equipmentidx,
                header: "anytype",
                options: EQUIPMENTS
            ) {
                selected in

                if !selected.isEmpty && selected != "any" {
                    exercise.exercise.equipmentidx = selected
                } else {
                    exercise.exercise.equipmentidx = ""
                }

                exercise.objectWillChange.send()
            }
        }
    }

    var logcontentpanel: some View {
        Listitemlabel(
            keyortitle: "logcontent",
            value: preference.language(exercise.exercise.logtype.rawValue),
            showarrow: false
        ) {
        }
        .background {
            NORMAL_BG_CARD_COLOR
        }
        .contentShape(Rectangle())
        .onTapGesture {
            logtypeswitch.value.toggle()
        }
        .sheet(isPresented: $logtypeswitch.value) {
            Logtypeselectorsheet(
                present: $logtypeswitch.value,
                selected: exercise.exercise.logtype.rawValue
            ) { selected in

                exercise.exercise.logtype = Logtype(rawValue: selected) ?? .repsandweight

                logtypeswitch.value = false
            }
        }
    }

    var weightmultiplyerpanel: some View {
        Listitemlabel(
            keyortitle: "volumemultiplier",
            value: "x\(preference.language(exercise.exercise.weighttype.label))",
            showarrow: false
        ) {
        }
        .background {
            NORMAL_BG_CARD_COLOR
        }
        .contentShape(Rectangle())
        .onTapGesture {
            weighttypeswitch.value.toggle()
        }
        .sheet(isPresented: $weighttypeswitch.value) {
            Weightmultiplyerselectorsheet(
                present: $weighttypeswitch.value,
                selected: exercise.exercise.weighttype
            ) { selected in

                exercise.exercise.weighttype = selected //Caculateweight(rawValue: selected) ?? .single

                weighttypeswitch.value = false
            }
        }
    }
}
