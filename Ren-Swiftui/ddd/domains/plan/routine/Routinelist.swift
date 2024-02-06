/*
 //
 //  Routinelist.swift
 //  Ren-Swiftui
 //
 //  Created by betterchris on 2022/3/22.
 //

 import SwiftUI

 let ADDATEMPLATEBUTTON_HEIGHT: CGFloat = 30

 class Routinelistunpack: ObservableObject {
     @Published var value = true
 }

 struct Routinelist: View {
     @EnvironmentObject var preference: PreferenceDefinition

     @StateObject var model: Routinelistmodel

     var shownewtemplatebutton: Bool
     var labelusage: Labelusage
     var callback: (_ workoutid: Int64) -> Void

     init(source: Source = .system,
          shownewtemplatebutton: Bool = true,
          labelusage: Labelusage = .forview,
          callback: @escaping (_ workoutid: Int64) -> Void = { _ in }) {
         self.shownewtemplatebutton = shownewtemplatebutton
         self.labelusage = labelusage
         self.callback = callback

         _model = StateObject(wrappedValue: Routinelistmodel(source))
     }

     @StateObject var beginnerunpacked = Routinelistunpack()
     @StateObject var intermidiateunpacked = Routinelistunpack()
     @StateObject var advancedunpacked = Routinelistunpack()
     @StateObject var showroutineselector = Viewopenswitch()

     var body: some View {
         ZStack {
             NORMAL_BG_COLOR.ignoresSafeArea()

             VStack {
                 newatemplatebutton

                 routinecontentlist

                 SPACE
             }
         }
         .environmentObject(model)
     }
 }

 /*
  * button op
  */
 extension Routinelist {
     var newatemplatebutton: some View {
         VStack {
             if shownewtemplatebutton {
                 Newaroutinebutton()
                     .fullScreenCover(isPresented: $model.newatemplateview) {
                         LazycreateRoutineview()
                     }
                     .padding(.top)
             }
         }
     }
 }

 /*
  * content
  */
 extension Routinelist {
     var routinecontentlist: some View {
         VStack {
             if model.templatelist.isEmpty {
                 SPACE.frame(height: UIScreen.height / 5)
             } else {
                 LazyVStack(spacing: 8) {
                     if let beginnertemplatelist = model.level2templatelist[.beginner] {
                         if !beginnertemplatelist.isEmpty {
                             sectionlabel(level: .beginner, showdetail: beginnerunpacked.value)
                                 .onTapGesture {
                                     beginnerunpacked.value.toggle()
                                 }

                             if beginnerunpacked.value {
                                 let orderedtemplatelist = beginnertemplatelist.sorted { l, r in
                                     l.id! > r.id!
                                 }

                                 ForEach(orderedtemplatelist, id: \.id) {
                                     template in

                                     Routinelabel(
                                         template,
                                         labelusage: labelusage,
                                         templateusage: .usetemplate, unpacked: false,
                                         fontcolor: NORMAL_LIGHTER_COLOR,
                                         backgroundcolor: NORMAL_BG_CARD_COLOR
                                     )
                                     .onTapGesture {
                                         if labelusage == .forselect {
                                             self.callback(template.id!)
                                         }
                                     }
                                 }
                             }
                         }
                     }

                     if let intermediatetemplatelist = model.level2templatelist[.intermediate] {
                         if !intermediatetemplatelist.isEmpty {
                             sectionlabel(level: .intermediate, showdetail: intermidiateunpacked.value)
                                 .onTapGesture {
                                     intermidiateunpacked.value.toggle()
                                 }

                             if intermidiateunpacked.value {
                                 let orderedtemplatelist = intermediatetemplatelist.sorted { l, r in
                                     l.id! > r.id!
                                 }

                                 ForEach(orderedtemplatelist, id: \.id) {
                                     template in

                                     Routinelabel(
                                         template,
                                         labelusage: labelusage,
                                         templateusage: .usetemplate, unpacked: false,
                                         fontcolor: NORMAL_LIGHTER_COLOR,
                                         backgroundcolor: NORMAL_BG_CARD_COLOR
                                     )
                                     .onTapGesture {
                                         if labelusage == .forselect {
                                             self.callback(template.id!)
                                         }
                                     }
                                 }
                             }
                         }
                     }

                     if let advancedtemplatelist = model.level2templatelist[.advanced] {
                         if !advancedtemplatelist.isEmpty {
                             sectionlabel(level: .advanced, showdetail: advancedunpacked.value)
                                 .onTapGesture {
                                     advancedunpacked.value.toggle()
                                 }

                             if advancedunpacked.value {
                                 let orderedtemplatelist = advancedtemplatelist.sorted { l, r in
                                     l.id! > r.id!
                                 }

                                 ForEach(orderedtemplatelist, id: \.id) {
                                     template in

                                     Routinelabel(
                                         template,
                                         labelusage: labelusage,
                                         templateusage: .usetemplate, unpacked: false,
                                         fontcolor: NORMAL_LIGHTER_COLOR,
                                         backgroundcolor: NORMAL_BG_CARD_COLOR
                                     )
                                     .onTapGesture {
                                         if labelusage == .forselect {
                                             self.callback(template.id!)
                                         }
                                     }
                                 }
                             }
                         }
                     }
                 }
             }
         }
     }

     func sectionlabel(level: Programlevel, showdetail: Bool) -> some View {
         HStack {
             bartitle(level.rawValue, color: NORMAL_LIGHTER_COLOR.opacity(0.8))
             SPACE

             Image(systemName: showdetail ? "chevron.up" : "chevron.down")
                 .foregroundColor(
                     showdetail ? NORMAL_BUTTON_COLOR : preference.themeprimarycolor
                 )
                 .font(.system(size: DEFINE_FONT_SMALL_SIZE).bold())
         }
         .padding(.horizontal)
         .frame(height: 40)
         .contentShape(Rectangle())
     }
 }

 struct LazycreateRoutineview: View {
     @EnvironmentObject var model: Routinelistmodel

     var body: some View {
         VStack {
             if let _template = model.creatednewtemplate {
                 Routineview(state: .template,
                             routineusage: .onlyview,
                             workout: _template,
                             editing: true
                 )
             }
         }
     }
 }

 
 */
