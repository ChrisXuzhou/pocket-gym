
/*
 //
 //  Planworkoutuptab.swift
 //  Ren-Swiftui
 //
 //  Created by betterchris on 2022/3/19.
 //

 
 import SwiftUI

 struct Routineviewuptab_Previews: PreviewProvider {
     static var previews: some View {
         DisplayedView {
             ContentView()
         }
     }
 }

 struct Routineviewuptab: View {
     @Binding var present: Bool
     @Environment(\.presentationMode) var presentmode
     @EnvironmentObject var preference: PreferenceDefinition

     @EnvironmentObject var viewmodel: Routineviewmodel
     @EnvironmentObject var model: Workoutandeachlogmodel
     @EnvironmentObject var editormodel: Routineeditormodel

     @Binding var showsummary: Bool

     @StateObject var moreroutine = Viewmore()
     @StateObject var converttoroutine = Viewopenswitch()

     func close() {
         present = false
         presentmode.wrappedValue.dismiss()
     }

     var name: String {
         if let _name = model.workout.name {
             return _name
         }

         return model.muscleids.joined(separator: ", ")
     }

     var color: (Color, Color) {
         if showsummary {
             return (.white, Color.clear)
         }

         if viewmodel.state == .workout {
             if let _issucceed = model.issucceed {
                 return (Color.white, _issucceed ? NORMAL_GREEN_COLOR : NORMAL_RED_COLOR)
             }
         }

         return (NORMAL_LIGHTER_COLOR, NORMAL_BG_COLOR)
     }

     var body: some View {
         VStack {
             let _color = color

             HStack(spacing: 0) {
                 if viewmodel.vieweditatble == .editable {
                     Button {
                         editormodel.save()
                         viewmodel.vieweditatble = .onlyview
                     } label: {
                         LocaleText("finish")
                             .font(.system(size: DEFINE_FONT_SMALL_SIZE).bold())
                             .foregroundColor(_color.0)
                     }
                 } else {
                     Button {
                         close()
                     } label: {
                         Backarrow(color: _color.0)
                     }
                     .padding(.trailing, 10)
                 }

                 SPACE

                 if !showsummary && viewmodel.vieweditatble == .onlyview {
                     LocaleText(name, linelimit: 1, usescale: false)
                         .font(.system(size: UP_HEADER_TITLE_FONT_SIZE).bold())
                         .foregroundColor(_color.0)
                 }

                 SPACE

                 if viewmodel.vieweditatble != .editable {
                     HStack(spacing: 20) {
                         
                         
                         Button {
                             viewmodel.vieweditatble = .editable
                         } label: {
                             Pencile(imgsize: 20)
                                 .foregroundColor(_color.0)
                         }

                         Button {
                             moreroutine.value = true
                         } label: {
                             Moreshape(imgsize: 20, color: _color.0)
                         }
                     }
                 }
             }
             .frame(height: MIN_UP_TAB_HEIGHT)
             .padding(.horizontal)
             .background(
                 _color.1.opacity(0.85).ignoresSafeArea()
             )
             .confirmationDialog("", isPresented: $moreroutine.value) {
                 Button("\(preference.language(model.ofmark ? "mark" : "unmark"))") {
                     model.togglemark()
                 }

                 Button("\(preference.language("duplicate"))") {
                     let _workout = model.workout

                     DispatchQueue.global().async {
                         _workout
                             .ascopier
                             .copy()
                     }
                 }

                 Button("\(preference.language("delete"))", role: .destructive) {
                     DispatchQueue.global().async {
                         deleteItem()
                     }
                 }
             }
             /*

              .fullScreenCover(isPresented: $converttoroutine.value) {
                  /*
                   Routineconvertpage(present: $converttoroutine.value) { level in
                       _ = model
                           .templatecreater
                           .buildatemplate(level)
                   }
                   */

                  Folderroutinemoveview {
                      selectedfolder in

                      let folderid = selectedfolder?.folderid ?? nil

                      _ = model
                          .templatecreater
                          .buildatemplate(folderid: folderid)
                  }
                  .environmentObject(model)
                  .environmentObject(Foldersmodel())
              }

              */
         }
     }
 }

 extension Routineviewuptab {
     func deleteItem() {
         if let _workoutid = model.workout.id {
             deleteworkout(_workoutid)
         }
     }
 }

 
 */
