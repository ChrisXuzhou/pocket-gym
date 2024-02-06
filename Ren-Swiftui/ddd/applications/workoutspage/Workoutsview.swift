//
//  PlanView.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/17.
//

import SwiftUI
import BottomSheet


struct Workoutsview_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            ContentView()
        }
    }
}

let OPENED_FOLDER_ID_KEY: String = "openedfolderid"
let FOLDER_FOCUSED_KEY: String = "folderfocusedkey"

class Menuisopen: ObservableObject {
    @Published var openedfolderid: Int64 = EMPTY_FOLDER_ID
    @Published var focused: Bool = false

    init() {
        if let _cache = AppDatabase.shared.queryappcache(OPENED_FOLDER_ID_KEY) {
            openedfolderid = Int64(_cache.cachevalue) ?? EMPTY_FOLDER_ID
        }

        if let _cache = AppDatabase.shared.queryappcache(FOLDER_FOCUSED_KEY) {
            focused = Bool(_cache.cachevalue) ?? false
        }
    }

    func openfolder(_ folder: Folderwrapper) {
        if folder.folderid != openedfolderid {
            openedfolderid = folder.folderid
        }

        let _openedfolderid = openedfolderid

        DispatchQueue.global().async {
            var appcache = Appcache(
                cachekey: OPENED_FOLDER_ID_KEY,
                cachevalue: "\(_openedfolderid)"
            )
            try! AppDatabase.shared.saveappcache(&appcache)
        }
    }

    func togglefocus() {
        focused.toggle()

        let _focused = focused
        DispatchQueue.global().async {
            var appcache = Appcache(
                cachekey: FOLDER_FOCUSED_KEY,
                cachevalue: "\(_focused)"
            )
            try! AppDatabase.shared.saveappcache(&appcache)
        }
    }
}

struct Workoutsview: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var trainingmodel: Trainingmodel

    /*
     * variables
     */
    @StateObject var newswitch = Viewopenswitch()
    @StateObject var newroutineswitch = Viewopenswitch()

    /*
     * content modal
     */
    @StateObject var model = Folderroutinesmodel.shared
    @StateObject var foldersmodel = Foldersmodel.shared
    @StateObject var todaysmodel = Workoutstodaysmodel.shared

    @StateObject var menuisopen = Menuisopen()
    @State var showingAlert = false
    
    @State var bottomSheetPosition: BottomSheetPosition = .relative(0.4)

    var body: some View {
        ZStack {
            if model.templates.isEmpty && foldersmodel.rootfolders.isEmpty && todaysmodel.workouts.isEmpty {
                emptyview
            } else {
                content
            }

            Plusbutton {
                newswitch.value = true
            }
            .alert(preference.language("duplicateworkoutmsg"), isPresented: $showingAlert) {
                Button(preference.language("ok"), role: .cancel) { }
            }
        }
        .background(NORMAL_BG_COLOR.ignoresSafeArea())
        .environmentObject(menuisopen)
        .environmentObject(Foldersmodel.shared)
        .environmentObject(Folderroutinesmodel.shared)
        .fullScreenCover(isPresented: $newroutineswitch.value) {
            Routinebetaeditor(Routine.emptyroutine(), preferedfolderid: menuisopen.openedfolderid)
        }
        .sheetWithDetents(
            isPresented: $newswitch.value,
            detents: [.medium()] // [.medium(),.large()]
        ) {
            Newaroutinebetasheet {
                action in

                newswitch.value = false

                if action == .newroutine {
                    newroutineswitch.value = true
                } else if action == .newworkout {
                    newaworkout()
                }
            }
            .environmentObject(Foldersmodel.shared)
            .environmentObject(preference)
        }
    }
}

extension Workoutsview {
    var content: some View {
        ScrollView(.vertical, showsIndicators: false) {
            Workoutstodaysview()
                .environmentObject(todaysmodel)

            Routinetreeview()

            SPACE.frame(height: UIScreen.height / 3)

            Copyright()

            SPACE.frame(height: MIN_DOWN_TAB_HEIGHT)
        }
    }

    var emptyview: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .center, spacing: 30) {
                SPACE.frame(height: UIScreen.height / 5)

                VStack(alignment: .leading, spacing: 20) {
                    
                    LocaleText("emptyroutinereminder1", usefirstuppercase: false, alignment: .leading)

                    LocaleText("emptyroutinereminder2", usefirstuppercase: false, alignment: .leading)
                }
                .frame(width: 220)

                SPACE
                
                HStack {
                   SPACE
                }
            }
            .font(.system(size: DEFINE_FONT_SMALL_SIZE - 1, design: .rounded))
            .foregroundColor(NORMAL_LIGHT_TEXT_COLOR)
            .opacity(0.6)
        }
    }

    func newaworkout() {
        if let workoutmodel = trainingmodel.current {
            if workoutmodel.workout.isinprogress {
                showingAlert = true
                return
            }
        }

        var _workoutday = trainingmodel.focusedday ?? Date()
        _workoutday = Calendar.current.date(byAdding: .second, value: +5, to: _workoutday) ?? Date()

        var newedworkout = Workout(workday: _workoutday)
        try! AppDatabase.shared.saveworkout(&newedworkout)

        trainingmodel.confirmedstartnow(newedworkout)
    }
}
