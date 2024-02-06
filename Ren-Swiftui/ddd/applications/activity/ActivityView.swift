//
//  ReviewView.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/4/5.
//

import SwiftUI

struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            ActivityView()
        }
    }
}

struct ActivityView: View {
    @EnvironmentObject var preference: PreferenceDefinition

    @State var pagedto: Activitypagedto = .calendar

    var uptabheader: some View {
        UptabHeaderView(
            present: .constant(false),
            showbackbutton: false,
            title: preference.language(LANGUAGE_ACTIVITY).capitalizingfirstletter()
        ) {
        }
        .padding(.horizontal)
    }

    var uptab: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                uptabheader

                Activityviewmenu(pagedto: $pagedto)
            }
            .background(
                NORMAL_BG_COLOR
            )

            SPACE
        }
    }

    var calendarbyweekview: some View = AnyView(Calendarbymonthview())

    var dataview: some View = AnyView(Reviewview())

    var contentview: some View {
        VStack {
            SPACE
                .frame(height: MIN_UP_TAB_HEIGHT + 38)

            VStack(spacing: 0) {
                TabView(selection: $pagedto) {
                    calendarbyweekview
                        .tag(Activitypagedto.calendar)
                        .navigationBarHidden(true)
                        .navigationTitle("")

                    dataview
                        .tag(Activitypagedto.data)
                        .navigationBarHidden(true)
                        .navigationTitle("")
                }
                
                
                SPACE
            }

        }
    }

    var bodyview: some View {
        ZStack {
            NORMAL_BG_COLOR

            contentview

            uptab
        }
    }

    var body: some View {
        bodyview
            .navigationBarHidden(true)
    }
}

/*
 VStack(spacing: 0) {
     switch pagedto {
     case .calendar:
         Calendarbymonthview
     case .data:
         dataview
     }
 }

 */
