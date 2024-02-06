//
//  ExerciseachivessView.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/2/27.
//

import SwiftUI

/*
 
 struct ExerciseresultsView_Previews: PreviewProvider {
     static var previews: some View {
         DisplayedView {
             VStack {
                 ScrollView(.vertical, showsIndicators: false) {
                     ExerciseresultsView(mockexercisedef())
                 }
             }
         }
     }
 }

 
 */

let RESULTS_GRAPH_WIDTH: CGFloat = 180

struct ExerciseresultsView: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @ObservedObject var model: Workoutsummarymodel

    init(_ exercise: Exercisedef) {
        model = Workoutsummarymodel(exercise)
    }

    var menuview: some View {
        VStack {
            HStack(spacing: 20) {
                SPACE

                HStack(spacing: 0) {
                    Picker("", selection: $model.type) {
                        ForEach(Exercisedatatype.allCases, id: \.self) {
                            LocaleText($0.rawValue, usefirstuppercase: false)
                                .tag($0)
                        }
                    }
                    .pickerStyle(.segmented)
                    .contentShape(Rectangle())
                }

                SPACE
            }
            .foregroundColor(NORMAL_GRAY_COLOR)
            .padding()
            .background(
                NORMAL_BG_COLOR.ignoresSafeArea().opacity(0.3)
            )
        }
    }

    var body: some View {
        LazyVStack(pinnedViews: [.sectionHeaders]) {
            Section {
                VStack {
                    Workoutsummarychart()
                        .padding(.vertical)
                        .background(
                            NORMAL_BG_CARD_COLOR
                        )

                    Workoutsummarydetail()
                        .padding(.vertical)

                    SPACE.frame(height: UIScreen.height / 2)
                }
                .environmentObject(model)
            }
            header: {
                menuview
            }
        }
    }
}
