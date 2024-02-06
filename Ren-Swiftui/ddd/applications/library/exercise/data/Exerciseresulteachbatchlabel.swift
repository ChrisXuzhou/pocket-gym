//
//  Exerciseresulteachbatchlabel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/5/7.
//

import SwiftUI

struct Exerciseresulteachbatchlabel_Previews: PreviewProvider {
    static var previews: some View {
        let mockedbatch = mockbatch()

        DisplayedView {
            VStack(spacing: 30) {
                Exerciseresulteachbatchlabel(
                    batch: mockedbatch,
                    showexerciseinfo: true,
                    showdate: false
                )

                Exerciseresulteachbatchlabel(
                    batch: mockedbatch,
                    showexerciseinfo: true
                )
            }
        }
    }
}

struct Exerciseresulteachbatchlabel: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @ObservedObject var batchmodel: Routinebatchmodel

    var showexerciseinfo: Bool = true
    var showdate: Bool
    var showlink: Bool

    init(batch: Batch,
         showexerciseinfo: Bool = true,
         showdate: Bool = true,
         showlink: Bool = false
    ) {
        batchmodel = Routinebatchmodel(batch: batch)
        self.showexerciseinfo = showexerciseinfo
        self.showdate = showdate
        self.showlink = showlink
    }

    var relatedexerciselist: [Newdisplayedexercise] {
        var relatedexerciselist: [Newdisplayedexercise] = []
        for each in batchmodel.batchexercisedeflist {
            if let _exercisedef = Exerciselibrary.ofexercise(each.exerciseid) {
                relatedexerciselist.append(_exercisedef)
            }
        }

        return relatedexerciselist
    }

    var exerciseview: some View {
        HStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top) {
                    ForEach(relatedexerciselist, id: \.exercise.id) {
                        exercise in

                        Exerciselabelvideo(
                            exercise: exercise,
                            showlink: showlink
                        )
                    }
                }
            }
        }
    }

    var displaybatchlabelheader: some View {
        HStack(alignment: .lastTextBaseline, spacing: 0) {
            if let _first = batchmodel.batcheachloglist.first {
                SPACE.frame(width: ROUTINE_BATCHEACHLOG_EMPTY_SPACING)

                LocaleText("reps", uppercase: true)
                    .frame(width: DEFAULT_ROUTINE_CONTENT_EACH_WIDTH)

                LocaleText(_first.weightunit.name, uppercase: true)
                    .frame(width: DEFAULT_ROUTINE_CONTENT_EACH_WIDTH)

                LocaleText("restimeshort", uppercase: true)
                    .frame(width: DEFAULT_ROUTINE_CONTENT_EACH_WIDTH)

                SPACE
            }
        }
        .frame(height: DEFAULT_ROUTINE_LOG_CONTENT_TITLE_HEIGHT)
        .font(.system(size: DEFINE_FONT_SMALLER_SIZE).bold())
        .foregroundColor(NORMAL_BUTTON_COLOR)
    }

    var displaybatchlabels: some View {
        LazyVStack {
            displaybatchlabelheader

            let num2batcheachlogs = batchmodel.num2batcheachlogs
            if let _maxnumber = batchmodel.maxnumber {
                ForEach(0 ... _maxnumber, id: \.self) {
                    num in

                    let batcheachlogs = num2batcheachlogs[num] ?? []
                    let numberedbatcheachlogs = batchmodel.orderbatcheachlogInexerciseorder(batcheachlogs)

                    VStack {
                        if !numberedbatcheachlogs.isEmpty {
                            ForEach(numberedbatcheachlogs, id: \.id) {
                                batcheachlog in

                                HStack(spacing: 0) {
                                    Text("\(batcheachlog.num + 1)")
                                        .foregroundColor(NORMAL_GRAY_COLOR)
                                        .font(.system(size: DEFINE_FONT_SMALLEST_SIZE).bold())
                                        .frame(width: ROUTINE_BATCHEACHLOG_EMPTY_SPACING)

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

                                    Check(finished: batcheachlog.state == .finished)
                                        .padding(.trailing, 3)
                                }
                                .foregroundColor(NORMAL_LIGHTER_COLOR.opacity(0.7))
                                .font(.system(size: DEFINE_FONT_SMALLER_SIZE))
                                .background(
                                    batcheachlog.num % 2 == 0 ? NORMAL_GRAY_COLOR.opacity(0.1) : Color.clear
                                )
                            }
                        }
                    }
                }
            }
        }
        .environmentObject(Routineviewmodel(state: .workout))
        .id(batchmodel.batch.id)
    }

    var displaynoteview: some View {
        HStack {
            if let _note = batchmodel.batch.batchnote {
                LocaleText(_note, linelimit: 10)
                    .font(.system(size: DEFINE_FONT_SMALL_SIZE))
                    .foregroundColor(NORMAL_GRAY_COLOR)
                    .padding(.leading, 6)
            }

            SPACE
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            VStack(spacing: 0) {
                if showdate {
                    dateandtimepanel
                }

                if showexerciseinfo {
                    HStack(spacing: 0) {
                        if relatedexerciselist.count == 1 {
                            LocaleText(relatedexerciselist.first?.realname ?? "")
                        } else if relatedexerciselist.count > 1 {
                            LocaleText(relatedexerciselist.count < 3 ? LANGUAGE_SUPERGROUP : LANGUAGE_GIANTGROUP, uppercase: true)
                                .foregroundColor(NORMAL_LIGHTER_COLOR)
                            Text("x \(relatedexerciselist.count)").foregroundColor(Color.orange).bold()
                        }
                        SPACE
                    }
                    .font(.system(size: DEFINE_FONT_SMALLER_SIZE))
                    .foregroundColor(NORMAL_LIGHTER_COLOR)
                    .padding(.vertical, 5)

                    exerciseview
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 10)

            displaybatchlabels

            displaynoteview
        }
        .padding(.vertical, 5)
        .transition(.opacity)
    }
}

extension Exerciseresulteachbatchlabel {
    var dateandtimepanel: some View {
        HStack {
            LocaleText(batchmodel.batch.createtime.systemedyearmonthdate)

            LocaleText(batchmodel.batch.createtime.displayedonlytime)

            SPACE
        }
        .font(.system(size: DEFINE_FONT_SMALL_SIZE).bold())
        .foregroundColor(NORMAL_LIGHTER_COLOR)
    }
}
