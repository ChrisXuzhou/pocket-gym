//
//  Planworkoutlabel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/20.
//

import SwiftUI

struct Planworkoutlabel_Previews: PreviewProvider {
    static var previews: some View {
        let mockedworkout = mockworkout()
        let mockedplantask = Plantask(id: -1,
                                      planid: -1,
                                      programname: "push/pull/legs",
                                      workoutid: mockedworkout.id ?? -1
        )

        DisplayedView {
            ZStack {
                NORMAL_BACKGROUND_COLOR.ignoresSafeArea()

                VStack(spacing: 30) {
                    Planworkoutlabel(mockedplantask, workout: mockedworkout)
                        .environmentObject(Modify())

                    Planworkoutlabel(mockedplantask, workout: mockedworkout)
                        .environmentObject(Modify(true))
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

struct Planworkoutlabel: View {
    @EnvironmentObject var preference: PreferenceDefinition

    @EnvironmentObject var viewmodel: Calendarbyweekdaysviewmodel
    @EnvironmentObject var trainingmodel: Trainingmodel
    @EnvironmentObject var modify: Modify

    @ObservedObject var model: Planworkoutlabelmodel

    init(_ plantask: Plantask? = nil, workout: Workout) {
        model = Planworkoutlabelmodel(plantask, workout: workout)
    }

    var name: String? {
        if let _name = model.inplanworkout?.name {
            return _name
        }

        return musclename
    }

    var musclename: String {
        let musclenames: [String] =
            model.musclelist.map({ preference.language($0.id) })
        return musclenames.joined(separator: ", ")
    }

    var exerciseslable: some View {
        HStack {
            let _displayedexercise = model.displayexercise(preference)

            Text(_displayedexercise)
                .lineSpacing(5)
                .lineLimit(5)
                .multilineTextAlignment(.leading)
                .font(.system(size: DEFINE_FONT_SMALLER_SIZE - 3).bold())
                .foregroundColor(.white)

            SPACE
        }
    }

    var labletitle: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 3) {
                let _name: String = name ?? ""
                if !_name.isEmpty {
                    LocaleText(_name)
                        .font(.system(size: DEFINE_FONT_SMALL_SIZE).bold())
                        .padding(.trailing)
                }

                if let _plantask = model.plantask {
                    let _programename: String = _plantask.programname ?? ""
                    if !_programename.isEmpty {
                        LocaleText(_programename)
                            .font(.system(size: DEFINE_FONT_SMALLER_SIZE - 2).bold())
                            .padding(.trailing)
                    }
                }

                SPACE
            }

            SPACE

            HStack(alignment: .lastTextBaseline) {
                if !modify.modify {
                    Routineindicator(
                        type: .horizontal,
                        description: "exercisesets",
                        value: "\(model.batchlist.count)",
                        fontcolor: .white
                    )
                }
            }
        }
        .padding(.top, 5)
        .frame(height: 40)
    }

    var labelview: some View {
        VStack(alignment: .leading, spacing: 0) {
            labletitle
                .frame(height: 50)

            exerciseslable
            SPACE
        }
        .foregroundColor(.white)
        .padding(.leading)
        .padding(.vertical, 5)
    }

    var modifybuttons: some View {
        HStack(spacing: 10) {
            Button {
                deleteplantask()
            } label: {
                Labeldelete()
                    .frame(width: 50, height: 50)
                    .contentShape(Rectangle())
            }
        }
        .foregroundColor(NORMAL_BUTTON_COLOR)
    }

    func deleteplantask() {
        if let _id = model.plantask?.id {
            try! AppDatabase.shared.deleteplantask(id: _id)
        }

        if let _workoutid = model.inplanworkout?.id {
            deleteworkout(_workoutid)
        }
    }

    var navilink: some View {
        RoutineView(
            present: $showworkoutview,
            state: model.inplanworkout!.stats.ofroutinestate,
            routineusage: .startnow,
            workout: model.inplanworkout!
        )
        .environmentObject(trainingmodel)
        .environmentObject(preference)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }

    var background: some View {
        Imagetemplatebackgroud(
            secondid: model.inplanworkout?.id ?? -1
        )
    }

    func color(_ ret: Workoutresult) -> Color {
        switch ret {
        case .succeeded:
            return NORMAL_GREEN_COLOR
        case .failed:
            return NORMAL_RED_COLOR
        }
    }

    var finishedlayer: some View {
        ZStack {
            if let _succeed = model.issucceed {
                _succeed.successedcolor.opacity(0.2)

                let _description: String? = model.inplanworkout?.endTime?.displayedyearmonthdate

                Succeedorfailed(ret: _succeed ? .succeeded : .failed, description: _description)
            }
        }
    }

    @State var showworkoutview = false
    var contentview: some View {
        HStack {
            NavigationLink(isActive: $showworkoutview.onChange({ newvalue in
                if !newvalue {
                    model.refresh()
                }
            })) {
                navilink
            }
            label: {
                ZStack {
                    background

                    labelview

                    finishedlayer
                }
            }
            .isDetailLink(false)
        }
    }

    var modifylayer: some View {
        HStack {
            SPACE

            modifybuttons.padding(.horizontal)
        }
    }

    var _bodyview: some View {
        ZStack {
            contentview

            if modify.modify {
                modifylayer
            }
        }
        .frame(height: TEMPLATE_LABEL_HEIGHT + 10)
        .clipShape(
            RoundedRectangle(cornerRadius: 5)
        )
        .clipped()
        .contentShape(Rectangle())
    }

    var body: some View {
        HStack {
            if model.inplanworkout != nil {
                _bodyview
            }
        }
    }
}

extension Bool {
    var successedcolor: Color {
        self ? NORMAL_GREEN_COLOR : NORMAL_RED_COLOR
    }
}
