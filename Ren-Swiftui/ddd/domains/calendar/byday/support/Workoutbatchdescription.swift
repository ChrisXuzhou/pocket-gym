//
//  Workoutbatchdescription.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/7/2.
//

import SwiftUI

struct Workoutbatchdescription_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            VStack {
                Workoutbatchdescription(
                    exercisedeflist: [Batchexercisedef(workoutid: -1, batchid: -1, exerciseid: 30036, order: 1)],
                    batcheachloglist: [
                        Batcheachlog(workoutid: -1, batchid: -1, exerciseid: 30036, num: 0, repeats: 12, weight: 100, weightunit: .kg),

                        Batcheachlog(workoutid: -1, batchid: -1, exerciseid: 30036, num: 0, repeats: 15, weight: 100, weightunit: .kg),
                    ],
                    usetag: true
                )
                
                
                Workoutbatchdescription(
                    exercisedeflist: [Batchexercisedef(workoutid: -1, batchid: -1, exerciseid: 30036, order: 1)],
                    batcheachloglist: [
                        Batcheachlog(workoutid: -1, batchid: -1, exerciseid: 30036, num: 0, repeats: 12, weight: 100, weightunit: .kg),

                        Batcheachlog(workoutid: -1, batchid: -1, exerciseid: 30036, num: 0, repeats: 15, weight: 100, weightunit: .kg),
                    ]
                )
                
                
                
                
            }
            
            
            
        }
    }
}

struct Workoutbatchdescription: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @ObservedObject var model: Workoutbatchdescriptionmodel

    var spacing: CGFloat
    var fontsize: CGFloat
    var linelimit: Int
    var textcolor: Color

    var usetag: Bool

    init(
        templateorworkout: Templateorworkout = .workout,
        exercisedeflist: [Batchexercisedef],
        batcheachloglist: [Batcheachlog],
        spacing: CGFloat = 15,
        fontsize: CGFloat = DEFINE_FONT_SMALLER_SIZE + 1,
        linelimit: Int = 2,
        textcolor: Color = NORMAL_LIGHTER_COLOR,
        usetag: Bool = false
    ) {
        model = Workoutbatchdescriptionmodel(
            templateorworkout: templateorworkout,
            exercisedeflist: exercisedeflist, batcheachloglist: batcheachloglist)

        self.usetag = usetag
        self.spacing = spacing
        self.fontsize = fontsize
        self.linelimit = linelimit
        self.textcolor = textcolor
    }

    var body: some View {
        VStack(alignment: .leading, spacing: spacing) {
            let displayedlist = model.displayed(preference: preference)

            ForEach(0 ..< displayedlist.count, id: \.self) {
                idx in

                let str = displayedlist[idx]

                HStack(spacing: 0) {
                    Text(str)
                        .tracking(0.7)
                        .lineSpacing(2)
                        .lineLimit(linelimit)
                        .multilineTextAlignment(.leading)
                        .font(.system(size: fontsize, design: .rounded))

                    SPACE
                }
            }
        }
        .foregroundColor(textcolor)
    }
}

enum Templateorworkout {
    case template, workout
}

class Workoutbatchdescriptionmodel: ObservableObject {
    var templateorworkout: Templateorworkout
    var exercisedeflist: [Batchexercisedef]
    var exerciseid2batcheachloglist: [Int64: [Batcheachlog]] = [:]

    init(templateorworkout: Templateorworkout = .workout,
         exercisedeflist: [Batchexercisedef],
         batcheachloglist: [Batcheachlog]) {
        self.templateorworkout = templateorworkout
        self.exercisedeflist = exercisedeflist

        if !batcheachloglist.isEmpty {
            exerciseid2batcheachloglist = Dictionary(grouping: batcheachloglist, by: { $0.exerciseid })
        }

        exercisedeflist.forEach { exercisedef in

            let name = exercisedef.ofexercisedef?.realname ?? ""

            if templateorworkout == .workout {
                let batcheachloglist: [Batcheachlog] = exerciseid2batcheachloglist[exercisedef.exerciseid] ?? []
                let setsrepsrange: (Int, Int, Int) = ofsetsrepsrange(batcheachloglist)

                namesetsandrepsminmax.append(
                    (
                        name,
                        setsrepsrange.0,
                        setsrepsrange.1,
                        setsrepsrange.2
                    )
                )
            }

            if templateorworkout == .template {
                namesetsandrepsminmax.append(
                    (
                        name,
                        exercisedef.sets ?? 1,
                        exercisedef.minreps ?? 8,
                        exercisedef.maxreps ?? 12
                    )
                )
            }
        }
    }

    var namesetsandrepsminmax: [(String, Int, Int, Int)] = []

    // sets, min, max
    func ofsetsrepsrange(_ batcheachlogs: [Batcheachlog]) -> (Int, Int, Int) {
        let count = batcheachlogs.count
        if count == 0 {
            return (0, 0, 0)
        }

        var min = 9999
        var max = 0
        for batcheachlog in batcheachlogs {
            let reps = batcheachlog.repeats
            if reps > max {
                max = reps
            }
            if reps < min {
                min = reps
            }
        }
        return (count, min, max)
    }

    func displayed(preference: PreferenceDefinition) -> [String] {
        var displayedrets: [String] = []

        for each in namesetsandrepsminmax {
            let name = each.0
            let sets = each.1
            let repsmin = each.2
            let repsmax = each.3

            var template: String = ""
            if repsmin == repsmax {
                template = preference.language("batchdescriptshort", firstletteruppercase: false)
                template = template.replacingOccurrences(of: "{REPS}", with: "\(repsmin)")
            } else {
                template = preference.language("batchdescriptfull", firstletteruppercase: false)
                template = template.replacingOccurrences(of: "{REPS_MIN}", with: "\(repsmin)")
                template = template.replacingOccurrences(of: "{REPS_MAX}", with: "\(repsmax)")
            }

            template = template.replacingOccurrences(of: "{SETS}", with: "\(sets)")
            template = template.replacingOccurrences(of: "{NAME}", with: "\(preference.language(name))")

            displayedrets.append(template)
        }

        return displayedrets
    }
}
