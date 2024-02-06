//
//  Workoutviewdownbar.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/10.
//

import SwiftUI

let WORKOUTVIEW_DOWN_WIDTH: CGFloat = UIScreen.width - 20
let WORKOUTVIEW_DOWN_EACH_WIDTH = WORKOUTVIEW_DOWN_WIDTH / 3

struct Workoutviewdowntab: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var trainingpreference: TrainingpreferenceDefinition

    @EnvironmentObject var trainingmodel: Trainingmodel
    @EnvironmentObject var restmodel: Workoutrestmodel
    @EnvironmentObject var workoutmodel: Workoutmodel
    @EnvironmentObject var focused: Logfocused

    let lock = NSLock()

    var isdiabled: Bool {
        workoutmodel.batchnumberdictionary.isEmpty || !workoutmodel.workout.isinprogress
    }

    var body: some View {
        HStack(spacing: 0) {
            SPACE
            /*
             if !workoutmodel.batchnumberdictionary.isEmpty {
                 revokebutton
             }
             */

            newabatchbutton

            /*
             if !workoutmodel.batchnumberdictionary.isEmpty {
                 proceedbutton
             }
             */
            SPACE
        }
        .frame(height: MIN_DOWN_TAB_HEIGHT)
        .padding(.horizontal, 10)
        .background(
            NORMAL_BG_COLOR.opacity(0.9).ignoresSafeArea()
        )
    }
}

/*
 *   view related
 */
extension Workoutviewdowntab {
    var newabatchbutton: some View {
        Newabatchbutton()
            .frame(width: WORKOUTVIEW_DOWN_EACH_WIDTH)
    }

    var revokebutton: some View {
        HStack {
            let _isdiabled = isdiabled

            Button {
                revoke()
            } label: {
                HStack {
                    SPACE

                    Previousarrow()
                        .foregroundColor(
                            _isdiabled ?
                                NORMAL_LIGHT_GRAY_COLOR : NORMAL_BUTTON_COLOR
                        )

                    SPACE
                }
            }
            .disabled(_isdiabled)
        }
        .frame(width: WORKOUTVIEW_DOWN_EACH_WIDTH)
    }

    var proceedbutton: some View {
        HStack {
            let _isdiabled = isdiabled

            Button {
                proceed()
            } label: {
                HStack {
                    SPACE

                    Nextarrow()
                        .foregroundColor(
                            _isdiabled ?
                                NORMAL_LIGHT_GRAY_COLOR : NORMAL_GREEN_COLOR
                        )

                    SPACE
                }
            }
        }
        .frame(width: WORKOUTVIEW_DOWN_EACH_WIDTH)
    }
}

extension Workoutviewdowntab {
    func revoke() {
        if lock.try() {
            defer {
                lock.unlock()
            }

            workoutmodel.revoke()
        }
    }

    func proceed() {
        if lock.try() {
            defer {
                lock.unlock()
            }

            if workoutmodel.workout.stats == .inplan {
                trainingmodel.start()
            }

            let (proceeded, anumbergroupfinished) = workoutmodel.proceed()
            if anumbergroupfinished {
                let secs = preference.ofresttimer

                if secs > 0 {
                    withAnimation {
                        restmodel.restimer = Restimer(
                            interval: TimeInterval(secs)
                        ) { counter in

                            if let _batcheachlog = proceeded {
                                _batcheachlog.batcheachlog.rest = counter
                                try! AppDatabase.shared.savebatcheachlog(&_batcheachlog.batcheachlog)
                            }
                        }

                        restmodel.objectWillChange.send()
                    }
                }
            }
        }
    }
}
