//
//  Libraryequipmentselector.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/5/18.
//

import SwiftUI

/*
 
 struct Libraryequipmentselector_Previews: PreviewProvider {
     static var previews: some View {
         DisplayedView {
             Libraryequipmentselector(["chest", "shoulders"])
                 .environmentObject(Librarymodel())
         }
     }
 }

 struct Libraryequipmentselector: View {
     @EnvironmentObject var preference: PreferenceDefinition
     @EnvironmentObject var librarymodel: Librarymodel

     @ObservedObject var model: Exerciseequipmentseditormodel

     @Environment(\.presentationMode) var present

     init(_ selectedset: Set<String>) {
         model = Exerciseequipmentseditormodel(selectedset)
     }

     var contentview: some View {
         ScrollView(.vertical, showsIndicators: false) {
             VStack(spacing: 0) {
                 let definedidlist: [String] = LIBRARY_EQUIPMENTS

                 ForEach(0 ..< definedidlist.count, id: \.self) {
                     idx in

                     let id = definedidlist[idx]

                     HStack {
                         LocaleText(id)
                             .font(.system(size: DEFINE_FONT_SMALLER_SIZE))
                             .foregroundColor(NORMAL_COLOR)
                         SPACE

                         if model.isselected(id) {
                             Selected()
                         }
                     }
                     .frame(height: 38)
                     .padding(.horizontal, 5)
                     .padding(.vertical, 5)
                     .contentShape(Rectangle())
                     .onTapGesture {
                         model.addorremoveequipment(id)
                     }

                     if idx < definedidlist.count - 1 {
                         Divider().padding(.horizontal, 2)
                     }
                 }
             }
             .padding(10)
             .background(
                 RoundedRectangle(cornerRadius: 15)
                     .foregroundColor(NORMAL_BG_CARD_COLOR)
             )
             .padding(10)

             SPACE.frame(height: 30)
         }
     }

     var body: some View {
         ZStack {
             NORMAL_BG_COLOR.ignoresSafeArea()

             VStack(spacing: 0) {
                 sheetupheader

                 contentview
             }
         }
     }
 }

 extension Libraryequipmentselector {
     var sheetupheader: some View {
         HStack(alignment: .lastTextBaseline) {
             Button {
                 withAnimation {
                     present.wrappedValue.dismiss()
                 }
             } label: {
                 LocaleText("cancel")
                     .foregroundColor(NORMAL_LIGHTER_COLOR)
                     .font(.system(size: DEFINE_FONT_SMALL_SIZE))
                     .frame(width: SHEET_BUTTON_WIDTH, alignment: .leading)
             }

             SPACE

             LocaleText("equipments")
                 .font(.system(size: DEFINE_FONT_SMALL_SIZE).bold())
                 .foregroundColor(NORMAL_COLOR)

             SPACE

             Button {
                 withAnimation {
                     librarymodel.refreshequipments(model.selectedset)
                     present.wrappedValue.dismiss()
                 }
             } label: {
                 Text(preference.language("save"))
                     .foregroundColor(preference.theme)
                     .font(.system(size: DEFINE_FONT_SMALL_SIZE))
                     .frame(width: SHEET_BUTTON_WIDTH, alignment: .trailing)
             }
         }
         .font(.system(size: DEFINE_SHEET_FONT_SIZE))
         .padding(.horizontal)
         .frame(height: SHEET_HEADER_HEIGHT)
         .background(NORMAL_BG_CARD_COLOR)
     }
 }
 
 */
