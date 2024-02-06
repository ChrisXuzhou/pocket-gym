//
//  planoverviewcontent.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/5/8.
//

import SwiftUI

struct planoverviewcontent_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            planoverviewcontent(Date().systemedyearmonthdate)
        }
    }
}

struct planoverviewcontent: View {
    @EnvironmentObject var modify: Modify
    @StateObject var model: Calendarbyweekviewcontentmodel

    init(_ day: String) {
        _model = StateObject(wrappedValue: Calendarbyweekviewcontentmodel(day))
    }

    var plantasklistview: some View {
        VStack {
            let _workoutlist = model.workoutlist

            if _workoutlist.isEmpty {
                RestoffView()
            } else {
                HStack {
                    bartitle("tasks")

                    if let _displayed = Date.ofsystemedyearmonthdate(model.day)?.displayedyearmonthdate {
                        bartitle(_displayed)
                            .padding(.horizontal)
                    }

                    SPACE
                }
                .padding(.horizontal, 5)

                ForEach(_workoutlist, id: \.id) {
                    _workout in

                    let task = model.ofplantask(_workout.id!)
                    Planworkoutlabel(task, workout: _workout)
                }
            }

            SPACE
        }
        .frame(minHeight: 150)
        .padding(.horizontal, 5)
        .padding(.vertical)
    }

    var planlistview: some View {
        VStack {
            if !model.plantasklist.isEmpty {
                Divider()
                    .padding(.horizontal, 5)
                    .padding(.bottom)

                HStack {
                    bartitle("plansinprogress")
                    SPACE
                }
                .padding(.horizontal, 15)

                Planlistview(model.plantasklist)
            }

            SPACE
        }
        .frame(minHeight: 150)
        .padding(.vertical)
    }

    var body: some View {
        LazyVStack {
            plantasklistview

            planlistview
        }
    }
}
