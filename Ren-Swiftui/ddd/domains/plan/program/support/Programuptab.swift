//
//  Planprogramdetailuptab.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/22.
//


import SwiftUI

class Viewedit: ObservableObject {
    @Published var value: Bool = false
    
    init(_ editing: Bool = false) {
        self.value = editing
    }
}

class Editviewmore: ObservableObject {
    @Published var value: Bool = false
}

struct Programuptab: View {
    @Environment(\.presentationMode) var presentmode
    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var programmodel: Programmodel

    @Binding var showsummary: Bool

    @EnvironmentObject var editprogram: Viewedit
    @StateObject var moreprogram = Editviewmore()

    var program: Program?

    var color: Color {
        showsummary ? .white : NORMAL_LIGHTER_COLOR
    }

    var uptabview: some View {
        HStack(spacing: 0) {
            let _color = color

            Button {
                presentmode.wrappedValue.dismiss()
            } label: {
                Backarrow(color: _color)
            }
            .padding(.trailing, 10)
            
            SPACE.frame(width: 35)

            SPACE

            if !showsummary {
                LocaleText(program?.programname ?? "", alignment: .center)
                    .font(.system(size: UP_HEADER_TITLE_FONT_SIZE).bold())
            }

            SPACE

            HStack(spacing: 20) {
                Button {
                    editprogram.value = true
                } label: {
                    Pencile(imgsize: 20)
                        .foregroundColor(_color)
                }

                Button {
                    moreprogram.value = true
                } label: {
                    Moreshape(imgsize: 20, color: _color)
                }
            }
        }
    }

    var body: some View {
        uptabview
            .frame(height: MIN_UP_TAB_HEIGHT)
            .padding(.horizontal)
            .background(
                showsummary ? AnyView(Color.clear) : AnyView(NORMAL_UPTAB_BACKGROUND_COLOR)
            )
            .sheet(isPresented: $editprogram.value, content: {
                Programvieweditor(programmodel.program)
            })
            .confirmationDialog("", isPresented: $moreprogram.value) {
                Button("\(preference.language("duplicate"))") {
                    programmodel.duplicate()
                    presentmode.wrappedValue.dismiss()
                }

                Button("\(preference.language("delete"))", role: .destructive) {
                    presentmode.wrappedValue.dismiss()

                    DispatchQueue.global().async {
                        programmodel.delete()
                    }
                }
            }
    }
}

extension Programmodel {
    func delete() {
        if let programid = program.id {
            try! AppDatabase.shared.deleteprogrameach(programid: programid)
            try! AppDatabase.shared.deleteprogram(id: programid)
        }
    }

    func duplicate() {
        let createdtime = Date()

        var duplicatedprogram: Program = program
        duplicatedprogram.id = nil
        duplicatedprogram.createtime = createdtime
        duplicatedprogram.programname = duplicatedprogram.programname + " \(PreferenceDefinition.shared.language("copy", firstletteruppercase: false))"

        try! AppDatabase.shared.saveprogram(&duplicatedprogram)

        let duplicatedprogrameachlist: [Programeach] = programeachlist
        for var each in duplicatedprogrameachlist {
            each.id = nil
            each.createtime = createdtime
            each.programid = duplicatedprogram.id!

            try! AppDatabase.shared.saveprogrameach(&each)
        }
    }
}
