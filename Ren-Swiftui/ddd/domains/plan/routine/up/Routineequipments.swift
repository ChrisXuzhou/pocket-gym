//
//  RoutineequipmentView.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/23.
//

import SwiftUI

struct Routineequipments: View {
    @EnvironmentObject var preference: PreferenceDefinition

    @EnvironmentObject var model: Workoutandeachlogmodel

    var body: some View {
        equipmentsview
    }

    var equipmentnamelist: String {
        "" //model.equipmentnamelist(preference).joined(separator: ",  ")
    }

    var equipmentsview: some View {
        VStack(alignment: .leading) {
            bartitle(LANGUAGE_EQUIPMENTS)

            let namelist = equipmentnamelist

            if namelist.isEmpty {
                Emptycontentpanel()
            } else {
                Text(equipmentnamelist)
                    .font(.system(size: DEFINE_FONT_SMALLER_SIZE))
                    .foregroundColor(NORMAL_LIGHTER_COLOR)
                    .lineLimit(3)
                    .lineSpacing(5)
                
            }
        }
        .padding(.top, 5)
        .padding()
        .padding(.leading)
    }
}
