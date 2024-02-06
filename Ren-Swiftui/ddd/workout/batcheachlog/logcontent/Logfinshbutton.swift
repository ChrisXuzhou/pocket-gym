//
//  Logfinshbutton.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/14.
//

import SwiftUI

struct Logfinshbutton_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            ContentView()
        }
    }
}

struct Logfinshbutton: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var trainingpreference: TrainingpreferenceDefinition
    @EnvironmentObject var restmodel: Workoutrestmodel
    @EnvironmentObject var trainingmodel: Trainingmodel

    /*
     * values
     */
    @EnvironmentObject var workoutmodel: Workoutmodel
    @EnvironmentObject var batchmodel: Batchmodel
    @EnvironmentObject var value: Logvalue

    @ObservedObject var eachlog: Batcheachlogwrapper

    var body: some View {
        HStack {
            Button {
                finish()
            } label: {
                Image("checkmark")
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 13, height: 11, alignment: .center)
                    .aspectRatio(contentMode: .fill)
                    .foregroundColor(.white)
                    .frame(width: 23, height: 23, alignment: .center)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(
                                eachlog.batcheachlog.isfinished ? NORMAL_GREEN_COLOR : NORMAL_GRAY_COLOR.opacity(0.8)
                            )
                    )
            }
            .buttonStyle(FinishButtonStyle())
        }
    }

    func finish() {
        endtextediting()

        if workoutmodel.workout.stats == .inplan {
            trainingmodel.start()
        }

        if value.repeats.isEmpty {
            value.repeats = "\(eachlog.batcheachlog.repeats)"
        }

        if value.weight.isEmpty {
            value.weight = String(format: "%.1f", eachlog.batcheachlog.weight)
        }

        if eachlog.batcheachlog.finishorprogress() {
            let seconds = preference.ofresttimer

            if seconds > 0 {
                withAnimation {
                    restmodel.restimer =
                        Restimer(interval: TimeInterval(seconds)) { seconds in

                            eachlog.batcheachlog.rest = seconds
                            try! AppDatabase.shared.savebatcheachlog(&eachlog.batcheachlog)
                        }

                    restmodel.objectWillChange.send()
                }
            }
        }

        eachlog.objectWillChange.send()
        batchmodel.objectWillChange.send()

        // end of finish
    }
}

struct FinishButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.6 : 1.0)
    }
}
