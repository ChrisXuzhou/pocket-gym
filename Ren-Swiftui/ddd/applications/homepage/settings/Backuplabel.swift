/*
 //
 //  Backuplabel.swift
 //  Ren-Swiftui
 //
 //  Created by betterchris on 2022/8/9.
 //

 import SwiftUI

 struct Backuplabel_Previews: PreviewProvider {
     static var previews: some View {
         DisplayedView {
             Backuplabel()
         }

         /*
          DisplayedView {
              VStack {
                  Backupprocess(labelname: "Backup workout",
                                finishedid: 30, lastid: 90)
              }
          }

          */
     }
 }

 struct Backuplabel: View {
     @StateObject var model = Backupmodel()

     var body: some View {
         VStack {
             if let _backup = model.backuprecord {
                 if let _err = _backup.err {
                     LocaleText(_err)
                         .foregroundColor(NORMAL_RED_COLOR)
                         .font(
                             .system(size: DEFINE_FONT_SMALLER_SIZE)
                         )
                         .padding(.vertical)
                         .padding(.horizontal, 50)
                 }

                 Backupprocess(labelname: "backupworkout",
                               finishedid: _backup.workoutfinishedid,
                               lastid: _backup.workoutidlastid)

                 Backupprocess(labelname: "backupexercise",
                               finishedid: _backup.exercisefinishedid,
                               lastid: _backup.exerciselastid)

                 Backupprocess(labelname: "backupprogram",
                               finishedid: _backup.programfinishedid,
                               lastid: _backup.programlastid)

                 Backupprocess(labelname: "backupworkout",
                               finishedid: _backup.planfinishedid,
                               lastid: _backup.planlastid)

                 if !_backup.isfinished() {
                     LocaleText(_backup.createtime.displayedshoryearmonthdate)
                         .foregroundColor(NORMAL_LIGHT_GRAY_COLOR)
                         .font(
                             .system(size: DEFINE_FONT_BIG_SIZE)
                                 .weight(.heavy)
                         )
                         .padding(.vertical)
                 }

             }
             /*
              else {
                 LocaleText("nobackupyet")
                     .foregroundColor(NORMAL_LIGHT_GRAY_COLOR)
                     .font(
                         .system(size: DEFINE_FONT_BIG_SIZE)
                             .weight(.heavy)
                     )
                     .padding(.vertical)
             }
              
              */
             
         }
         .padding(.vertical, 30)
     }
 }

 struct Backupprocess: View {
     @EnvironmentObject var preference: PreferenceDefinition

     var labelname: String

     var finishedid: Int64?
     var lastid: Int64 = -1

     var body: some View {
         HStack(alignment: .lastTextBaseline, spacing: 10) {
             if let _finishedid = finishedid {
                 if lastid > _finishedid {
                     let _progress: Double =
                         Double(_finishedid) / Double(lastid) * 100.0

                     LocaleText(labelname)
                         .font(
                             .system(size: DEFINE_FONT_SMALLER_SIZE - 2)
                         )

                     LocaleText("\(String(format: "%.0f", _progress))%")
                         .font(
                             .system(size: DEFINE_FONT_SMALLER_SIZE,
                                     design: .rounded).bold()
                         )
                         .foregroundColor(
                             _progress >= 100 ?
                                 NORMAL_GREEN_COLOR : preference.theme
                         )
                 }
             }
         }
         .foregroundColor(NORMAL_LIGHTER_COLOR)
     }
 }

 
 */
