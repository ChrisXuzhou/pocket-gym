//
//  Vieweditor.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/7/11.
//


import SwiftUI

struct Programvieweditor_Previews: PreviewProvider {
    static var previews: some View {
        let mockedworkout = mockworkout()
        let mockedprogrameachlist = mockprogrameachlist()
        let mockedprograms: [Program] = mockprogramlist()

        DisplayedView {
            Programvieweditor(mockedprograms[0])
        }
        .environmentObject(Programmodel(mockedprograms[0]))
    }
}

class Vieweditlevel: ObservableObject {
    @Published var value: Bool = false
}

class Vieweditdays: ObservableObject {
    @Published var value: Bool = false
}

class Vieweditdescription: ObservableObject {
    @Published var value: Bool = false
}

class Programeditormodel: ObservableObject {
    init(_ program: Program) {
        name = PreferenceDefinition.shared.language(program.programname)
        programlevel = program.programlevel
        days = program.days
        description = PreferenceDefinition.shared.language(program.programdescription ?? "")

        self.program = program

        programeachlist = AppDatabase.shared.queryprogrameachlist(program.id!)
        daynum2programeachlist = Dictionary(grouping: programeachlist, by: { $0.daynum })
    }

    var program: Program?

    @Published var name: String
    @Published var programlevel: Programlevel
    @Published var days: Int = 0
    @Published var description: String

    var addedprogrameachid: Int64 = -99

    /*
     * program content related
     */
    var addedprogrameachlist: [Programeach] = []
    var deletedprogrameachlist: [Programeach] = []
    var programeachlist: [Programeach]

    @Published var daynum2programeachlist: [Int: [Programeach]]
}

extension Programeditormodel {
    func save() {
        if var _program = program {
            _program.programname = name
            _program.programlevel = programlevel
            _program.days = days
            _program.programdescription = description

            try! AppDatabase.shared.saveprogram(&_program)
        }

        if !deletedprogrameachlist.isEmpty {
            try! AppDatabase.shared.deleteprogrameachs(programeachs: deletedprogrameachlist)
        }

        if !addedprogrameachlist.isEmpty {
            for var programeach in addedprogrameachlist {
                programeach.id = nil
                try! AppDatabase.shared.saveprogrameach(&programeach)
            }
        }
    }
}

struct Programvieweditor: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @Environment(\.presentationMode) var present

    @StateObject var editormodel: Programeditormodel

    @FocusState private var editingname: Bool

    @StateObject var editinglevel = Vieweditlevel()
    @StateObject var editingdays = Vieweditdays()
    @StateObject var editingdescription = Vieweditdescription()

    func release() {
        if editingname {
            editingname = false
        }
    }

    init(_ program: Program) {
        _editormodel = StateObject(wrappedValue: Programeditormodel(program))
    }

    var contentlayer: some View {
        VStack(spacing: 0) {
            sheetupheader

            ScrollView(.vertical, showsIndicators: false) {
                programnamelabel

                levelview

                daysview

                plandescriptionview

                workoutpreview

                SPACE.frame(height: MIN_UP_TAB_HEIGHT)
            }
        }
        .environmentObject(editormodel)
    }

    var body: some View {
        ZStack {
            NORMAL_BG_COLOR.ignoresSafeArea()

            contentlayer
        }
        .onTapGesture {
            release()
        }
    }
}

extension Programvieweditor {
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
                withAnimation {
                    editormodel.save()
                    present.wrappedValue.dismiss()
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
}

extension Programvieweditor {
    var programnamelabel: some View {
        HStack {
            TextField("\(preference.language("name"))",
                      text: $editormodel.name
            )
            .focused($editingname)
            .font(.system(size: DEFINE_FONT_SMALL_SIZE).bold())
            .foregroundColor(NORMAL_LIGHTER_COLOR)
            .keyboardType(.default)
            .submitLabel(.done)
        }
        .multilineTextAlignment(.leading)
        .padding(.horizontal)
        .frame(minHeight: 50)
        .background(
            NORMAL_BG_CARD_COLOR
        )
        .contentShape(Rectangle())
        .onTapGesture {
            editingname = true
        }
    }
}

extension Programvieweditor {
    /*
     * program level
     */
    var levelview: some View {
        Listitemlabel(keyortitle: "fitnesslevel",
                     value: "\(preference.language(editormodel.programlevel.rawValue, firstletteruppercase: false))"
        ) {
        }
        .contentShape(Rectangle())
        .onTapGesture {
            release()
            editinglevel.value = true
        }
        .sheet(isPresented: $editinglevel.value) {
            Fitnessleveleditor(level: $editormodel.programlevel)
        }
    }
}

extension Programvieweditor {
    /*
     * program days
     */
    var daysview: some View {
        Listitemlabel(keyortitle: "daysnumber",
                     value: "\(editormodel.days)"
        ) {
        }
        .contentShape(Rectangle())
        .onTapGesture {
            release()
            editingdays.value = true
        }
        .sheet(isPresented: $editingdays.value, content: {
            Intseletctorsheet(
                selected: $editormodel.days,
                rangelist: TRAINING_DAYS_RANGE_LIST,
                rangedescriptor: preference.language("days")
            )
        })
    }
}

extension Programvieweditor {
    /*
     * description
     */
    var plandescriptionview: some View {
        VStack {
            let description: String = preference.language(editormodel.description)

            VStack(alignment: .leading) {
                HStack {
                    LocaleText("description", usefirstuppercase: false, linelimit: 1)
                        .font(.system(size: DEFINE_FONT_SMALL_SIZE - 1))
                        .frame(alignment: .leading)
                        .foregroundColor(NORMAL_COLOR)

                    SPACE
                }
                .padding(.vertical, 5)

                if !description.isEmpty {
                    Text(description)
                        .tracking(0.6)
                        .lineLimit(30)
                        .minimumScaleFactor(0.01)
                        .multilineTextAlignment(.leading)
                        .lineSpacing(4)
                        .font(.system(size: DEFINE_FONT_SMALLER_SIZE - 1))
                        .foregroundColor(NORMAL_LIGHTER_COLOR)
                        .padding(.vertical, 5)
                }
            }
            .padding()
            .background(
                NORMAL_BG_CARD_COLOR
            )
            .contentShape(Rectangle())
            .onTapGesture {
                release()
                editingdescription.value = true
            }
            .sheet(isPresented: $editingdescription.value) {
                TexteditorbetaView(
                    value: $editormodel.description,
                    title: preference.language("description")
                )
            }
        }
    }
}

extension Programvieweditor {
    /*
     * workout preview
     */
    var workoutpreview: some View {
        VStack {
            HStack {
                LocaleText("workoutpreview", usefirstuppercase: false, linelimit: 1)
                    .font(.system(size: DEFINE_FONT_SMALL_SIZE - 1))
                    .frame(alignment: .leading)
                    .foregroundColor(NORMAL_COLOR)

                SPACE
            }
            .padding(.vertical)
            .padding(.top, 5)

            Programeacheditlist()
        }
        .padding(.horizontal)
        .background(
            NORMAL_BG_CARD_COLOR
        )
    }
}
