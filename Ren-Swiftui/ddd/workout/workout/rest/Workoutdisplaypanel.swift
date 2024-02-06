//
//  Workoutdisplaypanel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/5/12.
//

import SwiftUI

struct Workoutdisplaypanel: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var restmodel: Workoutrestmodel
    @EnvironmentObject var model: Workoutmodel

    var body: some View {
        ZStack {
            smalllabel
        }
    }
}

extension Workoutdisplaypanel {
    var smalllabel: some View {
        HStack {
            
            Workoutupdatalabel(workoutid: model.workout.id!)

            if let _timer = restmodel.restimer {
                KSTimerView(
                    completedTime: _timer.ofcompletetime,
                    timerInterval: _timer.limittimeinterval) {
                    counter in

                    _timer.callback(counter)

                    withAnimation {
                        restmodel.restimer = nil
                        restmodel.objectWillChange.send()
                    }
                }
                .background(
                    NORMAL_GREEN_COLOR.opacity(0.1)
                )
                .clipShape(
                    RoundedRectangle(cornerRadius: 8)
                )
                .padding(.leading, 5)
                .frame(width: 155)
            } else {
                SPACE.frame(width: UIScreen.width / 3)
            }
        }
        .padding(.leading, 10)
        .background(
            ZStack {
                NORMAL_BG_CARD_COLOR

                preference.themesecondarycolor.opacity(0.5)
            }
            .shadow(color: NORMAL_BG_COLOR, radius: 3, x: 0, y: 3)
        )
    }
}

extension Workoutdisplaypanel {
    var timereditorlayer: some View {
        ZStack {
            NORMAL_BG_COLOR.ignoresSafeArea()
        }
    }
}
