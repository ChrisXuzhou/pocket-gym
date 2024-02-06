//
//  Muscledatatrendgraph.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/4/8.
//

import SwiftUI

struct Workoutsummarychart_Previews: PreviewProvider {
    static var previews: some View {
        let analysisedexercises = [
            Analysisedexercise(exerciseid: 19009,
                               workoutid: -1,
                               batchid: -1,
                               workday: Date(),
                               volume: 2300, onerm: 100,
                               sets: 3,
                               minrepeats: 10,
                               minweight: 50, maxweight: 90),
            Analysisedexercise(exerciseid: 19009,
                               workoutid: -1,
                               batchid: -1,
                               workday: Date(),
                               volume: 2800, onerm: 100,
                               sets: 3,
                               minrepeats: 10,
                               minweight: 50, maxweight: 90),
            Analysisedexercise(exerciseid: 19009,
                               workoutid: -1,
                               batchid: -1,
                               workday: Date(),
                               volume: 2600, onerm: 100,
                               sets: 3,
                               minrepeats: 10,
                               minweight: 50, maxweight: 90),
            Analysisedexercise(exerciseid: 19009,
                               workoutid: -1,
                               batchid: -1,
                               workday: Date(),
                               volume: 2900, onerm: 100,
                               sets: 3,
                               minrepeats: 10,
                               minweight: 50, maxweight: 90),
        ]

        let model = Workoutsummarymodel(
            analysisedexercises
        )

        DisplayedView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    Workoutsummarychart()
                }
                .environmentObject(model)
            }
        }
    }
}

fileprivate extension Analysisedexercise {
    var displayedvolume: String {
        String(format: "%.1f", volume)
    }
}

struct Workoutsummarychart: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var model: Workoutsummarymodel
    

    var analysisedlist: [Analysisedexercise] {
        model.analysisedlist
    }
    
    var chartview: some View {
        
        Exercisechart(
            type: model.type,
            analysisedlist: analysisedlist
        )
        .padding(.vertical)
        .frame(height: 180)
    }

    var body: some View {
        VStack {
            
            chartview
            
        }
        .padding(.vertical, 10)
        .frame(height: 200)
        /*
         .background(
             NORMAL_BG_CARD_COLOR
         )
         
         */
    }
}
