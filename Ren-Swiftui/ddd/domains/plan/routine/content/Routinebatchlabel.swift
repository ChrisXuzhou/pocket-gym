//
//  Routinebatcheachloggrouplabel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/17.
//

import SwiftUI

struct Routinebatchlabel_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            VStack {
            }
        }

        /*

         var mockedbatcheachlog = mockbatcheachlog()
         var mockedbatchexercisedef = mockbatchexercisedef()
         var mockedbatch = Batch(id: -1, num: 0, workoutid: -1)

         let mockedworkout = mockworkout()

         DisplayedView {
             ZStack {
                 ScrollView {
                     VStack(spacing: 3) {
                         Routinebatchlabel(
                             editing: false,
                             routinetype: .setsweightandreps,
                             batch: mockedbatch,
                             batchexercisedeflist: [mockedbatchexercisedef],
                             batcheachloglist: [mockedbatcheachlog]
                         )

                         Routinebatchlabel(
                             editing: true,
                             routinetype: .setsandreps,
                             batch: mockedbatch,
                             batchexercisedeflist: [mockedbatchexercisedef],
                             batcheachloglist: [mockedbatcheachlog]
                         )

                         Routinebatchlabel(
                             editing: false,
                             routinetype: .setsandreps,
                             batch: mockedbatch,
                             batchexercisedeflist: [mockedbatchexercisedef],
                             batcheachloglist: [mockedbatcheachlog]
                         )

                         Routinebatchlabel(
                             editing: true,
                             routinetype: .setsweightandreps,
                             batch: mockedbatch,
                             batchexercisedeflist: [mockedbatchexercisedef],
                             batcheachloglist: [mockedbatcheachlog]
                         )

                         SPACE
                     }
                 }
             }
             .environmentObject(TrainingpreferenceDefinition())
             .environmentObject(Routineviewmodel(state: .template))
             .environmentObject(Workoutandeachlogmodel(mockedworkout))
         }

         */
    }
}

class Showreplacelibrary: ObservableObject {
    @Published var value: Bool = false
}

class Shownoteseditor: ObservableObject {
    @Published var value: Bool = false
}

struct Routinebatchlabel: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var viewmodel: Routineviewmodel
    @EnvironmentObject var workoutmodel: Workoutandeachlogmodel

    var editing: Bool
    var routinetype: Routinetype

    init(editing: Bool = false,
         routinetype: Routinetype,
         batch: Batch,
         batchexercisedeflist: [Batchexercisedef],
         batcheachloglist: [Batcheachlog]) {
        self.editing = editing
        self.routinetype = routinetype

        routinebatchmodel = Routinebatchmodel(batch: batch,
                                              batchexercisedeflist: batchexercisedeflist,
                                              batcheachloglist: batcheachloglist
        )

        UITextView.appearance().backgroundColor = .clear
    }

    @ObservedObject var routinebatchmodel: Routinebatchmodel
    @StateObject var showreplacelibrary = Showreplacelibrary()
    @StateObject var shownoteseditor = Shownoteseditor()

    var body: some View {
        VStack(spacing: 0) {
            let _bgcolor =
                routinebatchmodel.batch.type == .warmup ?
                NORMAL_WARMUP_COLOR.opacity(0.2) : Color.clear

            VStack(alignment: .leading, spacing: 0) {
                let _exercisedefs: [Newdisplayedexercise] = routinebatchmodel.relatedexerciselist

                // displaybatchheader(_exercisedefs)

                if routinetype == .setsandreps {
                    let count = routinebatchmodel.batchexercisedeflist.count
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(0 ..< count, id: \.self) {
                            idx in

                            Batchexerciserangelabel(
                                editing: editing,
                                displayexercisename: count > 1,
                                batchexercisedef: routinebatchmodel.batchexercisedeflist[idx],
                                sets: $routinebatchmodel.batchexercisedeflist[idx].sets,
                                minreps: $routinebatchmodel.batchexercisedeflist[idx].minreps,
                                maxreps: $routinebatchmodel.batchexercisedeflist[idx].maxreps
                            )
                        }
                    }
                }

                /*
                 * exercise content [start]
                 */
                if routinetype == .setsweightandreps {
                    if viewmodel.state != .template && editing {
                        displaybatchnotes
                    }

                    let showexercisename: Bool = routinebatchmodel.relatedexerciselist.count > 1

                    /*
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(routinebatchmodel.relatedexerciselist, id: \.id) {
                            exercise in

                            VStack(alignment: .leading, spacing: 2) {
                                if showexercisename {
                                    LocaleText(exercise.realname)
                                        .font(.system(size: DEFINE_FONT_SMALLER_SIZE - 2))
                                        .foregroundColor(NORMAL_LIGHTER_COLOR)
                                }
                                if editing {
                                    Exerciselabelvideo(
                                    // Exerciselabelimgandvideo(
                                        exercise: exercise,
                                        showlink: true,
                                        showexercisedetailink: true,
                                        lablewidth: 120,
                                        lableheight: 60
                                    )

                                    displayededitablebatchlabels(exercise)

                                    addsetbuttonlabel
                                } else {
                                    Exerciselabelvideo(
                                        // Exerciselabelimgandvideo(
                                        exercise: exercise,
                                        showlink: true,
                                        showexercisedetailink: true,
                                        lablewidth: 120,
                                        lableheight: 60
                                    )

                                    displayedbatchlabels(exercise)
                                }
                            }
                        }
                    }
                    
                    */
                }
                /*
                 * exercise content [end]
                 */
            }
            .padding(.leading)
            .padding(.trailing, 5)
            .background(
                ZStack {
                    NORMAL_BG_CARD_COLOR
                    _bgcolor
                }
            )

            if editing {
                modifybarlabel
                    .background(
                        ZStack {
                            NORMAL_BG_CARD_COLOR
                            _bgcolor
                        }
                    )
                    .padding(.top, 1)
            }
        }
        .environmentObject(routinebatchmodel)
    }
}

class Routinebatchtexteditor: Texteditor {
    func save(_ newtext: String?) {
        batch.batchnote = newtext
        try! AppDatabase.shared.savebatch(&batch)
    }

    init(_ batch: Batch) {
        self.batch = batch
    }

    var batch: Batch
}

/*
 * result & workout routine related.
 */
extension Routinebatchlabel {
    var displaybatchnotes: some View {
        HStack {
            let _batchnote: String = routinebatchmodel.batch.batchnote ?? ""

            if !_batchnote.isEmpty {
                LocaleText(_batchnote, linelimit: 10)
            } else {
                LocaleText("addnotehere", linelimit: 10)
            }
        }
        .foregroundColor(NORMAL_BUTTON_COLOR)
        .font(.system(size: DEFINE_FONT_SMALLER_SIZE))
        .padding(.bottom)
        .padding(.leading, 5)
        .contentShape(Rectangle())
        .onTapGesture {
            if editing {
                shownoteseditor.value.toggle()
            }
        }
        .sheet(isPresented: $shownoteseditor.value) {
            TexteditorView(
                value: routinebatchmodel.batch.batchnote ?? "",
                title: preference.language("note"),
                editor: Routinebatchtexteditor(routinebatchmodel.batch)
            )
        }
    }

    var displayexerciseslabels: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top) {
                ForEach(routinebatchmodel.relatedexerciselist, id: \.exercise.id) {
                    exercise in

                    Exerciselabelvideo(
                    //Exerciselabelimgandvideo(
                        exercise: exercise,
                        showlink: true,
                        showexercisedetailink: true,
                        lablewidth: 120,
                        lableheight: 60
                    )
                }
            }
        }
    }

    func displaynumlabel(_ batcheachlog: Batcheachlog) -> some View {
        HStack {
            let type = batcheachlog.oftype
            if type == .workout {
                Text("\(batcheachlog.num + 1)")
                    .foregroundColor(NORMAL_GRAY_COLOR)
            } else if type == .warmup {
                LocaleText("warmupshort")
                    .foregroundColor(type.color)
            } else {
                let _text =
                    type == .failure ? "falureshort" : "dropshort"
                LocaleText(_text)
                    .foregroundColor(type.color)
            }
        }
        .font(
            .system(size: DEFINE_FONT_SMALLEST_SIZE,
                    design: .rounded)
                .bold()
        )
        .padding(.leading, 10)
        .frame(width: ROUTINE_BATCHEACHLOG_EMPTY_SPACING)
    }

    func displayedbatchlabels(_ exercise: Exercisedef) -> some View {
        VStack(spacing: 5) {
            if let _first = routinebatchmodel.batcheachloglist.first {
                HStack {
                    SPACE.frame(width: ROUTINE_BATCHEACHLOG_EMPTY_SPACING)
                    Routinelogcontenttitle(weightunit: _first.weightunit)
                    SPACE
                }
            }

            let numberedbatcheachlogs = routinebatchmodel.relatedbatcheachlogs(exercise.id!)
            if !numberedbatcheachlogs.isEmpty {
                ForEach(numberedbatcheachlogs, id: \.id) {
                    batcheachlog in

                    HStack(spacing: 0) {
                        displaynumlabel(batcheachlog)

                        LocaleText("\(batcheachlog.repeats)")
                            .frame(width: DEFAULT_ROUTINE_CONTENT_EACH_WIDTH, height: DEFAULT_ROUTINE_CONTENT_EACH_HEIGHT)

                        LocaleText("\(batcheachlog.weight)")
                            .frame(width: DEFAULT_ROUTINE_CONTENT_EACH_WIDTH, height: DEFAULT_ROUTINE_CONTENT_EACH_HEIGHT)

                        HStack {
                            if let _rest = batcheachlog.rest {
                                Text(_rest.displayminuts)
                            }
                        }
                        .frame(width: DEFAULT_ROUTINE_CONTENT_EACH_WIDTH, height: DEFAULT_ROUTINE_CONTENT_EACH_HEIGHT)

                        SPACE

                        if viewmodel.state == .workout {
                            Check(finished: batcheachlog.state == .finished)
                        }
                    }
                    .foregroundColor(NORMAL_LIGHTER_COLOR.opacity(0.7))
                    .font(.system(size: DEFINE_FONT_SMALLER_SIZE))
                    .background(
                        batcheachlog.num % 2 == 0 ? NORMAL_GRAY_COLOR.opacity(0.1) : Color.clear
                    )
                }
            }
        }
        .padding(.bottom)
    }

    func displayededitablebatchlabels(_ exercise: Exercisedef) -> some View {
        VStack(spacing: 3) {
            if let _first = routinebatchmodel.batcheachloglist.first {
                HStack {
                    SPACE.frame(width: ROUTINE_BATCHEACHLOG_EMPTY_SPACING)
                    Routinelogcontenttitle(editing: true, weightunit: _first.weightunit)
                    SPACE
                }
            }

            let numberedbatcheachlogs = routinebatchmodel.relatedbatcheachlogs(exercise.id!)
            if !numberedbatcheachlogs.isEmpty {
                ForEach(numberedbatcheachlogs, id: \.id) {
                    batcheachlog in

                    Routinebatcheachloglabel(
                        batcheachlog: Batcheachlogwrapper(batcheachlog),
                        showexercisename: false
                    )
                }
            }
        }
    }

    var addsetbuttonlabel: some View {
        Button {
            createneweachloglist()

            endtextediting()
        } label: {
            HStack {
                SPACE

                LocaleText("addset")

                SPACE
            }
            .foregroundColor(.white)
            .font(.system(size: LIBRARY_ADDBUTTON_SIZE).bold())
            .frame(height: 40)
            .background(
                RoundedRectangle(cornerRadius: LIBRARY_BUTTON_CORNER_RADIUS)
                    .foregroundColor(NORMAL_LIGHT_GRAY_COLOR)

                // NORMAL_LIGHT_GRAY_COLOR.opacity(0.3)
            )
            .padding(.top)
        }
    }
}

extension Batcheachlog {
    var displayedstr: String {
        var temp: String = PreferenceDefinition.shared.language("beacheachlogstr", firstletteruppercase: false)
        temp = temp
            .replacingOccurrences(of: "{NUM}", with: "\(num + 1)")
            .replacingOccurrences(of: "{REPS}", with: "\(repeats)")
            .replacingOccurrences(of: "{WEIGHT}", with: "\(weight)")
            .replacingOccurrences(of: "{WEIGHTUNIT}", with: "\(weightunit)")

        return temp
    }
}

extension Routinebatchlabel {
    func displaybatchheader(_ _exercisedefs: [Newdisplayedexercise]) -> some View {
        HStack(spacing: 0) {
            Exercisetitle(exerciselist: _exercisedefs, fontsize: DEFINE_FONT_SMALLER_SIZE)

            SPACE
        }
        .frame(height: 40)
    }
}

struct Routinebatchlabeleditoropbutton: View {
    var img: String
    var imgsize: CGFloat = 17
    var color: Color = .gray

    var labeltext: String
    var labeltextfontsize: CGFloat = DEFINE_FONT_SMALLER_SIZE - 4

    var body: some View {
        VStack(spacing: 5) {
            Image(img)
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: imgsize, height: imgsize, alignment: .center)

            LocaleText(labeltext, linelimit: 2,
                       tracking: 0.5,
                       linespacing: 0)
                .font(.system(size: labeltextfontsize))
        }
        .padding(.horizontal, 5)
        .frame(width: (UIScreen.width - 40) / 6)
        .foregroundColor(color)
    }
}

extension Routinebatchmodel: Workoutaction {
    func replaceabatch(_ batch: Batchmodel, _ exerciselist: [Newdisplayedexercise], weightunit: Weightunit) {
        /*
         let batch = self.batch

         if exerciselist.isEmpty {
             return
         }

         let workoutid = batch.workoutid

         // delete
         let batchtodeletebatchid = batch.id!
         try! AppDatabase.shared.deletebatchexercisedef(batchid: batchtodeletebatchid)
         try! AppDatabase.shared.deletebatcheachlog(batchid: batchtodeletebatchid)

         var exercisedef: Int = 0
         for exercise in exerciselist {
             // 1
             var batchexercisedef: Batchexercisedef =
                 Batchexercisedef(
                     workoutid: workoutid,
                     batchid: batch.id!,
                     exerciseid: exercise.id!,
                     order: exercisedef
                 )
             try! AppDatabase.shared.savebatchexercisedef(&batchexercisedef)
             exercisedef += 1

             // 2
             var newbatcheachloglist =
                 Batcheachlog.Builder.buildBatcheachlogs(batch,
                                                         exerciseid: exercise.id!,
                                                         weightunit: weightunit)
             try! AppDatabase.shared.savebatcheachlogs(&newbatcheachloglist)
         }

         */

        // modified()
    }

    func select(_ exerciselist: [Newdisplayedexercise],
                batchtype: Batchtype = .workout, weightunit: Weightunit) {
        // do nothing
    }

    func batchselect(_ exerciselist: [Newdisplayedexercise],
                     batchtype: Batchtype = .workout, weightunit: Weightunit) {
        // do nothing.
    }

    func close() {
        // do nothing.
    }
}

/*
 * routine action usage.
 */
extension Routinebatchlabel {
    var modifybarlabel: some View {
        modifybuttons
    }

    var modifybuttons: some View {
        HStack(alignment: .top, spacing: 0) {
            Button {
                routinebatchmodel.switchwarmup()
            } label: {
                Routinebatchlabeleditoropbutton(
                    img: "calorie",
                    color: routinebatchmodel.batch.type == .warmup ? NORMAL_YELLOW_COLOR : .gray,
                    labeltext: "warmup"
                )
            }

            Button {
                showreplacelibrary.value.toggle()
            } label: {
                Routinebatchlabeleditoropbutton(img: "replace", labeltext: "replaceexerciseshort")
            }

            Button {
                movebatchdown()
            } label: {
                Routinebatchlabeleditoropbutton(img: "downarrow", labeltext: "movedownshort")
            }

            Button {
                copybatch()
            } label: {
                Routinebatchlabeleditoropbutton(img: "copy", labeltext: "duplicate")
            }

            SPACE

            Button {
                deletebatch()
            } label: {
                Routinebatchlabeleditoropbutton(img: "delete",
                                                color: .red,
                                                labeltext: "delete")
            }
        }
        .padding(.vertical, 20)
        .padding(.leading)
        .fullScreenCover(isPresented: $showreplacelibrary.value) {

        }
    }
}

extension Routinebatchlabel {
    func deletebatch() {
        var batch = routinebatchmodel.batch
        try! AppDatabase.shared.deletebatch(&batch)

        if let batchid = routinebatchmodel.batch.id {
            try! AppDatabase.shared.deletebatchexercisedef(batchid: batchid)
            try! AppDatabase.shared.deletebatcheachlog(batchid: batchid)
        }

        reorderbatchlistnumbers(batch.workoutid)
    }

    public func createneweachloglist() {
        DispatchQueue.main.async {
            _ = creatnewbatcheachloglist(preference.ofweightunit)
        }
    }

    func creatnewbatcheachloglist(_ weightunit: Weightunit) -> Batcheachlog? {
        var createdbatcheachloglist: [Batcheachlog] = []
        let nextNum = (routinebatchmodel.maxnumber ?? -1) + 1

        if routinebatchmodel.batcheachloglist.isEmpty {
            for each in routinebatchmodel.batchexercisedeflist {
                let newedbatcheachlog = Batcheachlog(workoutid: routinebatchmodel.batch.workoutid,
                                                     batchid: routinebatchmodel.batch.id!,
                                                     exerciseid: each.exerciseid,
                                                     num: nextNum,
                                                     repeats: 0, weight: 0,
                                                     weightunit: weightunit)

                createdbatcheachloglist.append(newedbatcheachlog)
            }
        } else {
            let lastbatcheachloglist: [Batcheachlog] = routinebatchmodel.maxnumber == nil ? [] : routinebatchmodel.num2batcheachlogs[routinebatchmodel.maxnumber!] ?? []

            for var eachlast in lastbatcheachloglist {
                if Workoutcache.shared.exerciseid == eachlast.exerciseid {
                    if let _reps: Int = Workoutcache.shared.ofreps {
                        eachlast.repeats = _reps
                    }

                    if let _weight: Double = Workoutcache.shared.ofweight {
                        eachlast.weight = _weight
                    }
                }

                let newedbatcheachlog = Batcheachlog(workoutid: routinebatchmodel.batch.workoutid,
                                                     batchid: routinebatchmodel.batch.id!,
                                                     exerciseid: eachlast.exerciseid,
                                                     num: nextNum,
                                                     repeats: eachlast.repeats,
                                                     weight: eachlast.weight,
                                                     weightunit: eachlast.weightunit)

                createdbatcheachloglist.append(newedbatcheachlog)
            }
        }
        if createdbatcheachloglist.isEmpty {
            return nil
        }

        try! AppDatabase.shared.savebatcheachlogs(&createdbatcheachloglist)

        return nil
    }
}

extension Routinebatchlabel {
    func movebatchdown() {
        var batch = routinebatchmodel.batch
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
        try! AppDatabase.shared.savebatchs(&toswitchlist)
    }

    func copybatch() {
        let batch = routinebatchmodel.batch
        let batchnumber = (workoutmodel.maxbatchnumber ?? -1) + 1
        let workoutid = batch.workoutid

        var newedbatch = Batch(num: batchnumber, workoutid: workoutid)
        try! AppDatabase.shared.savebatch(&newedbatch)

        var newedBatchexercisedeflist: [Batchexercisedef] = []
        for each in routinebatchmodel.batchexercisedeflist {
            let newedBatchexercisedef =
                Batchexercisedef(
                    workoutid: workoutid,
                    batchid: newedbatch.id!,
                    exerciseid: each.exerciseid,
                    order: each.order,
                    minreps: each.minreps,
                    maxreps: each.maxreps,
                    sets: each.sets
                )

            newedBatchexercisedeflist.append(newedBatchexercisedef)
        }
        try! AppDatabase.shared.savebatchexercisedefs(&newedBatchexercisedeflist)

        var newedbatcheachloglist: [Batcheachlog] = []
        for batcheachlog in routinebatchmodel.batcheachloglist {
            let created = Batcheachlog(workoutid: workoutid,
                                       batchid: newedbatch.id!,
                                       exerciseid: batcheachlog.exerciseid,
                                       num: batcheachlog.num,
                                       repeats: batcheachlog.repeats,
                                       weight: batcheachlog.weight,
                                       weightunit: batcheachlog.weightunit)

            newedbatcheachloglist.append(created)
        }
        try! AppDatabase.shared.savebatcheachlogs(&newedbatcheachloglist)

        reorderbatchlistnumbers(batch.workoutid)
    }
}
