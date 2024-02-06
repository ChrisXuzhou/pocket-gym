//
//  Workoutfinishedlabel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/5/11.
//

import SwiftUI

struct Workoutfinishedlabel_Previews: PreviewProvider {
    static var previews: some View {
        let mockedworkout = mockworkout()

        DisplayedView {
            Workoutfinishedlabel(
                present: .constant(false),
                workoutid: mockedworkout.id!
            )
        }
    }
}

struct Workoutfinishedlabel: View {
    @EnvironmentObject var preference: PreferenceDefinition

    @StateObject var model: Workoutupdatalabelmodel

    @Binding var present: Bool
    let workoutid: Int64
    let workout: Workout
    let analysiseds: [Analysisedmuscle]

    init(present: Binding<Bool>, workoutid: Int64) {
        _present = present
        self.workoutid = workoutid
        analysiseds = AppDatabase.shared.queryAnalysisedmuscles(workoutid: workoutid)
        // .queryAnalysisedexerciselist(workoutid: workoutid)

        workout = AppDatabase.shared.queryworkout(workoutid)!
        _model = StateObject(wrappedValue: Workoutupdatalabelmodel(workoutid))
    }

    var body: some View {
        ZStack {
            NORMAL_BG_COLOR
                .opacity(0.8).ignoresSafeArea()

            VStack(spacing: 0) {
                ScrollView(.vertical, showsIndicators: false) {
                    SPACE.frame(height: 80)

                    congratulationview

                    contentview

                    SPACE
                }
                .frame(width: UIScreen.width)

                confirmbutton.padding(.vertical)
            }
        }
    }
}

extension Workoutfinishedlabel {
    
    var confirmbutton: some View {
        Button {
            present = false
        } label: {
            LocaleText("ok", uppercase: true)
                .foregroundColor(.white)
                .font(.system(size: LIBRARY_ADDBUTTON_SIZE).bold())
                .frame(width: LIBRARY_DOWNBAR_WIDTH, height: LIBRARY_DOWNBAR_HEIGHT)
                .background(
                    RoundedRectangle(cornerRadius: LIBRARY_BUTTON_CORNER_RADIUS)
                        .foregroundColor(preference.theme)
                )
        }
    }
    
    var contentview: some View {
        VStack {
            indicatorsview.padding([.top, .horizontal])

            Finishedmusclepanel(analysiseds)
            
            HStack { SPACE }
        }
        .background(
            ZStack {
                NORMAL_BG_COLOR.ignoresSafeArea()
                
                preference.themeprimarycolor
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(color: preference.themesecondarycolor, radius: 8, x: 2, y: 2)
        .padding(.horizontal, 10)
    }

    var indicatorsview: some View {
        HStack {
            if let _seconds: Int = workout.durationinseconds {
                Routineindicator(
                    description: "duration",
                    value: "\(_seconds.seconds2dayshourminuts)",
                    fontcolor: .white
                )
            }

            Routineindicator(
                description: "volume",
                value: "\(model.ofvolume(preference.ofweightunit))",
                fontcolor: .white
            )

            Routineindicator(
                description: "sets",
                value: "\(model.sets)",
                fontcolor: .white
            )
        }
        .frame(width: UIScreen.width - 80)
        .padding(.vertical, 5)
    }

    var congratulationview: some View {
        VStack {
            LocaleText("nicework")
                .font(.system(size: DEFINE_FONT_BIGGEST_SIZE + 4).weight(.heavy))
                .foregroundColor(NORMAL_GREEN_COLOR)
                .padding(5)

            if let _endtime = workout.endTime {
                LocaleText(_endtime.displayedyearmonthdate)
                    .font(.system(size: DEFINE_FONT_SMALL_SIZE).bold())
                    .foregroundColor(NORMAL_GRAY_COLOR)
            }
        }
    }

    
}
