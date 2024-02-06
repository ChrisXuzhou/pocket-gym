//
//  Settingsbar.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/7/21.
//

import SwiftUI

struct Commonsidebar: View {
    @Binding var present: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Settingsbar()

            SPACE
        }
    }
}

/*
 
 struct Settingsbar: View {
     @EnvironmentObject var preference: PreferenceDefinition

     /*
      * variables switch views open.
      */
     @EnvironmentObject var settingswitch: Settingswitch
     @EnvironmentObject var personalswitch: Personalswitch
     @EnvironmentObject var feedbackswitch: Feedbackswitch
     @EnvironmentObject var backupswitch: Backupswitch

     @StateObject var unlockswitch = Viewopenswitch()

     var logo: some View {
         HStack {
             SmallLogo(showimg: true, color: preference.theme)

             SPACE
         }
         .frame(height: MIN_UP_TAB_HEIGHT)
         .padding(.horizontal)
     }

     var personallabel: some View {
         Settingbaritem(img: Image("person"),
                        text: "personal")
             .contentShape(Rectangle())
             .onTapGesture {
                 personalswitch.value = true
             }
     }

     var prferencelabel: some View {
         Settingbaritem(img: Image("setting"),
                        imgsize: 27,
                        text: "settings")
             .contentShape(Rectangle())
             .onTapGesture {
                 settingswitch.value = true
             }
     }

     var feedbacklabel: some View {
         Settingbaritem(img: Image("message"),
                        imgsize: 24,
                        text: "feedback")
             .contentShape(Rectangle())
             .onTapGesture {
                 feedbackswitch.value = true
             }
     }

     var backuplabel: some View {
         Settingbaritem(img: Image("backup"),
                        imgsize: 23,
                        text: "datarecovery")
             .contentShape(Rectangle())
             .onTapGesture {
                 backupswitch.value = true
             }
     }

     var body: some View {
         VStack(alignment: .leading, spacing: 0) {
             logo
             
             SPACE.frame(height: 20)

             personallabel

             prferencelabel

             feedbacklabel

             backuplabel

             SPACE
         }
     }
 }
 
 */


struct Settingbaritem: View {
    @EnvironmentObject var preference: PreferenceDefinition

    var img: Image
    var imgsize: CGFloat = 30

    var text: String
    var isfocused: Bool = false

    var body: some View {
        ZStack {
            if isfocused {
                preference.themeprimarycolor
            }

            HStack(spacing: 0) {
                img
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: imgsize, height: imgsize, alignment: .center)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 32, height: 32, alignment: .center)
                    .padding(.trailing, 8)
                    .foregroundColor(NORMAL_BUTTON_COLOR)

                LocaleText(text, usefirstuppercase: false)
                    .font(
                        .system(size: DEFINE_FONT_SMALL_SIZE + 1)
                    )

                SPACE
            }
            .padding(.horizontal)
            .foregroundColor(NORMAL_COLOR)
        }
        .frame(height: LIST_ITEM_HEIGHT)
    }
}
