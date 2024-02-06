//
//  Batchlistreorderview.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/8/29.
//

import SwiftUI

protocol Batchnumber2batchexercisedefsfetcher {
    
    func fetch(_ num: Int) -> [Batchexercisedef]
    
}

struct Batchlistreorderview: View {
    @Environment(\.presentationMode) var presentmode

    @EnvironmentObject var preference: PreferenceDefinition

    @State var batchs: [Batch]
    var fetcher: Batchnumber2batchexercisedefsfetcher
    var reordered: (_ batchs: [Batch]) -> Void = { _ in }

    var upheader: some View {
        HStack {
            Button {
                presentmode.wrappedValue.dismiss()
            } label: {
                Backarrow()
            }
            .padding(.trailing, 10)

            SPACE

            LocaleText("reorder")

            SPACE
            
            SPACE.frame(width: 30)
        }
        .foregroundColor(NORMAL_LIGHTER_COLOR)
        .font(.system(size: UP_HEADER_TITLE_FONT_SIZE).bold())
        .frame(height: MIN_UP_TAB_HEIGHT)
        .padding(.horizontal)
        .background(
            NORMAL_BG_COLOR.ignoresSafeArea()
        )
    }

    var oplayer: some View {
        VStack {
            SPACE

            Button {
                presentmode.wrappedValue.dismiss()

                DispatchQueue.main.async {
                    save()
                }
            } label: {
                LocaleText("finish")
                    .foregroundColor(.white)
                    .font(.system(size: LIBRARY_ADDBUTTON_SIZE).bold())
                    .frame(width: LIBRARY_DOWNBAR_WIDTH, height: LIBRARY_DOWNBAR_HEIGHT)
                    .background(
                        RoundedRectangle(cornerRadius: LIBRARY_BUTTON_CORNER_RADIUS)
                            .foregroundColor(preference.theme)
                    )
            }
        }
    }

    var body: some View {
        ZStack {
            NORMAL_BG_COLOR.ignoresSafeArea()

            VStack(spacing: 0) {
                upheader

                List {
                    ForEach(batchs, id: \.id) {
                        batch in

                        let exercisedefs = exercisedefs(number: batch.num)

                        HStack(spacing: 5) {
                            if exercisedefs.count == 1 {
                                if let _exercisedef = exercisedefs.first?.ofexercisedef {
                                    Exerciselabelvideo(
                                        exercise: _exercisedef,
                                        lablewidth: 50,
                                        lableheight: 30
                                    )

                                    LocaleText(_exercisedef.realname)
                                        .foregroundColor(NORMAL_LIGHTER_COLOR)
                                        .font(
                                            .system(size: DEFINE_FONT_SMALLER_SIZE, design: .rounded)
                                                .bold()
                                        )

                                    SPACE
                                }
                            } else {
                                ForEach(exercisedefs, id: \.id) {
                                    exercisedef in
                                    if let _exercisedef = exercisedef.ofexercisedef {
                                        Exerciselabelvideo(
                                            exercise: _exercisedef,
                                            lablewidth: 50,
                                            lableheight: 30
                                        )
                                    }
                                }
                            }
                        }
                    }
                    .onMove(perform: move)
                    .onDelete(perform: delete)
                }
                .environment(\.editMode, .constant(.active))
            }

            oplayer
        }
    }
}

extension Batchlistreorderview {
    func save() {
        var newbatchs: [Batch] = []
        var num = 0
        for var eachnewbatch in batchs {
            eachnewbatch.num = num
            num += 1
            newbatchs.append(eachnewbatch)
        }

        reordered(newbatchs)
    }

    func move(from source: IndexSet, to destination: Int) {
        batchs.move(fromOffsets: source, toOffset: destination)
    }

    func delete(at offsets: IndexSet) {
        let batchstodelete = offsets.map { self.batchs[$0] }

        for var batch in batchstodelete {
            if let batchid = batch.id {
                DispatchQueue.global().async {
                    try! AppDatabase.shared.deletebatch(&batch)
                    try! AppDatabase.shared.deletebatchexercisedef(batchid: batchid)
                    try! AppDatabase.shared.deletebatcheachlog(batchid: batchid)
                }
            }
        }

        batchs.remove(atOffsets: offsets)
    }

    func exercisedefs(number: Int) -> [Batchexercisedef] {
        fetcher.fetch(number) ?? []
    }
}
