//
//  Folderbuttons.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/9/25.
//

import SwiftUI

let BUTTON_NEW_WIDTH: CGFloat = (UIScreen.width - 40) / 2

struct Newfoldernewbutton: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var foldersmodel: Foldersmodel

    var folderwrapper: Folderwrapper?

    var body: some View {
        Button {
            foldersmodel.newfolder(folderwrapper)
        } label: {
            HStack {
                SPACE
                Image(systemName: "folder.fill.badge.plus")

                LocaleText("newfolder", usefirstuppercase: false)

                SPACE
            }
            .font(.system(size: DEFINE_FONT_SMALLER_SIZE).weight(.heavy))
            .frame(height: FOLDER_BUTTON_HEIGHT)
            .foregroundColor(.white)
            .background(NORMAL_BUTTON_COLOR)
            .clipShape(
                RoundedRectangle(cornerRadius: 3)
            )
        }
    }
}

struct Newroutinenewbutton: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var foldersmodel: Foldersmodel

    var folderwrapper: Folderwrapper?

    func createanewtemplate() {
        var newedworkout = Workout(stats: .template,
                                   name: "\(preference.language("newroutine"))",
                                   source: .user,
                                   folderid: folderwrapper?.folderid)
        try! AppDatabase.shared.saveworkout(&newedworkout)
    }

    var body: some View {
        Button {
            createanewtemplate()
        } label: {
            HStack {
                SPACE

                Image(systemName: "plus")

                LocaleText("newroutine", usefirstuppercase: false)

                SPACE
            }
            .font(.system(size: DEFINE_FONT_SMALLER_SIZE).weight(.heavy))
            .frame(height: FOLDER_BUTTON_HEIGHT)
            .foregroundColor(.white)
            .background(preference.theme)
            .clipShape(
                RoundedRectangle(cornerRadius: 3)
            )
        }
    }
}

struct Foldernewbutton: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var foldersmodel: Foldersmodel

    @StateObject var newswitch = Viewopenswitch()

    var folderwrapper: Folderwrapper?

    var body: some View {
        HStack(spacing: 0) {
            GeometryReader {
                reader in

                let width = (reader.size.width - 8) / 2

                HStack(spacing: 0) {
                    Newroutinenewbutton(folderwrapper: folderwrapper)
                        .frame(width: width)

                    SPACE

                    Newfoldernewbutton(folderwrapper: folderwrapper)
                        .frame(width: width)
                }
            }
        }
        .padding(.bottom)
        .frame(height: FOLDER_HEIGHT)
    }
}

struct Tapheretomovetoroot: View {
    var body: some View {
        HStack {
            Foldershape()
                .foregroundColor(NORMAL_GOLD_COLOR)
                .frame(width: FOLDER_ICON_WIDTH)

            let textcolor = NORMAL_LIGHTER_COLOR

            LocaleText("tapherenote", usefirstuppercase: false)
                .font(
                    .system(size: DEFINE_FONT_SMALLER_SIZE)
                        .bold()
                )
                .foregroundColor(textcolor)

            SPACE
        }
        .padding(.horizontal, 5)
        .frame(height: 50)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(NORMAL_BANANA_COLOR.opacity(0.3))
        )
        .padding(.horizontal, 10)
    }
}
