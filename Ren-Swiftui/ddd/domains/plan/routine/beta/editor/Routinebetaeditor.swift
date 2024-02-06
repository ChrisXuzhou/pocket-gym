//
//  Routinebetaeditor.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/9/30.
//

import SwiftUI

struct Routinebetaeditor_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            ContentView()
        }
    }
}

class Routinebetaeditorvalues: ObservableObject {
    @Published var name: String

    init(_ routine: Routine) {
        name = routine.displayedname(PreferenceDefinition.shared)
    }
}

struct Routinebetaeditor: View {
    @Environment(\.presentationMode) var present
    @EnvironmentObject var preference: PreferenceDefinition

    @ObservedObject var routine: Routine
    @ObservedObject var values: Routinebetaeditorvalues

    var preferedfolderid: Int64?
    var callback: () -> Void

    init(_ routine: Routine,
         preferedfolderid: Int64? = nil,
         callback: @escaping () -> Void = { }) {
        self.routine = routine
        self.preferedfolderid = preferedfolderid
        self.callback = callback

        values = Routinebetaeditorvalues(routine)
    }

    /*
     * function variables
     */

    var fontcolor: Color = NORMAL_LIGHTER_COLOR
    @FocusState var namefocused: Bool
    @StateObject var addexerciseswitch = Viewopenswitch()
    @StateObject var selectfolderswitch = Viewopenswitch()

    /*
     * library usage.
     */
    @StateObject var usage: Libraryusage = Libraryusage(usage: .forselect, libraryaction: Libraryaddexerciseaction())

    var contentlayer: some View {
        VStack(spacing: 0) {
            sheetupheader

            ScrollView(.vertical, showsIndicators: false) {
                namepanel.padding(.top)

                routinebatchspanel

                SPACE.frame(height: UIScreen.height / 2)
            }

            SPACE
        }
    }

    var operatelayer: some View {
        VStack {
            SPACE

            addroutinebutton
        }
    }

    var body: some View {
        NavigationView {
            ZStack {
                NORMAL_BG_COLOR.ignoresSafeArea()

                contentlayer

                operatelayer
                    .ignoresSafeArea(.keyboard)
            }
            .environmentObject(routine)
            .onTapGesture {
                release()
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
    }
}

extension Routinebetaeditor {
    var namepanel: some View {
        VStack(alignment: .leading) {
            bartitle("routinename")
                .padding(.horizontal)

            HStack {
                TextField(
                    "\(preference.language("editroutinename"))",
                    text: $values.name,
                    onEditingChanged: { begin in
                        if !begin {
                            self.routine.routine.name = values.name
                        }
                    }
                )
                .focused($namefocused)
                .font(.system(size: DEFINE_FONT_SMALL_SIZE))
                .foregroundColor(NORMAL_LIGHT_TEXT_COLOR)
                .keyboardType(.default)
                .submitLabel(.done)

                SPACE
            }
            .multilineTextAlignment(.leading)
            .padding(.horizontal)
            .frame(minHeight: 70)
            .contentShape(Rectangle())
            .onTapGesture {
                namefocused = true
            }
            .background(NORMAL_BG_CARD_COLOR)
        }
    }

    var routinebatchspanel: some View {
        VStack(alignment: .leading) {
            bartitle("exerciselist")
                .padding(.horizontal)

            if routine.batchs.isEmpty {
                VStack(spacing: 30) {
                    LocaleText("emptyworkoutreminder", alignment: .leading)

                    SPACE
                }
                .font(.system(size: DEFINE_FONT_SMALL_SIZE - 1, design: .rounded))
                .foregroundColor(NORMAL_LIGHT_TEXT_COLOR)
                .padding(.horizontal)
                .opacity(0.6)
            }

            VStack {
                ForEach(0 ..< routine.batchs.count, id: \.self) {
                    idx in

                    Routinebetabatchpanel(editing: true, batch: routine.batchs[idx])
                        .padding(.bottom, 12)
                        .padding(.horizontal)
                        .background(
                            NORMAL_BG_CARD_COLOR
                        )
                }
            }
        }
    }

    var addroutinebutton: some View {
        HStack {
            SPACE
            Button {
                endtextediting()

                addexerciseswitch.value = true
            } label: {
                HStack(spacing: 5) {
                    Image(systemName: "plus")
                        .font(.system(size: DEFINE_FONT_SMALLER_SIZE).weight(.heavy))
                    LocaleText("addexercises", uppercase: true)
                }
                .font(.system(size: DEFINE_FONT_SMALL_SIZE).bold())
                .foregroundColor(preference.theme)
            }
            SPACE
        }
        .frame(height: MIN_DOWN_TAB_HEIGHT)
        .background(
            NORMAL_UPTAB_BACKGROUND_COLOR
        )
        .fullScreenCover(isPresented: $addexerciseswitch.value) {
            NavigationView {
                LibraryaddView(workoutaction: routine) {
                    addexerciseswitch.value = false
                }
                .environmentObject(TrainingpreferenceDefinition.shared)
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
            }
        }
    }
}

extension Routinebetaeditor {
    var sheetupheader: some View {
        HStack(alignment: .lastTextBaseline) {
            Button {
                withAnimation {
                    present.wrappedValue.dismiss()
                }
            } label: {
                LocaleText("cancel")
                    .foregroundColor(NORMAL_LIGHTER_COLOR)
                    .font(.system(size: DEFINE_FONT_SMALL_SIZE))
                    .frame(width: SHEET_BUTTON_WIDTH, alignment: .leading)
            }

            SPACE

            Button {
                self.routine.routine.name = values.name

                if let _preferedid = preferedfolderid {
                    routine.routine.folderid = _preferedid
                }

                routine.save()
                callback()
                present.wrappedValue.dismiss()
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
        .background(NORMAL_BG_CARD_COLOR.ignoresSafeArea())
    }
}

extension Routinebetaeditor {
    func release() {
        endtextediting()
    }
}

extension Routine: Workoutaction {
    func select(_ exercisedefs: [Newdisplayedexercise], batchtype: Batchtype, weightunit: Weightunit) {
        for def in exercisedefs {
            addexercises([def], type: batchtype)
        }
    }

    func batchselect(_ exerciselist: [Newdisplayedexercise], batchtype: Batchtype, weightunit: Weightunit) {
        addexercises(exerciselist, type: batchtype)
    }

    func close() {
        // nothing
    }
}
