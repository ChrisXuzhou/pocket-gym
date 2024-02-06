
/*
 //
 //  Librarybetaviewuptab.swift
 //  Ren-Swiftui
 //
 //  Created by betterchris on 2022/2/22.
 //
 import SwiftUI

 struct Librarybetaviewuptab_Previews: PreviewProvider {
     static var previews: some View {
         DisplayedView {
             VStack {
             }
         }
     }
 }

 struct Librarybetaviewuptab: View {
     @EnvironmentObject var preference: PreferenceDefinition
     @EnvironmentObject var librarymodel: Librarybetamodel

     var showbackbutton: Bool = true

     /*
      * variables
      */
     @StateObject var newexerciseswitch = Viewopenswitch()

     var body: some View {
         HStack(spacing: 2) {
             if showbackbutton {
                 backbutton
                     .padding(.leading, 5)
             }

             searchbar

             newexercisebutton.padding(.leading, 5)
         }
         .padding(.horizontal, 10)
         .frame(height: MIN_UP_TAB_HEIGHT)
     }
 }

 extension Librarybetaviewuptab {
     var backbutton: some View {
         Button {
         } label: {
             Backarrow()
         }
         .padding(.trailing, 10)
     }

     var searchbar: some View {
         Newsearchpanel(searchtext: $librarymodel.searchtext)
     }

     var newexercisebutton: some View {
         Button {
             newexerciseswitch.value.toggle()
         } label: {
             Image(systemName: "plus")
                 .font(.system(size: DEFINE_FONT_SMALL_SIZE).weight(.heavy))
                 .frame(width: SEARCH_BAR_HEIGHT - 6, height: SEARCH_BAR_HEIGHT - 6, alignment: .center)
                 .foregroundColor(preference.theme)
                 .background(
                     Circle().foregroundColor(NORMAL_BG_GRAY_COLOR)
                 )
         }
         .shadow(color: preference.themesecondarycolor, radius: 6, x: 0, y: 1)
         .fullScreenCover(isPresented: $newexerciseswitch.value) {
             Exercisevieweditor(Libraryexercisemodel.shared.newemptyexercise(targetid: librarymodel.focusedid)) {
                 newexercise in

                 Libraryexercisemodel.shared.addnewexercise(newexercise)
             }
         }
     }
 }

 
 */
