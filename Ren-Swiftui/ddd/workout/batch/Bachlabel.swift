//
//  Bachlabel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/5/5.
//
import GRDB
import SwiftUI

struct Batchlabel_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            ContentView()
        }
    }
}

func mocktemplate() -> Workout {
    try! AppDatabase.shared.deleteworkout(id: -1)
    try! AppDatabase.shared.deletebatch(workoutid: -1)
    try! AppDatabase.shared.deletebatchexercisedef(workoutid: -1)

    var mockedworkout = Workout(id: -1, stats: .template, name: "Template")
    try! AppDatabase.shared.saveworkout(&mockedworkout)

    /*
     * batch 2
     */
    var mbatch2 = Batch(id: -2, num: 1, workoutid: -1)
    try! AppDatabase.shared.savebatch(&mbatch2)

    var mockedbatchexercisedefs2: [Batchexercisedef] = [
        Batchexercisedef(workoutid: -1,
                         batchid: -2,
                         exerciseid: 6003, order: 0),
    ]
    try! AppDatabase.shared.savebatchexercisedefs(&mockedbatchexercisedefs2)

    var mockedbatcheachlogs: [Batcheachlog] = [
        Batcheachlog(workoutid: -1, batchid: -2, exerciseid: 6003, num: 0, repeats: 12, weight: 12, weightunit: .kg),
    ]
    try! AppDatabase.shared.savebatcheachlogs(&mockedbatcheachlogs)

    var mbatch3 = Batch(id: -3, num: 2, workoutid: -1)
    try! AppDatabase.shared.savebatch(&mbatch3)

    var mockedbatchexercisedefs3: [Batchexercisedef] = [
        Batchexercisedef(workoutid: -1,
                         batchid: -3,
                         exerciseid: 7009, order: 0),
    ]
    try! AppDatabase.shared.savebatchexercisedefs(&mockedbatchexercisedefs3)

    return mockedworkout
}

func mockbatch() -> Batch {
    Batch(id: -1, num: 0, workoutid: -1)
}

let BATCH_LABEL_BUTTON_COLOR: Color = NORMAL_LIGHTER_COLOR.opacity(0.5)
let BATCH_LABEL_VERTICAL_SPACING: CGFloat = 3

struct Batchlabel: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var trainingpreference: TrainingpreferenceDefinition

    @EnvironmentObject var workoutmodel: Workoutmodel

    @ObservedObject var batchmodel: Batchmodel

    @StateObject var viewmore = Viewmore()
    @StateObject var showreplacelibrary = Viewopenswitch()
    @StateObject var reorderexercises = Viewopenswitch()
    @StateObject var shownoteseditor = Viewopenswitch()

    var unpacked: Bool {
        batchmodel.batch.id == workoutmodel.unpackedbatchid
    }

    var body: some View {
        VStack(spacing: 0) {
            VStack {
                batchlabelheader

                if unpacked {
                    batchlabelcontent
                }
            }
            .background(
                batchlabelbackground
                    .onTapGesture {
                        endtextediting()
                    }
            )
        }
        .environmentObject(batchmodel)
    }

    var batchlabelcontent: some View {
        VStack {
            batchnotelabel

            Rectangle()
                .frame(height: 1)
                .foregroundColor(NORMAL_LIGHT_GRAY_COLOR.opacity(0.3))
                .padding(.horizontal, 5)

            Batchlabelcontent()

            addsetbutton
                .padding(.bottom, 5)
        }
        .environmentObject(batchmodel)
    }

    var batchlabelbackground: some View {
        ZStack {
            NORMAL_BG_CARD_COLOR

            /*
             if batchmodel.isfinished {
                 NORMAL_GREEN_COLOR.opacity(0.1)
             }
             */
        }
    }
}

extension Batchlabel {
    var batchlabelheader: some View {
        HStack(spacing: 5) {
            Batchexerciselable()
                .contentShape(Rectangle())
                .onTapGesture {
                    workoutmodel.refreshpackbatchid(batchmodel.batch.id)
                }

            bottonslabel
        }
        .padding(.horizontal, 10)
        .padding(.vertical, BATCH_LABEL_VERTICAL_SPACING)
    }

    var bottonslabel: some View {
        HStack {
            opbuttons
        }
        .fullScreenCover(isPresented: $reorderexercises.value) {
            Batchlistreorderview(batchs: workoutmodel.asbatchslist(), fetcher: workoutmodel) {
                newbatchs in

                workoutmodel.refresh(newbatchs)
                var _newbatchs = newbatchs

                DispatchQueue.global().async {
                    if !_newbatchs.isEmpty {
                        try! AppDatabase.shared.savebatchs(&_newbatchs)
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $showreplacelibrary.value) {
            NavigationView {
                LibraryreplaceView {
                    libraryusage in

                    batchmodel.replaceexercises(
                        libraryusage.libraryaction?.selectedarray ?? [],
                        weightunit: trainingpreference.weightunit
                    )

                    showreplacelibrary.value = false
                }
                .environmentObject(batchmodel)
                .environmentObject(TrainingpreferenceDefinition.shared)
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
            }
        }
    }
}

extension Workoutmodel: Batchnumber2batchexercisedefsfetcher {
    func fetch(_ num: Int) -> [Batchexercisedef] {
        if let _batchmodel = batchnumberdictionary[num]?.first {
            return _batchmodel.orderedbatchexercisedefs.map({ $0.batchexercisedef })
        }
        return []
    }
}

extension Batchlabel {
    var displayednote: String {
        var display = batchmodel.batch.batchnote ?? "addnotehere"
        display = display.isEmpty ? "addnotehere" : display

        return display
    }

    var batchnotelabel: some View {
        VStack {
            HStack {
                LocaleText(displayednote)
                    .foregroundColor(BATCH_LABEL_BUTTON_COLOR)
                    .font(.system(size: DEFINE_FONT_SMALLER_SIZE + 1))

                SPACE
            }
            .padding(.horizontal)
            .padding(.vertical, 2)
            .contentShape(Rectangle())
            .onTapGesture {
                shownoteseditor.value = true
            }
            .fullScreenCover(isPresented: $shownoteseditor.value, content: {
                TexteditorView(
                    value: batchmodel.batch.batchnote ?? "",
                    title: preference.language("addnotehere"),
                    editor: batchmodel
                )
            })
        }
    }

    var packbutton: some View {
        Button {
            workoutmodel.refreshpackbatchid(batchmodel.batch.id)
        } label: {
            Image(systemName: unpacked ? "chevron.up" : "chevron.down")
                .font(.system(size: DEFINE_BUTTON_FONT_SMALL_SIZE - 3).bold())
                .foregroundColor(
                    unpacked ?
                        preference.theme : NORMAL_GRAY_COLOR
                )
                .frame(width: 30, height: 40)
        }
    }

    var morebutton: some View {
        Button {
            viewmore.value = true
        } label: {
            Moreshape(imgsize: 16, color: NORMAL_LIGHTER_COLOR)
                .frame(width: 30, height: 40)
        }
        .confirmationDialog("", isPresented: $viewmore.value) {
            Button("\(preference.language("replaceexercise"))") {
                showreplacelibrary.value = true
            }

            Button("\(preference.language("reorderexercise"))") {
                reorderexercises.value = true
            }

            Button("\(preference.language("duplicateexercise"))") {
                copybatch()
            }

            Button("\(preference.language("delete"))", role: .destructive) {
                deletebatch()
            }
        }
    }

    var replacebutton: some View {
        Button {
            showreplacelibrary.value = true
        } label: {
            Replace(size: 17)
                .frame(width: 30, height: 40)
        }
    }

    var modifybuttons: some View {
        HStack(spacing: 0) {
            replacebutton

            Button {
                movebatchdown()
            } label: {
                Downarrow()
                    .frame(width: 33, height: 40)
            }

            Button {
                copybatch()
            } label: {
                Copy()
                    .frame(width: 33, height: 40)
            }

            Button {
                deletebatch()
            } label: {
                Delete()
                    .foregroundColor(NORMAL_RED_COLOR)
                    .frame(width: 33, height: 40)
            }
        }
        .foregroundColor(BATCH_LABEL_BUTTON_COLOR)
    }

    var opbuttons: some View {
        HStack(spacing: 0) {
            morebutton
        }
    }

    var addsetbutton: some View {
        Button {
            batchmodel.newbatcheachlogs(trainingpreference.weightunit)

            endtextediting()
        } label: {
            HStack {
                SPACE

                Image(systemName: "plus")
                    .font(.system(size: DEFINE_FONT_SMALLER_SIZE).weight(.heavy))

                LocaleText("addset", uppercase: true)

                SPACE
            }
            .foregroundColor(preference.theme)
            .font(.system(size: DEFINE_FONT_SMALLER_SIZE, design: .rounded).weight(.heavy))
            .frame(height: 40)
        }
    }
}

/*
  batch action
 */
extension Batchlabel {
    func movebatchdown() {
        /*

             var batch = batch
             var batchnumbertoswitch: Int = batch.num
             if batch.num < workoutmodel.maxbatchnumber ?? 0 {
                 batchnumbertoswitch = batch.num + 1
             }
             if batch.num == batchnumbertoswitch {
                 return
             }
             var batchtoswitch: Batch = batch
             for eachbatch in workoutmodel.batchlist {
                 if eachbatch.num == batchnumbertoswitch {
                     batchtoswitch = eachbatch
                     break
                 }
             }
             if batch == batchtoswitch {
                 return
             }

             batchtoswitch.num = batch.num
             batch.num = batchnumbertoswitch
             var toswitchlist = [batchtoswitch, batch]
             try! AppDatabase.shared.savebatchlist(&toswitchlist)

         */
    }

    func copybatch() {
        workoutmodel.duplicate(batchmodel, weightunit: trainingpreference.weightunit)
    }

    func deletebatch() {
        workoutmodel.deletebatch(number: batchmodel.batch.num)
    }

    /*
     func switchwarmup() {
         var batch = batch
         if batch.type == .warmup {
             batch.type = .workout
         } else {
             batch.type = .warmup
         }
         try! AppDatabase.shared.savebatch(&batch)
     }
     */
}

extension Batchmodel: Texteditor {
    func save(_ newvalue: String?) {
        batch.batchnote = newvalue

        try! AppDatabase.shared.savebatch(&batch)
    }
}

/*
 var batchexerciselabels: some View {
     VStack(spacing: 3) {
         ForEach(0 ..< batchexerciseandeachloglist.count, id: \.self) {
             idx in
             let each = batchexerciseandeachloglist[idx]
             Batchexerciselable(
                 exercise: each.0,
                 batcheachloglist: each.1
             )
             .id(idx)
         }
     }
 }

 */
