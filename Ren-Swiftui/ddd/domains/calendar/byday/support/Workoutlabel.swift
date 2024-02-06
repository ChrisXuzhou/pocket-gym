//
//  Workoutlabel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/20.
//

import SwiftUI

struct Workoutlabel_Previews: PreviewProvider {
    static var previews: some View {
        let mockedworkout = mockworkout()

        DisplayedView {
            ZStack {
                NORMAL_BG_COLOR.ignoresSafeArea()

                VStack(spacing: 30) {
                    Workoutlabel(workout: mockedworkout)
                }
            }
        }
        .environmentObject(Trainingmodel())
    }
}

func mockplantask() -> Plantask {
    let mockedworkout = mockworkout()
    return Plantask(id: -1,
                    planid: -1,
                    programname: "push/pull/legs",
                    workoutid: mockedworkout.id ?? -1
    )
}

class Chnagedate: ObservableObject {
    @Published var value: Bool = false
}

struct Workoutlabel: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var trainingmodel: Trainingmodel
    @EnvironmentObject var permit: Permit

    @StateObject var model: Workoutandeachlogmodel
    @ObservedObject var planmodel: Planmodel

    var unpacked: Bool

    init(workout: Workout, unpacked: Bool = true) {
        self.unpacked = unpacked
        _model = StateObject(wrappedValue: Workoutandeachlogmodel(workout))
        planmodel = Planmodel(workout.id!)
    }

    @StateObject var viewmore = Viewmore()
    @StateObject var changedate = Chnagedate()

    @StateObject var editroutine = Viewopenswitch()
    @StateObject var converttoroutine = Viewopenswitch()
    @StateObject var exportswitch = Viewopenswitch()

    var body: some View {
        content
            .background(
                ZStack {
                    NORMAL_BG_CARD_COLOR
                    
                    if let _issucceed = model.issucceed {
                        Succeedorfailed(
                            ret: _issucceed ? .succeeded : .failed,
                            description: routinesummarydescription
                        )
                    }
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .shadow(color: NORMAL_CARD_SHADDOW_COLOR, radius: 15)
            .fullScreenCover(isPresented: $changedate.value) {
                Workoutchangedayquestion(present: $changedate.value)
                    .environmentObject(model)
                    .environmentObject(preference)
            }
            .sheet(isPresented: $converttoroutine.value) {
                Foldermovesheet(foldertitle: "selectfolder") {
                    selected in

                    let folderid = selected?.folderid ?? nil

                    _ = model
                        .templatecreater
                        .buildatemplate(folderid: folderid)
                }
            }
    }
}

func sharebysheet(_ url: URL) {
    let activityController = UIActivityViewController(activityItems: [url], applicationActivities: nil)

    UIApplication.shared.windows.first?.rootViewController!.present(activityController, animated: true, completion: nil)
}

extension Workoutlabel {
    var workoutname: some View {
        HStack {
            LocaleText(
                model.name(preference)
            )
            .font(.system(size: DEFINE_FONT_SMALL_SIZE).bold())
            .foregroundColor(NORMAL_LIGHTER_COLOR)

            SPACE
        }
    }

    var planname: some View {
        HStack(alignment: .center, spacing: 3) {
            if let _planname = planmodel.plan?.programname {
                Image("schedule")
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 11, height: 11, alignment: .center)

                LocaleText(_planname)
                    .font(.system(size: DEFINE_FONT_SMALLER_SIZE - 1).bold())
            }

            SPACE
        }
    }

    var routinesummarydescription: String {
        var _description = ""
        if let _endtime = model.workout.endTime {
            _description = "\(_endtime.displayedyearmonthdate) \(_endtime.displayedonlytime)"
        }

        return _description
    }

    var exercisesname: some View {
        HStack {
            let _displayedexercise = model.exercisesnamestr(preference)

            Text(_displayedexercise)
                .tracking(0.7)
                .lineSpacing(5)
                .lineLimit(5)
                .multilineTextAlignment(.leading)
                .font(
                    .system(size: DEFINE_FONT_SMALLER_SIZE,
                            design: .rounded
                    )
                )

            SPACE
        }
    }
}

extension Workoutlabel {
    var morebutton: some View {
        Menu {
            Button(action: {
                converttoroutine.value = true
            }) {
                Label("\(preference.language("convertedtoroutine"))", systemImage: "doc")
            }

            Button(action: {
                changedate.value = true
            }) {
                Label("\(preference.language("changedate"))", systemImage: "calendar")
            }

            Button(action: {
                changedate.value = true
            }) {
                Label("\(preference.language("exportcsv"))", systemImage: "arrow.down.doc")
            }

            Button(role: .destructive) {
                DispatchQueue.global().async {
                    deleteItem()
                }
            } label: {
                Label("\(preference.language("delete"))", systemImage: "trash")
            }

        } label: {
            Label("", systemImage: "ellipsis")
        }
        .menuStyle(Localmenustyle())
        .frame(height: FOLDER_ROUTINE_HEADER_HEIGHT)
        .contentShape(Rectangle())
    }

    var batchcountview: some View {
        HStack(alignment: .lastTextBaseline, spacing: 0) {
            Text("x")
                .bold()
                .font(.system(size: 12).bold())

            LocaleText("\(model.batchlist.count)", linelimit: 1)
                .font(.system(size: 28).weight(.heavy).italic())
        }
        .frame(height: 80)
    }

    var content: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 0) {
                batchcountview
                    .foregroundColor(NORMAL_LIGHTER_COLOR)
                    .padding(.leading, 5)
                    .frame(width: 35)

                HStack {
                    VStack(alignment: .leading, spacing: 3) {
                        workoutname
                        planname
                    }

                    SPACE

                    morebutton
                }
                .padding(.horizontal, 10)
            }

            LOCAL_DIVIDER

            Button {
                trainingmodel.confirmedstartnow(model.workout)
            } label: {
                ZStack(alignment: .top) {
                    SPACE.frame(height: UIScreen.height / 2 - 80)

                    exercisescontent
                }
            }
        }
        .foregroundColor(NORMAL_LIGHTER_COLOR)
    }

    var exercisescontent: some View {
        VStack(alignment: .leading, spacing: 15) {
            if unpacked {
                if model.batchwrappers.isEmpty {
                    Emptycontentpanel()
                } else {
                    ForEach(0 ..< model.batchwrappers.count, id: \.self) {
                        idx in

                        let _batchwrapper = model.batchwrappers[idx]
                        Workoutbatchdescription(
                            exercisedeflist: _batchwrapper.1,
                            batcheachloglist: _batchwrapper.2
                        )
                    }
                }
            } else {
                exercisesname
            }
        }
        .foregroundColor(NORMAL_LIGHTER_COLOR.opacity(0.9))
        .padding(.horizontal, 15)
        .padding(.vertical, 20)
    }
}

extension Workoutlabel {
    var editbutton: some View {
        Button {
            trainingmodel.confirmedstartnow(model.workout)
        } label: {
            HStack {
                SPACE
                LocaleText(model.workout.isfinished ? "edit" : "training")
                    .foregroundColor(preference.theme)
                    .font(.system(size: DEFINE_FONT_SMALL_SIZE + 1).weight(.bold))
                SPACE
            }
            .frame(height: GOTRAINING_BUTTON_HEIGHT)
            // .background(preference.theme)
        }
    }
}

extension Workoutlabel {
    func deleteItem() {
        if let _workoutid = model.workout.id {
            deleteworkout(_workoutid)
        }
    }
}

extension Bool {
    var successedcolor: Color {
        self ? NORMAL_GREEN_COLOR : NORMAL_RED_COLOR
    }

    var successedface: Faceshape {
        Faceshape(face: self ? .smile : .sad)
    }
}
