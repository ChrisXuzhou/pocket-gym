import AudioToolbox
import AVKit
import SwiftUI

struct AnalysisedmuscleHeader: View {
    @EnvironmentObject var model: AnalysisedmuscleViewModel
    var present: Binding<PresentationMode>
    @Binding var pack: Bool

    var title: some View {
        HStack(spacing: 0) {
            Musclelink(muscle: model.muscle, displaysize: 40, showtext: false)
            VStack(alignment: .leading, spacing: 0) {
                Text(model.muscle.id)
                    .font(.system(size: 23))
                    .foregroundColor(.primary)

                Text(displayShortTime(model.focusedTime))
                    .font(.system(size: 15))
                    .foregroundColor(Color(.systemGray))
            }
        }
    }

    var packButton: some View {
        Button {
            pack.toggle()
        } label: {
            Image(systemName: !pack ?
                "chevron.up.circle.fill" : "chevron.down.circle.fill")
                .font(.system(size: 26))
                .foregroundColor(.blue.opacity(0.7))
        }
        .padding(.horizontal)
    }

    var body: some View {
        HStack {
            HStack(spacing: 0) {
                Button {
                    present.wrappedValue.dismiss()
                } label: {
                    Backarrow()
                }

                title

                Spacer()

                packButton
            }
            .frame(height: MIN_UP_TAB_HEIGHT)
        }
    }
}

struct AnalysisedmusclegrapviewValue: View {
    var description: String
    var footer: String
    var value: Int

    var color: Color = Color("Background")

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack(alignment: .lastTextBaseline, spacing: 2) {
                Text(value.description)
                    .font(.system(size: 23))
                    .foregroundColor(color)

                Text(footer)
                    .font(.system(size: 13))
                    .foregroundColor(Color(.systemGray))
            }
            Text(description)
        }
        .foregroundColor(.black.opacity(0.7))
        .font(.system(size: 15))
        .frame(width: 90, height: 100)
    }
}

struct Analysisedmusclegrapview: View {
    @EnvironmentObject var model: AnalysisedmuscleViewModel

    var analysisedGraph: some View {
        VStack {
            let timelineValues = model.timelineValues
            MuscleHistoryGraph(timelineValues,
                               aware: model,
                               isDigit: false)
        }
        .frame(height: 120)
        .padding(.horizontal)
    }

    var divider: some View {
        Divider().padding(3)
    }

    var analysisedValue: some View {
        HStack {
            /*

             if let f = model.focused {
                 Indicator(value: f.primaryExerciseCnt.description,
                           description: "核心动作数")
                     .foregroundColor(Color("Background"))
                     .frame(width: 80)
                 divider
                 Indicator(value: f.secondaryExerciseCnt.description,
                           description: "复合动作数")
                     .foregroundColor(Color("Foreground"))
                     .frame(width: 80)
                 divider
                 Indicator(value: String(format: "%.1f", f.primaryVolume),
                           description: "核心容量(kg)")
                     .foregroundColor(.orange)
                     .frame(width: 80)
             }

              */
        }
        .frame(height: 70)
    }

    var body: some View {
        VStack(spacing: 0) {
            analysisedValue
            analysisedGraph
        }
    }
}

struct AnalysisedmuscleView: View {
    @ObservedObject var model: AnalysisedmuscleViewModel
    @Environment(\.presentationMode) var present
    @State var pack = false

    init(_ muscle: Muscledef) {
        model = AnalysisedmuscleViewModel(muscle)
    }

    var header: some View {
        AnalysisedmuscleHeader(present: present, pack: $pack)
    }

    var historyGraph: some View {
        Analysisedmusclegrapview()
    }

    var headers: some View {
        VStack(spacing: 0) {
            header

            if !pack {
                historyGraph
                    .padding(.bottom, 25)
            }
        }
        .background(
            Rectangle()
                .foregroundColor(
                    Color(.systemGray6)
                )
                .ignoresSafeArea()
        )
    }

    var content: some View {
        VStack {
            if let f = model.focused {
                AnalysisedmuscleExercises(f)
            }
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            headers

            content

            Spacer()
        }
        .environmentObject(model)
    }
}

extension Analysisedexercise {
    func isPrimary(_ muscle: Muscledef) -> Bool {
        /*
         if let exercise = Exerciselibrary.ofexercise(exerciseid) {
             return exercise.isPrimary(muscle.identify)
         }
         */
        return false
    }

    func isSecondary(_ muscle: Muscledef) -> Bool {
        /*
         if let exercise = Exerciselibrary.ofexercise(exerciseid) {
             return exercise.isSecondary(muscle.identify)
         }
         */
        return false
    }

    var secondaryMuscles: [String] {
        /*
         if let exercise = Exerciselibrary.ofexercise(exerciseid) {
             return exercise._secondarymuscleids
         }
         */
        return []
    }

    var exercise: Newdisplayedexercise? {
        if let _def = AppDatabase.shared.queryNewexercisedef(exerciseid: exerciseid) {
            return Newdisplayedexercise(_def)
        }
        return nil
    }

    var displayvolume: String {
        String(format: "%.1f", volume)
    }
    
    var display1rm: String {
        String(format: "%.1f", onerm)
    }
    
    var displaymaxweight: String {
        String(format: "%.1f", maxweight)
    }
}
