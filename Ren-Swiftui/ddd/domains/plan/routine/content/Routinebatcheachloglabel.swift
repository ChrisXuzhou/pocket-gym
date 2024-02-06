//
//  Routinebatcheachloglabel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/17.
//

import SwiftUI

struct Routinebatcheachloglabel_Previews: PreviewProvider {
    static var previews: some View {
        // .finished
        let mockedbatcheachlog = mockbatcheachlog()
        let mockedworkout = mockworkout()

        DisplayedView {
            VStack {
                SPACE
                Routinebatcheachloglabel(batcheachlog: Batcheachlogwrapper(mockedbatcheachlog))
                Routinebatcheachloglabel(batcheachlog: Batcheachlogwrapper(mockedbatcheachlog), showexercisename: false)
                SPACE
            }
            .environmentObject(Routineviewmodel(state: .workout, templateusage: nil))
            .environmentObject(Workoutandeachlogmodel(mockedworkout))
        }
    }
}

let ROUTINE_BATCHEACHLOG_FONT_SIZE: CGFloat = DEFINE_FONT_SMALL_SIZE - 3
let ROUTINE_BATCHEACHLOG_EMPTY_SPACING: CGFloat = 20

struct Routinebatcheachloglabel: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var viewmodel: Routineviewmodel
    @EnvironmentObject var model: Routinebatchmodel

    var batcheachlog: Batcheachlogwrapper
    var showexercisename: Bool

    @StateObject var selecttype = Viewopenswitch()

    init(batcheachlog: Batcheachlogwrapper,
         showexercisename: Bool = true) {
        self.batcheachlog = batcheachlog
        self.showexercisename = showexercisename
    }

    var body: some View {
        HStack(spacing: 0) {
            displaynumlabel(batcheachlog.batcheachlog)

            logcontent

            SPACE

            if viewmodel.state == .workout {
                logstats
            }

            SPACE.frame(width: 25)

            modifybuttonslabel(batcheachlog.batcheachlog)
        }
        .background(
            batcheachlog.batcheachlog.num % 2 == 0 ? NORMAL_GRAY_COLOR.opacity(0.1) : Color.clear
        )
    }
}

extension Routinebatcheachloglabel {
    func modifybuttonslabel(_ batcheachlog: Batcheachlog) -> some View {
        HStack(spacing: 10) {
            Button {
                model.delete(batcheachlog)
            } label: {
                Minus()
            }
        }
    }
}

extension Routinebatcheachloglabel {
    var logcontent: some View {
        Routinelogcontent(batcheachlog: batcheachlog)
    }

    func switchlogstats() {
        var _batcheachlog = batcheachlog.batcheachlog
        let retstate: Stats = _batcheachlog.state == .finished ? .progressing : .finished
        _batcheachlog.state = retstate

        try! AppDatabase.shared.savebatcheachlog(&_batcheachlog)
    }

    var logstats: some View {
        Check(finished: batcheachlog.batcheachlog.state == .finished)
            .contentShape(Rectangle())
            .onTapGesture {
                switchlogstats()
            }
    }

    var exercisenameview: some View {
        HStack {
            if showexercisename {
                if let _exercise = batcheachlog.batcheachlog.relatedexercise {
                    LocaleText(_exercise.realname)
                        .font(.system(size: ROUTINE_BATCHEACHLOG_FONT_SIZE))
                        .foregroundColor(NORMAL_GRAY_COLOR)
                }
            }

            SPACE
        }
        .padding(.horizontal, 10)
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
        .padding(.leading, 5)
        .frame(width: ROUTINE_BATCHEACHLOG_EMPTY_SPACING, height: 40)
        .contentShape(Rectangle())
        .onTapGesture {
            selecttype.value = true
        }
        .confirmationDialog("", isPresented: $selecttype.value) {
            Button("\(preference.language("normalset"))") {
                changetype(.workout)
            }

            Button("\(preference.language("warmupset"))") {
                changetype(.warmup)
            }

            Button("\(preference.language("failureset"))") {
                changetype(.failure)
            }

            Button("\(preference.language("dropset"))") {
                changetype(.drop)
            }
        }
    }

    func changetype(_ type: Batchtype) {
        var _batcheachlog = batcheachlog.batcheachlog
        _batcheachlog.type = type
        try! AppDatabase.shared.savebatcheachlog(&_batcheachlog)
    }
}

extension Routinebatchmodel {
    func delete(_ batcheachlog: Batcheachlog) {
        var batchtodelete = batcheachlog
        try! AppDatabase.shared.deletebatcheachlog(&batchtodelete)

        removeBatcheachlogNullableNumber()
    }

    private func removeBatcheachlogNullableNumber() {
        let batcheachlogs = AppDatabase.shared.querybatcheachloglist(batchid: batch.id!)

        let maxnumber = batcheachlogs.map { $0.num }.max()
        let num2batcheachlogs = Dictionary(grouping: batcheachlogs, by: { $0.num })

        if maxnumber == nil {
            return
        }

        var torefreshbatcheachlogs: [Batcheachlog] = []

        var newbatchnumber = 0
        for num in 0 ... maxnumber! {
            if let logs = num2batcheachlogs[num] {
                for var each in logs {
                    if each.num != newbatchnumber {
                        each.num = newbatchnumber
                        torefreshbatcheachlogs.append(each)
                    }
                }
            } else {
                continue
            }
            newbatchnumber += 1
        }

        if !torefreshbatcheachlogs.isEmpty {
            try! AppDatabase.shared.savebatcheachlogs(&torefreshbatcheachlogs)
        }
    }
}
