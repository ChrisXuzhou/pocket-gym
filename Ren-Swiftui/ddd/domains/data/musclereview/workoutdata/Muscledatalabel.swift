//
//  Muscledatalabel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/4/8.
//

import Algorithms
import SwiftUI

let MUSCLE_DATA_SIZE: CGFloat = 100
let MUSCLE_LABEL_HEIGHT: CGFloat = MUSCLE_DATA_SIZE + 60


/*
 
 
 struct Muscledatalabel: View {
     let lastdays: Int
     let muscledescriptor: Muscledescripor

     func labeldataview(_ value: String, description: String, focused: Bool) -> some View {
         VStack(alignment: .leading) {
             Text(value)
                 .font(.system(size: 35).bold())
                 .foregroundColor(
                     focused ? .white : NORMAL_GRAY_COLOR
                 )

             LocaleText(description)
                 .font(.system(size: DEFINE_FONT_SMALL_SIZE - 2))
                 .foregroundColor(
                     focused ? .white : NORMAL_GRAY_COLOR
                 )

             if focused {
                 RoundedRectangle(cornerRadius: 3)
                     .frame(width: 18, height: 5, alignment: .center)
                     .foregroundColor(.white)
             }
         }
         .frame(width: MUSCLE_DATA_SIZE, height: MUSCLE_DATA_SIZE)
         .contentShape(Rectangle())
         .scaleEffect(focused ? 1.3 : 1.0)
     }

     var dataview: some View {
         HStack {
             SPACE

             labeldataview(
                 "\(muscledescriptor.analysisedlist.count)",
                 description: "workout",
                 focused: pagedto == .workoutdata
             )
             .onTapGesture {
                 pagedto = .workoutdata
             }

             labeldataview(
                 "\(muscledescriptor.exerciseidlist.count)",
                 description: "exercisenumber",
                 focused: pagedto == .exercisedata
             )
             .onTapGesture {
                 pagedto = .exercisedata
             }

             SPACE
         }
     }

     var lastdaysview: some View {
         HStack(alignment: .lastTextBaseline, spacing: 3) {
             SPACE

             LocaleText("lastdays")
                 .font(.system(size: DEFINE_FONT_SMALL_SIZE - 2).bold())

             Text("\(lastdays)").bold()
                 .font(.system(size: DEFINE_FONT_SMALL_SIZE))

             LocaleText("days")
                 .font(.system(size: DEFINE_FONT_SMALL_SIZE - 2).bold())
         }
         .foregroundColor(NORMAL_GRAY_COLOR)
         .padding([.bottom, .trailing])
     }

     var body: some View {
         ZStack {
             VStack(spacing: 0) {
                 SPACE

                 dataview
                     .padding(.vertical)

                 lastdaysview
             }

             // musclelayer
         }
         .frame(height: MUSCLE_LABEL_HEIGHT)
     }
 }
 
 */

// lastdaysview
