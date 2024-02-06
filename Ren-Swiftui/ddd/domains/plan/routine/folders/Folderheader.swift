//
//  Folderheader.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/9/1.
//

import SwiftUI

struct Folderheader_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Workoutsview()
        }
    }
}

let FOLDER_ICON_WIDTH: CGFloat = 25
let FOLDER_HEIGHT: CGFloat = 45
let FOLDER_BUTTON_WIDTH: CGFloat = 30
let FOLDER_BUTTON_HEIGHT: CGFloat = 45

let FOLDER_TITLE_FONT: CGFloat = DEFINE_FONT_SMALL_SIZE - 1

let FOLDER_TITLE_COLOR: Color = NORMAL_LIGHT_TEXT_COLOR

struct Folderheader: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var foldersmodel: Foldersmodel
    @EnvironmentObject var routinesmodel: Folderroutinesmodel
    @EnvironmentObject var folderisopen: Menuisopen

    @ObservedObject var folderwrapper: Folderwrapper

    /*
     * function variables
     */

    @StateObject var viewmore = Viewopenswitch()
    @StateObject var moveswitch = Viewopenswitch()
    @StateObject var editnameswitch = Viewopenswitch()

    var color: Color = NORMAL_BUTTON_COLOR
    var fontsize: CGFloat = DEFINE_FONT_SMALLER_SIZE

    var body: some View {
        content
            .sheet(isPresented: $editnameswitch.value) {
                TextfieldditorView(
                    textfield: .text,
                    value: folderwrapper.folder.name,
                    title: "foldername",
                    editor: Foldernameeditor(folderwrapper)
                )
            }
    }
}

/*
 * view
 */
extension Folderheader {
    var content: some View {
        HStack {
            HStack {
                HStack(spacing: 3) {
                    LocaleText(folderwrapper.folder.name, uppercase: true)

                    Text("(\(routinesmodel.folderid2routines[folderwrapper.folderid]?.count ?? 0))")
                }

                Image(systemName: isopened ? "chevron.up" : "chevron.down")
                    .font(.system(size: 13).weight(.heavy))
                    .foregroundColor(isopened ? preference.theme : color)
            }
            .font(.system(size: fontsize, design: .rounded))
            .foregroundColor(color)
            .contentShape(Rectangle())
            .onTapGesture {
                folderisopen.openfolder(folderwrapper)
            }

            SPACE

            if folderwrapper.folderid > -1 {
                moreopbutton
            }
        }
        .frame(height: FOLDER_HEIGHT)
    }

    var isopened: Bool {
        folderisopen.openedfolderid == folderwrapper.folderid
    }

    var moreopbutton: some View {
        Menu {
            Button(action: {
                editnameswitch.value = true
            }) {
                Label("\(preference.language("rename"))", systemImage: "folder.fill")
            }

            Button(role: .destructive) {
                foldersmodel.delete(folderwrapper)
            } label: {
                Label("\(preference.language("deletefolder"))", systemImage: "trash.fill")
            }

        } label: {
            Label("", systemImage: "ellipsis")
        }
        .menuStyle(Foldermenustyle())
        .frame(height: FOLDER_ROUTINE_HEADER_HEIGHT)
        .contentShape(Rectangle())
    }
}

struct Foldermenustyle: MenuStyle {
    var color: Color = PreferenceDefinition.shared.theme
    var bgcolor: Color = PreferenceDefinition.shared.theme.opacity(0.2)

    func makeBody(configuration: Configuration) -> some View {
        Menu(configuration)
            .offset(x: 4, y: -4)
            .font(.system(size: DEFINE_FONT_SMALLER_SIZE).weight(.heavy))
            .foregroundColor(color)
            .padding(4)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(bgcolor)
            )
            .frame(height: 40)
    }
}

/*
 Button {
     viewmore.value = true
 } label: {
     Image(systemName: "ellipsis")
         .font(.system(size: DEFINE_FONT_SIZE, design: .rounded).weight(.heavy))
         .foregroundColor(preference.theme)
         .frame(width: FOLDER_BUTTON_WIDTH, height: FOLDER_HEIGHT)
 }
 */
