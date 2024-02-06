/*
 //
 //  Routinelabel.swift
 //  Ren-Swiftui
 //
 //  Created by betterchris on 2022/3/22.
 //

 import SwiftUI

 struct Routinelabel_Previews: PreviewProvider {
     static var previews: some View {
         let mockedtemplate = Routine(mocktemplate())

         DisplayedView {
             VStack {
                 Routinelabel(mockedtemplate,
                              fontcolor: NORMAL_LIGHTER_COLOR,
                              backgroundcolor: NORMAL_BG_CARD_COLOR)
                     .id(1)
                 Routinelabel(mockedtemplate, unpacked: true,
                              fontcolor: NORMAL_LIGHTER_COLOR,
                              backgroundcolor: NORMAL_BG_CARD_COLOR)
                     .id(2)
             }
             .padding(.leading, 50)
         }
     }
 }

 let TEMPLATE_LABEL_HEIGHT: CGFloat = 100
 let TEMPLATE_HEADER_HEIGHT: CGFloat = 40


 class Routinelabelviewmodel: ObservableObject {
     @Published var offset: CGFloat = 0
     @Published var isSwiped: Bool = false
 }

 struct Routinelabel: View {
     @EnvironmentObject var preference: PreferenceDefinition
     @EnvironmentObject var trainingmodel: Trainingmodel

     var labelusage: Labelusage
     var templateusage: Routineusage
     var onselected: (Int64) -> Void

     var headertext: CGFloat
     var fontcolor: Color
     var backgroundcolor: Color?
     var showmorebutton = true
     var showuseroutinebutton: Bool
     var spacing: Bool
     
     
     @ObservedObject var routine: Routine

     /*
      * variables
      */
     @StateObject var unpacked: Viewopenswitch
     @StateObject var viewmodel: Routinelabelviewmodel
     @StateObject var viewmore = Viewmore()
     @StateObject var moveswitch = Viewopenswitch()

     @StateObject var presenttemplate = Viewopenswitch()

     init(_ routine: Routine,
          labelusage: Labelusage = .forview,
          templateusage: Routineusage = .onlyview,
          unpacked: Bool = true,
          headertext: CGFloat = DEFINE_FONT_SMALLER_SIZE,
          showmorebutton: Bool = true,
          showuseroutinebutton: Bool = false,
          spacing: Bool = false,
          fontcolor: Color = NORMAL_LIGHTER_COLOR,
          backgroundcolor: Color? = nil,
          onselected: @escaping (Int64) -> Void = { _ in }) {
         self.labelusage = labelusage
         self.templateusage = templateusage
         _unpacked = StateObject(wrappedValue: Viewopenswitch(unpacked))
         self.showmorebutton = showmorebutton
         self.showuseroutinebutton = showuseroutinebutton

         self.headertext = headertext
         self.fontcolor = fontcolor
         self.backgroundcolor = backgroundcolor
         self.spacing = spacing
         self.onselected = onselected

         self.routine = routine
         _viewmodel = StateObject(wrappedValue: Routinelabelviewmodel())
     }

     var body: some View {
         ZStack(alignment: .top) {
             if templateusage == .onlyview {
                 NavigationLink(isActive: $presenttemplate.value) {
                     navilink
                 }
                 label: {
                     content
                 }
             } else if templateusage == .usetemplate {
                 content
                     .contentShape(Rectangle())
                     .onTapGesture {
                         onselected(routine.routine.id!)
                     }
             }

             if showmorebutton {
                 HStack {
                     SPACE

                     morebutton
                 }
                 .frame(height: TEMPLATE_HEADER_HEIGHT)
             }
         }
         .padding(.vertical, 5)
         .confirmationDialog("", isPresented: $viewmore.value) {
             Button("\(preference.language("move"))") {
                 moveswitch.value = true
             }

             Button("\(preference.language("duplicate"))") {
                 let _workout = routine.routine

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
         .contentShape(Rectangle())
         .clipped()
         /*
          
          .fullScreenCover(isPresented: $moveswitch.value) {
              Folderroutinemoveview {
                  folder in

                  var routine = model.workout
                  routine.folderid = folder?.folderid ?? nil
                  try! AppDatabase.shared.saveworkout(&routine)
              }
              .environmentObject(model)
          }
          
          */
     }
 }

 extension Routinelabel {
     var content: some View {
         VStack(alignment: .leading, spacing: 0) {
             labelheader

             labelcontent
                 .padding(.bottom, 5)
         }
         .foregroundColor(fontcolor)
     }

     var exercisepanel: some View {
         VStack {
             SPACE
             if !routine.batchs.isEmpty {
                 HStack(alignment: .top) {
                     let _displayedexercise = routine.exercises.joined(separator: ", ")

                     Text(_displayedexercise)
                         .tracking(0.7)
                         .lineSpacing(8)
                         .lineLimit(5)
                         .multilineTextAlignment(.leading)
                         .font(.system(size: DEFINE_FONT_SMALLER_SIZE, design: .rounded))

                     SPACE
                 }
             }
             SPACE
         }
     }
 }

 /*
  * content
  */
 /*
  extension Routinelabel {
      var labelcontent: some View {
          VStack {
              if unpacked.value {
                  HStack(spacing: 5) {
                      Workoutbatchdescription(
                          templateorworkout: .template,
                          exercisedeflist: model.batchexercisedeflist,
                          batcheachloglist: [],
                          spacing: 10,
                          fontsize: DEFINE_FONT_SMALLER_SIZE,
                          textcolor: NORMAL_LIGHTER_COLOR.opacity(0.8)
                      )

                      SPACE
                  }

                  if showuseroutinebutton {
                      Routineusebutton(
                          fontsize: DEFINE_FONT_SMALLEST_SIZE,
                          width: LIBRARY_DOWNBAR_WIDTH,
                          height: LIBRARY_DOWNBAR_HEIGHT - 10,
                          buttoncolor: NORMAL_LIGHT_GRAY_COLOR,
                          isrounded: true
                      )
                      .environmentObject(model)
                      .padding(.bottom, 3)
                  }

              } else {
                  exercisepanel
              }
          }
      }
  }
  
  */

 /*
  * header related.
  */
 extension Routinelabel {
     var labelheader: some View {
         VStack(spacing: 0) {
             let nameandnotnull = name

             HStack {
                 LocaleText(nameandnotnull.0, linelimit: 1, usescale: false)
                     .font(.system(size: headertext).bold())

                 SPACE

                 if showmorebutton {
                     SPACE.frame(width: 60)
                 }
             }
         }
         .frame(height: TEMPLATE_HEADER_HEIGHT)
     }

     var name: (String, Bool) {
         let _name: String = model.workout.name ?? ""
         if !_name.isEmpty {
             return (_name, true)
         }

         return (model.muscleids.joined(separator: ", "), false)
     }

     var indicatorsview: some View {
         HStack(alignment: .lastTextBaseline, spacing: 1) {
             Text("x")
                 .font(
                     .system(size: DEFINE_FONT_SMALLER_SIZE - 2)
                         .bold()
                 )

             Text("\(model.batchexercisedeflist.count)")
                 .tracking(0.6)
                 .font(
                     .system(size: DEFINE_FONT_SMALLER_SIZE)
                         .weight(.heavy)
                         .italic()
                 )
         }
     }
 }

 extension Routinelabel {
     
     var morebutton: some View {
         HStack {
             Button {
                 viewmore.value = true
             } label: {
                 Image(systemName: "ellipsis")
                     .font(.system(size: DEFINE_FONT_SIZE, design: .rounded).weight(.heavy))
                     .foregroundColor(NORMAL_BUTTON_COLOR)
                     .frame(width: FOLDER_BUTTON_WIDTH, height: TEMPLATE_HEADER_HEIGHT)
             }
         }
     }

     var navilink: some View {
         NavigationLazyView(
             
             Routinebetaview(routineusage: .onlyview,
                             routine: model.workout)
                 .environmentObject(preference)
                 .environmentObject(trainingmodel)
                 .navigationBarHidden(true)
                 .navigationBarBackButtonHidden(true)
             
             /*
              
                  Routineview(
                      state: .template,
                      routineusage: showuseroutinebutton ? .usetemplate : .onlyview,
                      workout: model.workout
                  )
                  .environmentObject(preference)
                  .environmentObject(trainingmodel)
                  .navigationBarHidden(true)
                  .navigationBarBackButtonHidden(true)
              
              */
         )
     }

     var overlayedview: some View {
         HStack(alignment: .top) {
             switch labelusage {
             case .forview:
                 HStack(alignment: .top) {
                     SPACE

                     if showmorebutton {
                         morebutton
                             .contentShape(Rectangle())
                     }
                 }
             case .forselect:
                 HStack {
                     SPACE
                 }
             }
         }
     }
 }

 extension Routinelabel {
     func onChanged(value: DragGesture.Value) {
         if value.translation.width < 0 {
             if viewmodel.isSwiped {
                 viewmodel.offset = value.translation.width - 90
             } else {
                 viewmodel.offset = value.translation.width
             }
         }
     }

     func onEnd(value: DragGesture.Value) {
         withAnimation(.easeOut) {
             if value.translation.width < 0 {
                 if -value.translation.width > UIScreen.main.bounds.width / 2 {
                     viewmodel.offset = -1000
                     deleteItem()
                 } else if -viewmodel.offset > 50 {
                     viewmodel.isSwiped = true
                     viewmodel.offset = -90
                 } else {
                     viewmodel.isSwiped = false
                     viewmodel.offset = 0
                 }
             } else {
                 viewmodel.isSwiped = false
                 viewmodel.offset = 0
             }
         }
     }

     func deleteItem() {
         if let _workoutid = model.workout.id {
             deleteworkout(_workoutid)
         }
     }
 }

 */
