//
//  Libraryexercisecontent.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/10/5.
//

import SwiftUI

struct Libraryexercisecontent_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Librarybetaview(showbackbutton: false)
                .navigationBarHidden(true)
        }
    }
}

struct Libraryexercisecontent: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var exercises: Libraryexercisemodel
    
    init() {
        UITableView.appearance().showsVerticalScrollIndicator = false
    }

    /*
     * variables
     */
    var keyfontsize: CGFloat = DEFINE_FONT_SMALLER_SIZE + 1
    var keycolor = NORMAL_LIGHT_TEXT_COLOR

    let columns = [
        GridItem(.fixed(RIGHT_GRID_WIDTH)),
        GridItem(.fixed(RIGHT_GRID_WIDTH)),
        GridItem(.fixed(RIGHT_GRID_WIDTH)),
    ]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(alignment: .leading, spacing: 10, pinnedViews: [.sectionHeaders]) {
                ForEach(EQUIPMENTS, id: \.self) {
                    equipment in

                    if let _ekeys: EquipmentKeyexercise = exercises.dictionary[equipment] {
                        if !_ekeys.dictionary.isEmpty {

                            Section {
                                EquipmentKeyexercisepanel(equipmentkeys: _ekeys)
                            } header: {
                                HStack {
                                    LocaleText(_ekeys.equipmentid)
                                        .font(.system(size: DEFINE_FONT_SMALL_SIZE, design: .rounded).bold())
                                        .foregroundColor(NORMAL_LIGHTER_COLOR)

                                    SPACE
                                }
                                .padding(.leading)
                                .frame(height: 32)
                                .background(NORMAL_BG_COLOR.opacity(0.9))
                            }

                            if equipment != "bodyweight" {
                                LOCAL_DIVIDER
                            }
                        }
                    }
                }
            }

            Copyright()

            SPACE.frame(height: MIN_DOWN_TAB_HEIGHT)
        }
    }
}

/*

 var body: some View {
     List {

         ForEach(EQUIPMENTS, id: \.self) {
             equipment in

             if let _ekeys: EquipmentKeyexercise = exercises.dictionary[equipment] {
                 if !_ekeys.dictionary.isEmpty {
                     Section {
                         EquipmentKeyexercisepanel(equipmentkeys: _ekeys)
                     } header: {
                         HStack {
                             LocaleText(_ekeys.equipmentid)
                                 .font(.system(size: DEFINE_FONT_SMALL_SIZE + 1, design: .rounded).bold())
                                 .foregroundColor(NORMAL_LIGHTER_COLOR)

                             SPACE
                         }
                         .padding(.leading)
                         .frame(height: 35)
                     }
                     .listRowInsets(EdgeInsets())
                     .listRowSeparator(.hidden)
                     .background(NORMAL_BG_COLOR)

                 }
             }
         }

         Copyright()
             .listRowInsets(EdgeInsets())
             .listRowSeparator(.hidden)

         SPACE.frame(height: MIN_DOWN_TAB_HEIGHT)
             .listRowSeparator(.hidden)
     }
     .background(NORMAL_BG_COLOR)
     .listStyle(.plain)
 }

 */

/*

 var content: some View {
     ScrollView(.vertical, showsIndicators: false) {
         LazyVStack(alignment: .leading, spacing: 10, pinnedViews: [.sectionHeaders]) {
             ForEach(EQUIPMENTS, id: \.self) {
                 equipment in

                 if let _ekeys: EquipmentKeyexercise = exercises.dictionary[equipment] {
                     if !_ekeys.dictionary.isEmpty {
                         Section {
                             EquipmentKeyexercisepanel(equipmentkeys: _ekeys)
                         } header: {
                             HStack {
                                 LocaleText(_ekeys.equipmentid)
                                     .font(.system(size: DEFINE_FONT_SMALL_SIZE, design: .rounded).bold())
                                     .foregroundColor(NORMAL_LIGHTER_COLOR)

                                 SPACE
                             }
                             .padding(.leading)
                             .frame(height: 35)
                             .background(NORMAL_BG_COLOR.opacity(0.9))
                         }

                         if equipment != "bodyweight" {
                             LOCAL_DIVIDER
                         }
                     }
                 }
             }
         }
     }
 }

 var body: some View {
     ScrollView(.vertical, showsIndicators: false) {
         LazyVStack(alignment: .leading, spacing: 10, pinnedViews: [.sectionHeaders]) {
             ForEach(EQUIPMENTS, id: \.self) {
                 equipment in

                 if let _ekeys: EquipmentKeyexercise = exercises.dictionary[equipment] {
                     if !_ekeys.dictionary.isEmpty {

                         Section {
                             EquipmentKeyexercisepanel(equipmentkeys: _ekeys)
                         } header: {
                             HStack {
                                 LocaleText(_ekeys.equipmentid)
                                     .font(.system(size: DEFINE_FONT_SMALL_SIZE, design: .rounded).bold())
                                     .foregroundColor(NORMAL_LIGHTER_COLOR)

                                 SPACE
                             }
                             .padding(.leading)
                             .frame(height: 35)
                             .background(NORMAL_BG_COLOR.opacity(0.9))
                         }

                         if equipment != "bodyweight" {
                             LOCAL_DIVIDER
                         }
                     }
                 }
             }
         }

         /*

          VStack(spacing: 15) {
              ForEach(EQUIPMENTS, id: \.self) {
                  equipment in

                  if let _ekeys: EquipmentKeyexercise = exercises.dictionary[equipment] {
                      if !_ekeys.dictionary.isEmpty {
                          EquipmentKeyexercisepanel(equipmentkeys: _ekeys)

                          if equipment != "bodyweight" {
                              LOCAL_DIVIDER
                          }
                      }
                  }
              }
          }
          .padding(.top)

          */

         Copyright()

         SPACE.frame(height: MIN_DOWN_TAB_HEIGHT)
     }
 }

 */



/*
 // key header
 HStack {
     SPACE
     LocaleText(ke.key)
         .font(.system(size: keyfontsize, design: .rounded).italic())
         .foregroundColor(keycolor)
     SPACE
 }
 .padding(.horizontal)
 .padding(.vertical, 5)
 .listRowBackground(NORMAL_BG_COLOR)

 // key content
 LazyVGrid(columns: columns, spacing: 7) {
     ForEach(0 ..< ke.exercises.count, id: \.self) { idx in

         if let _e = ke.exercises[idx] {
             Exercisepanel(exercise: _e)
         }
     }
 }
 .listRowBackground(NORMAL_BG_COLOR)
 
 */


/*
 
 var body: some View {
     List {
         ForEach(EQUIPMENTS, id: \.self) {
             equipment in

             if let _ekeys: EquipmentKeyexercise = exercises.dictionary[equipment] {
                 if !_ekeys.dictionary.isEmpty {
                     Section {

                         ForEach(_ekeys.keys, id: \.self) {
                             key in

                             if let ke: Keyexercise = _ekeys.dictionary[key] {

                                 Keyexercisepanel(keyexercise: ke)
                                     .listRowBackground(NORMAL_BG_COLOR)
                                 
                             }
                         }

                     } header: {
                         HStack {
                             LocaleText(_ekeys.equipmentid)
                                 .font(.system(size: DEFINE_FONT_SMALL_SIZE + 1, design: .rounded).bold())
                                 .foregroundColor(NORMAL_LIGHTER_COLOR)

                             SPACE
                         }
                         .padding(.leading)
                         .frame(height: 35)
                         .background(NORMAL_BG_COLOR)
                     }
                     .listRowInsets(EdgeInsets())
                     .listRowSeparator(.hidden)
                     .listRowBackground(NORMAL_BG_COLOR)
                 }
             }
         }

         Copyright()
             .listRowInsets(EdgeInsets())
             .listRowSeparator(.hidden)
             .listRowBackground(NORMAL_BG_COLOR)

     }
     .background(NORMAL_BG_COLOR)
     .listStyle(.plain)
     .buttonStyle(BorderlessButtonStyle())
 }
 
 
 
 */
