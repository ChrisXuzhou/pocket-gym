//
//  Folderselectionview.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/12/11.
//
import SwiftUI

struct Folderselectionview_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            ContentView()
        }
    }
}

struct Folderselectionview: View {
    @Environment(\.presentationMode) var presentmode
    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var foldersmodel: Foldersmodel
    @EnvironmentObject var routinesmodel: Folderroutinesmodel

    var name: String
    @State var selectedoption: Folderwrapper
    var options: [Folderwrapper] {
        foldersmodel.allfolders
    }

    /*
     * variables
     */
    @StateObject var showheader = Viewopenswitch()
    @StateObject var newfolderswitch = Viewopenswitch()

    var callback: (_ option: Folderwrapper) -> Void

    var body: some View {
        ZStack {
            NORMAL_BG_COLOR.ignoresSafeArea()

            VStack(spacing: 0) {
                upheader

                ScrollView(.vertical, showsIndicators: false) {
                    GeometryReader {
                        geometry in

                        if geometry.frame(in: .global).minY >= 80 {
                            hiddenbar
                        }
                    }

                    scrollheader

                    optionsview
                }

                SPACE
            }

            VStack {
                SPACE

                addfolderbutton
            }
        }
    }
}

/*
 *
 */
extension Folderselectionview {
    var upheader: some View {
        HStack(spacing: 10) {
            Button {
                presentmode.wrappedValue.dismiss()
            } label: {
                Backarrow()
            }

            SPACE

            if showheader.value {
                LocaleText(name)
                    .font(.system(size: UP_HEADER_TITLE_FONT_SIZE).bold())
                    .foregroundColor(NORMAL_LIGHTER_COLOR)
            }

            SPACE

            SPACE.frame(width: 18)
        }
        .frame(height: MIN_UP_TAB_HEIGHT)
        .padding(.horizontal)
        .background(NORMAL_BG_COLOR)
    }

    var scrollheader: some View {
        HStack {
            LocaleText(
                name,
                usefirstuppercase: false,
                alignment: .center,
                usescale: false
            )
            .foregroundColor(NORMAL_LIGHTER_COLOR)
            .font(.system(size: DEFINE_FONT_BIGGEST_SIZE + 8).weight(.heavy))

            SPACE
        }
        .frame(height: MIN_UP_TAB_HEIGHT)
        .padding(.horizontal)
    }

    var hiddenbar: some View {
        Text(" ")
            .frame(width: UIScreen.width, height: 2)
            .contentShape(Rectangle())
            .onAppear {
                self.showheader.value = false
            }
            .onDisappear {
                self.showheader.value = true
            }
    }
}

extension Folderselectionview {
    var optionsview: some View {
        SettingPanel {
            VStack(spacing: 0) {
                ForEach(0 ..< options.count, id: \.self) {
                    idx in

                    let option: Folderwrapper = options[idx]
                    let cnt: Int = routinesmodel.folderid2routines[option.folderid]?.count ?? 0
                    let key = "\(preference.language(option.folder.name)) (\(cnt))"

                    
                    if option.folderid == EMPTY_FOLDER_ID {
                        HStack {
                            Listitemlabel(
                                keyortitle: key) {
                                    if selectedoption == option {
                                        Image(systemName: "checkmark")
                                            .font(.system(size: DEFINE_FONT_SMALL_SIZE).bold())
                                            .foregroundColor(PreferenceDefinition.shared.theme)
                                    }
                                }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            self.selectedoption = option

                            DispatchQueue.main.async {
                                self.callback(option)
                            }
                        }
                        .id(idx)
                    } else {
                        HStack {
                            Listitemlabel(
                                keyortitle: key) {
                                    if selectedoption == option {
                                        Image(systemName: "checkmark")
                                            .font(.system(size: DEFINE_FONT_SMALL_SIZE).bold())
                                            .foregroundColor(PreferenceDefinition.shared.theme)
                                    }
                                }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            self.selectedoption = option

                            DispatchQueue.main.async {
                                self.callback(option)
                            }
                        }
                        .id(idx)
                        .onDelete {
                            foldersmodel.delete(option)
                        }
                    }
                    

                    if idx != options.count - 1 {
                        LIGHT_LOCAL_DIVIDER
                    }
                }
            }
        }
    }
}

extension Folderselectionview {
    var addfolderbutton: some View {
        HStack {
            SPACE
            Button {
                newfolderswitch.value = true
            } label: {
                HStack(spacing: 5) {
                    Image(systemName: "plus")
                        .font(.system(size: DEFINE_FONT_SMALLER_SIZE).weight(.heavy))
                    LocaleText("newfolder", uppercase: true)
                }
                .font(.system(size: DEFINE_FONT_SMALL_SIZE).bold())
                .foregroundColor(preference.theme)
                .shadow(color: preference.themesecondarycolor, radius: 8, x: 0, y: 5)
            }
            SPACE
        }
        .frame(height: MIN_DOWN_TAB_HEIGHT)
        .background(
            NORMAL_UPTAB_BACKGROUND_COLOR
        )
        .fullScreenCover(isPresented: $newfolderswitch.value) {
            Textfieldditorsheet(value: "", title: "newfolder", hint: preference.language("editfoldername")) {
                name in

                _ = foldersmodel.newfolder(foldername: name)
            }
        }
    }
}
