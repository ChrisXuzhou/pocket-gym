//
//  Workoutstodaysview.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/12/11.
//

import GRDB
import SwiftUI

struct Workoutstodaysview_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            ContentView()
        }
    }
}

class Workoutstodaysmodel: ObservableObject {
    var workouts: [Workoutwrapper] = []

    init() {
        observeworkouts()
    }

    var observed: DatabaseCancellable?

    private func observeworkouts() {
        let today = Date().dayinterval ?? DateInterval(start: Date(), end: Date())

        observed = AppDatabase.shared.observeunfinishedworkouts(
            interval: today,
            onError: { error in fatalError("Unexpected error: \(error)") },
            onChange: { [weak self] workouts in

                guard let self = self else {
                    return
                }

                self.workouts = workouts.map({ Workoutwrapper($0) })
                self.objectWillChange.send()
            })
    }
}

extension Workoutstodaysmodel {
    static var shared = Workoutstodaysmodel()
}

struct Workoutstodaysview: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var model: Workoutstodaysmodel

    var body: some View {
        VStack(spacing: 0) {
            if !model.workouts.isEmpty {
                panel

                content
                    .padding(.top, 10)
                    .padding(.horizontal, 10)

                SPACE.frame(height: 20)
            }
        }
    }
}

extension Workoutstodaysview {
    var panel: some View {
        HStack(spacing: 20) {
            LocaleText("todaysworkout")
                .font(.system(size: DEFINE_FONT_SMALLER_SIZE))
                .foregroundColor(NORMAL_BUTTON_COLOR)

            SPACE
        }
        .frame(height: 40)
        .padding(.horizontal)
    }

    var content: some View {
        LazyVStack(spacing: 10) {
            ForEach(0 ..< model.workouts.count, id: \.self) {
                idx in

                let workout = model.workouts[idx]

                Folderworkoutlabel(workout: workout)
                    .id(workout.value.id ?? Int64(idx))
            }
        }
    }
}

struct Folderworkoutlabel: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var trainingmodel: Trainingmodel
    @EnvironmentObject var permit: Permit

    @StateObject var model: Workoutandeachlogmodel

    init(workout: Workoutwrapper,
         height: CGFloat = FOLDER_ROUTINE_HEIGHT) {
        self.height = height
        _model = StateObject(wrappedValue: Workoutandeachlogmodel(workout.value))
    }

    /*
     * varibales
     */
    var headerfont: CGFloat = DEFINE_FONT_SMALLER_SIZE
    var height: CGFloat

    var fontcolor: Color = NORMAL_LIGHTER_COLOR
    var contentfont: CGFloat = DEFINE_FONT_SMALLER_SIZE
    var contentfontcolor: Color = NORMAL_LIGHT_TEXT_COLOR

    /*
     * function varibales
     */
    @StateObject var viewmore = Viewmore()
    @StateObject var changedate = Chnagedate()

    @StateObject var editroutine = Viewopenswitch()
    @StateObject var converttoroutine = Viewopenswitch()
    @StateObject var exportswitch = Viewopenswitch()

    var body: some View {
        VStack(spacing: 0) {
            header

            Button {
                trainingmodel.confirmedstartnow(model.workout)
            } label: {
                content
                    .padding(.vertical, 5)
                    .padding(.horizontal, 10)
            }
        }

        .frame(height: height)
        .background(
            ZStack(alignment: .top) {
                NORMAL_BG_CARD_COLOR

                if let _issucceed = model.issucceed {
                    Succeedorfailed(
                        ret: _issucceed ? .succeeded : .failed,
                        description: routinesummarydescription
                    )
                }
            }
        )
        .clipShape(
            RoundedRectangle(cornerRadius: 15)
        )
        .shadow(color: preference.theme.opacity(0.1), radius: 5)
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

extension Folderworkoutlabel {
    var header: some View {
        HStack(spacing: 8) {
            HStack(alignment: .lastTextBaseline, spacing: 0) {
                Text("x")
                    .font(.system(size: 12).bold())

                LocaleText("\(model.batchlist.count)", linelimit: 1)
                    .font(.system(size: headerfont).bold())
            }

            LocaleText(model.name(preference))
                .font(.system(size: headerfont).bold())
                .foregroundColor(NORMAL_LIGHTER_COLOR)

            SPACE

            morebutton
        }
        .padding(.horizontal, 10)
        .foregroundColor(fontcolor)
        .background(NORMAL_BG_CARD_COLOR)
        .frame(height: FOLDER_ROUTINE_HEADER_HEIGHT)
    }

    var routinesummarydescription: String {
        var _description = ""
        if let _endtime = model.workout.endTime {
            _description = "\(_endtime.displayedyearmonthdate) \(_endtime.displayedonlytime)"
        }

        return _description
    }

    var exercisesname: some View {
        ZStack {
            let _displayedexercise = model.exercisesnamestr(preference)

            if !_displayedexercise.isEmpty {
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        Text(_displayedexercise)
                            .tracking(0.7)
                            .lineSpacing(3)
                            .lineLimit(4)
                            .multilineTextAlignment(.leading)
                            .font(.system(size: contentfont))
                            .foregroundColor(NORMAL_LIGHT_TEXT_COLOR)

                        SPACE
                    }
                    SPACE
                }

            } else {
                VStack(spacing: 0) {
                    Emptycontentpanel()
                    SPACE
                }
            }
        }
    }
}

extension Folderworkoutlabel {
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

    var content: some View {
        exercisesname
    }
}

extension Folderworkoutlabel {
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
        }
    }
}

extension Folderworkoutlabel {
    func deleteItem() {
        if let _workoutid = model.workout.id {
            deleteworkout(_workoutid)
        }
    }
}
