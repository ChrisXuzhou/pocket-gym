//
//  Foldermoveview.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/9/3.
//

import SwiftUI

struct Foldermovesheet_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Foldermovesheet {
                _ in
            }
            .environmentObject(Foldersmodel())
        }
    }
}

struct Foldermovesheet: View {
    @Environment(\.presentationMode) var present
    @EnvironmentObject var preference: PreferenceDefinition
    @ObservedObject var foldersmodel: Foldersmodel

    var foldertitle: String
    var selected: (_ folder: Folderwrapper?) -> Void

    init(foldertitle: String = "movetofolder", selected: @escaping (_ folder: Folderwrapper?) -> Void) {
        self.foldertitle = foldertitle
        self.selected = selected
        self.foldersmodel = Foldersmodel()
    }

    /*
     var upheader: some View {
         HStack {
             Button {
                 presentmode.wrappedValue.dismiss()
             } label: {
                 CLOSE_IMG
             }

             SPACE

             LocaleText(foldertitle)
                 .font(.system(size: UP_HEADER_TITLE_FONT_SIZE).bold())
                 .foregroundColor(NORMAL_LIGHTER_COLOR)

             SPACE

             SPACE.frame(width: 20)
         }
         .frame(height: MIN_UP_TAB_HEIGHT)
         .padding(.horizontal)
         .background(
             NORMAL_BG_COLOR.ignoresSafeArea()
         )
     }
     */
    
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

            LocaleText(foldertitle)
                .font(.system(size: UP_HEADER_TITLE_FONT_SIZE))
                .foregroundColor(NORMAL_LIGHTER_COLOR)

            SPACE
            
            SPACE.frame(width: SHEET_BUTTON_WIDTH)

            /*
             Button {
                 withAnimation {
                     present.wrappedValue.dismiss()
                 }
             } label: {
                 Text(preference.language("save"))
                     .foregroundColor(preference.theme)
                     .font(.system(size: DEFINE_FONT_SMALL_SIZE))
                     .frame(width: SHEET_BUTTON_WIDTH, alignment: .trailing)
             }
             */
        }
        .font(.system(size: DEFINE_SHEET_FONT_SIZE))
        .padding(.horizontal)
        .frame(height: SHEET_HEADER_HEIGHT)
        .background(NORMAL_BG_CARD_COLOR)
    }

    var body: some View {
        ZStack {
            NORMAL_BG_COLOR.ignoresSafeArea()

            VStack(spacing: 0) {
                sheetupheader

                Foldertree {
                    selectedfolder in
                    selected(selectedfolder)
                }

                SPACE
            }
        }
        .environmentObject(foldersmodel)
    }
}
