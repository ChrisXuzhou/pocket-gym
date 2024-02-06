//
//  Libraryexerciselist.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/2/22.
//

import SwiftUI

struct Exerciselabellist: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var exerciseactioncontext: Exerciseactioncontext
    @ObservedObject var model: Exerciselabellistmodel

    var muscleid: String?

    init(exerciselist: [Exercisedef], muscleid: String? = nil) {
        model = Exerciselabellistmodel(exerciselist) // StateObject(wrappedValue: )
        self.muscleid = muscleid

        UITableView.appearance().showsVerticalScrollIndicator = false

        log("[init] exerciselist ...")
    }

    var recentusedview: some View {
        VStack(spacing: 0) {
            if !model.recentexerciselist.isEmpty {
                Exerciselabellistsection(
                    equipment: "recently"
                )
            }
        }
    }

    var contentview: some View {
        VStack(spacing: 10) {
            recentusedview
                .padding(.top, 10)

            let _orderedequipmentlist = model.orderedequipmentlist
            ForEach(0 ..< _orderedequipmentlist.count, id: \.self) {
                idx in

                let equipment = _orderedequipmentlist[idx]

                Exerciselabellistsection(
                    equipment: equipment
                )

                if idx < _orderedequipmentlist.count - 1 {
                    Divider().padding(.horizontal, 10)
                }
            }

            if exerciseactioncontext.showonlyview {
                SPACE.frame(height: 50)

                Newaexercisebutton(muscleid: muscleid)
            }

            SPACE.frame(height: 150)
        }
    }

    var body: some View {
        ScrollViewReader { proxy in

            ZStack {
                NORMAL_BG_COLOR

                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        contentview

                        SPACE
                    }
                }

                VStack {
                    HStack {
                        Libraryequipmentindex(
                            proxy: proxy,
                            equipments: model.orderedequipmentlist
                        )
                        .contentShape(Rectangle())
                        .frame(height: 50)
                        .offset(x: 0, y: 200)
                        .environmentObject(model)

                        SPACE
                    }

                    SPACE
                }
            }
        }
        .environmentObject(model)
        .ignoresSafeArea(.keyboard)
    }
}
