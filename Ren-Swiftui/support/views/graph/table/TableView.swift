//
//  TableView.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/4.
//

import SwiftUI

struct TableView_Previews: PreviewProvider {
    static var previews: some View {
        let tablevaluelist =
            [
                Tablevalue(first: "15", second: 25.0),
                Tablevalue(first: "12", second: 30.0),
                Tablevalue(first: "8", second: 35.0),
                Tablevalue(first: "8", second: 35.0),
            ]

        let tabletailvaluelist =
            [
                Tablevalue(first: "3m56s"),
                Tablevalue(first: "0s"),
                Tablevalue(first: "50s"),
                Tablevalue(first: "56s"),
            ]

        var exercisetablevaluelistsList: [Tablevaluelist] =
            [
                Tablevaluelist(title: "Dumbbell Bench Press", tablevaluelist: tablevaluelist),
                /*
                    Tablevaluelist(title: "Dumbbell Decline Bench Press", tablevaluelist: tablevaluelist),
                    Tablevaluelist(title: "Dumbbell Decline Fly", tablevaluelist: tablevaluelist),
                     */
                Tablevaluelist(tablevaluetype: .tabletail,
                               title: "Rest",
                               tablevaluelist: tabletailvaluelist),
            ]

        DisplayedView {
            TableView(
                watched: .constant(0),
                exercisetablevaluelistsList: exercisetablevaluelistsList
            )
        }
    }
}

struct TableView: View {
    @EnvironmentObject var preference: PreferenceDefinition

    @Binding var watched: Int?
    var exercisetablevaluelistsList: [Tablevaluelist]

    var number: Int {
        if exercisetablevaluelistsList.isEmpty {
            return 1
        }
        return exercisetablevaluelistsList[0].tablevaluelist.count
    }

    var tablevalueview: some View {
        HStack(spacing: 0) {
            ForEach(0 ..< exercisetablevaluelistsList.count, id: \.self) {
                idx in

                let exercisetablevaluelist: Tablevaluelist = exercisetablevaluelistsList[idx]
                let exercise = exercisetablevaluelist.title
                let tablevaluelist = exercisetablevaluelist.tablevaluelist

                Tableheaderandvalues(tablevaluetype: exercisetablevaluelist.tablevaluetype,
                                     idx: idx,
                                     total: exercisetablevaluelistsList.count,
                                     header: exercise,
                                     tablevaluelist: tablevaluelist)
                    .transition(.identity)
                    .onTapGesture {
                        withAnimation {
                            watched = idx
                        }
                    }
                    .opacity(
                        watched != idx ? 0.9 : 1
                    )
            }
        }
    }

    var tablenumberview: some View {
        Tablenumbers(rowcount: number,
                     columncount: exercisetablevaluelistsList.count)
    }

    var body: some View {
        HStack(spacing: 0) {
            tablenumberview.padding(.trailing, 5)
            tablevalueview
        }
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(preference.themesecondarycolor.opacity(0.3))
        )
    }
}
