//
//  Foldertree.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/9/3.
//

import SwiftUI

struct Foldertree_Previews: PreviewProvider {
    static var previews: some View {
        let mocked = Folderwrapper(Folder(id: 1, name: "aaaaaa"))

        DisplayedView {
            Foldertree(from: mocked) {
                _ in
            }
            .environmentObject(Foldersmodel.shared)
            .environmentObject(Folderroutinesmodel.shared)
        }
    }
}

struct Foldertree: View {
    @Environment(\.presentationMode) var presentmode
    @EnvironmentObject var foldersmodel: Foldersmodel
    var from: Folderwrapper?

    var selected: (_ folderwrapper: Folderwrapper?) -> Void

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            SettingPanel(name: "selectfolderstosave") {
                LazyVStack(spacing: 0) {
                    ForEach(0 ..< foldersmodel.rootfolders.count, id: \.self) {
                        idx in

                        let to = foldersmodel.rootfolders[idx]
                        Routinetreefolder(from: from, to: to, selected: selected)

                        LIGHT_LOCAL_DIVIDER
                    }

                    Routinetreefolder(from: from, selected: selected)
                }
            }
            
            // panel settings
        }
    }
}

struct Routinetreefolder: View {
    @Environment(\.presentationMode) var presentmode
    @EnvironmentObject var foldersmodel: Foldersmodel

    var from: Folderwrapper?
    var to: Folderwrapper?

    var selected: (_ to: Folderwrapper?) -> Void

    var body: some View {
        VStack(spacing: 0) {
            let disabled = (from?.folderid != nil) && (from?.folderid == to?.folderid)

            Button {
                selected(to)
                presentmode.wrappedValue.dismiss()
            } label: {
                Treefolderlabel(folderwrapper: to, disabled: disabled)
            }
            .disabled(disabled)
        }
    }
}

struct Treefolderlabel: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var foldersmodel: Foldersmodel
    @EnvironmentObject var routinesmodel: Folderroutinesmodel

    var folderwrapper: Folderwrapper?
    var disabled = false

    var name: String {
        folderwrapper?.folder.name ?? "myroutines"
    }

    var body: some View {
        HStack {
            HStack(spacing: 10) {
                
                Systemimage(name: "folder.fill", fontsize: 16)
                    .foregroundColor(NORMAL_LIGHTER_COLOR)
                
                LocaleText(name)
            }
            .font(.system(size: DEFINE_FONT_SMALL_SIZE, design: .rounded))

            SPACE
        }
        .foregroundColor(
            disabled ? NORMAL_LIGHT_TEXT_COLOR : NORMAL_LIGHTER_COLOR
        )
        .frame(height: 50)
        .padding(.leading, 10)
        .contentShape(Rectangle())
    }
}
