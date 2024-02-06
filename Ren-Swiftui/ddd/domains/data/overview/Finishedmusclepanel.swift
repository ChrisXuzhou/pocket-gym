//
//  Finishedmusclepanel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/5/11.
//

import SwiftUI

/*
 struct Finishedmusclepanel_Previews: PreviewProvider {
     static var previews: some View {
         let analysisedlist: [Analysisedexercise] = fetchanalysisedlist()

         DisplayedView {
             Finishedmusclepanel(analysisedlist,
                                         days: 10,
                                         activitydatatype: .workoutdata)
                 .environmentObject(Reviewdatamodel())
         }
     }
 }

 
 */

struct Finishedmusclepanel: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var activitydatamodel: Reviewdatamodel

    @ObservedObject var model: Reviewpanelmodel

    init(_ analysiseds: [Analysisedmuscle]) {
        model = Reviewpanelmodel(analysiseds)
    }

    @State var pagedto: Frontorback = .frontbody
    var frontorbacklist: [Frontorback] = [.frontbody, .backbody]

    var graphview: some View {
        HStack(spacing: 0) {
            Reviewbodygraph(pagedto: .frontbody)
            .frame(width: UIScreen.width / 3)

            Reviewbodygraph(pagedto: .backbody)
            .frame(width: UIScreen.width / 3)
        }
        .frame(height: 230)
    }

    var graphanddataview: some View {
        ZStack {
            graphview
        }
        .environmentObject(model)
    }

    var degreeview: some View {
        HStack(spacing: 5) {
            ForEach(Musclecolor.allCases, id: \.self) {
                musclecolor in

                RoundedRectangle(cornerRadius: 2)
                    .frame(width: 10, height: 10)
                    .foregroundColor(
                        musclecolor.color
                    )
            }
        }
        .foregroundColor(Color(.systemGray))
        .font(.system(size: 13))
        .frame(width: 200)
    }

    var body: some View {
        VStack {
            // degreeview

            SPACE.frame(height: 30)

            graphanddataview
        }
    }
}
