//
//  Folderroutine.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/9/25.
//

import SwiftUI
struct Folderroutine_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            ContentView()
        }
    }
}

let FOLDER_ROUTINE_HEADER_HEIGHT: CGFloat = 50
let FOLDER_ROUTINE_NAME_HEIGHT: CGFloat = 30
let FOLDER_ROUTINE_CONTNET_HEIGHT: CGFloat = 40
let FOLDER_ROUTINE_BUTTON_HEIGHT: CGFloat = 25
let FOLDER_ROUTINE_HEIGHT: CGFloat = FOLDER_ROUTINE_HEADER_HEIGHT + FOLDER_ROUTINE_NAME_HEIGHT + FOLDER_ROUTINE_CONTNET_HEIGHT + FOLDER_ROUTINE_BUTTON_HEIGHT

struct Folderroutine: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var trainingmodel: Trainingmodel

    /*
     * folders
     */
    @EnvironmentObject var foldersmodel: Foldersmodel
    @EnvironmentObject var menuisopen: Menuisopen

    /*
     * variables
     */
    var labelusage: Labelusage
    var onselected: (Int64) -> Void

    @ObservedObject var routine: Routine

    init(_ routine: Routine,
         labelusage: Labelusage = .forview,
         height: CGFloat = FOLDER_ROUTINE_HEIGHT,
         onselected: @escaping (Int64) -> Void = { _ in }) {
        self.labelusage = labelusage
        self.height = height
        self.onselected = onselected

        self.routine = routine
    }

    /*
     * function variables
     */
    @StateObject var moveswitch = Viewopenswitch()
    @StateObject var naviswitch = Viewopenswitch()

    var headerfont: CGFloat = DEFINE_FONT_SMALL_SIZE
    var height: CGFloat

    var fontcolor: Color = NORMAL_LIGHTER_COLOR
    var contentfont: CGFloat = DEFINE_FONT_SMALLER_SIZE
    var contentfontcolor: Color = NORMAL_LIGHT_TEXT_COLOR

    var body: some View {
        ZStack {
            VStack {
                labelcontent

                if labelusage == .forview {
                    SPACE.frame(height: 20)
                }
            }

            if labelusage == .forview {
                VStack {
                    SPACE
                    HStack {
                        usetemplatebutton.padding(.leading, 10)
                        SPACE
                    }
                }
            }
        }
    }

    var labelcontent: some View {
        ZStack {
            if labelusage == .forview {
                VStack(alignment: .leading, spacing: 0) {
                    header

                    HStack(spacing: 0) {
                        NavigationLink {
                            navilink
                        } label: {
                            VStack(alignment: .leading, spacing: 0) {
                                content

                                SPACE
                                HStack { SPACE }
                            }
                            .padding(2)
                            .contentShape(Rectangle())
                        }
                        
                        SPACE
                        
                        NavigationLink {
                            navilink
                        } label: {
                            Image(systemName: "chevron.right")
                                .font(.system(size: 12))
                                .foregroundColor(preference.theme)
                                .padding(10)
                                .frame(width: 30)
                        }

                    }
                }

            } else {
                VStack(alignment: .leading, spacing: 0) {
                    header

                    content

                    SPACE
                    HStack { SPACE }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    onselected(routine.routine.id!)
                }
            }
        
        }
        .padding(.horizontal, 10)
        .frame(height: height)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(NORMAL_BG_CARD_COLOR)
                .shadow(color: NORMAL_CARD_SHADDOW_COLOR, radius: 5)
        )
        .sheet(isPresented: $moveswitch.value) {
            Foldermovesheet {
                folder in

                routine.moveto(folder?.folderid)
            }
        }
    }

    var navilink: some View {
        Routinebetaview(
            routineusage: .usetemplate,
            routine: routine
        )
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

/*
 * header
 */
extension Folderroutine {
    var header: some View {
        HStack(spacing: 0) {
            if routine.isfocused {
                Systemtempimage(name: "bookmark.fill", imgsize: 18)
                    .foregroundColor(NORMAL_GOLD_COLOR)
                    .padding(.trailing, 5)
            }

            VStack(alignment: .leading, spacing: 0) {
                LocaleText(routine.displayedname(preference), linelimit: 1, usescale: false)
                    .font(.system(size: headerfont).bold())
                    .foregroundColor(NORMAL_LIGHTER_COLOR)
            }

            SPACE

            morebutton
        }
        .padding(.leading, 3)
        .foregroundColor(fontcolor)
        .background(NORMAL_BG_CARD_COLOR)
        .frame(height: FOLDER_ROUTINE_HEADER_HEIGHT)
    }

    var morebutton: some View {
        Menu {
            Button(action: {
                moveswitch.value = true
            }) {
                Label("\(preference.language("movetofolder"))", systemImage: "folder")
            }

            Button(action: {
                let _workout = routine.routine

                _workout
                    .ascopier
                    .copy()

            }) {
                Label("\(preference.language("duplicate"))", systemImage: "square.on.square")
            }

            Button(role: .destructive) {
                if let id = routine.routine.id {
                    deleteworkout(id)
                }
            } label: {
                Label("\(preference.language("delete"))", systemImage: "trash")
            }

        } label: {
            Label("", systemImage: "ellipsis")
        }
        .menuStyle(Localmenustyle())
        .frame(height: FOLDER_ROUTINE_HEADER_HEIGHT)
        .contentShape(Rectangle())
    }
}

extension Folderroutine {
    var content: some View {
        VStack {
            let exercisename = routine.exercises.joined(separator: ", ")

            if exercisename.isEmpty {
                Emptycontentpanel()
            } else {
                LocaleText(exercisename, linelimit: 4, usescale: false, linespacing: 3)
                    .font(.system(size: contentfont))
                    .foregroundColor(NORMAL_LIGHT_TEXT_COLOR)
            }
        }
        .padding(.vertical, 5)
    }

    var usetemplatebutton: some View {
        Button {
            startnow()
        } label: {
            HStack {
                SPACE

                LocaleText("usethistemplate", uppercase: true)
                    .foregroundColor(.white)
                    .font(.system(size: DEFINE_FONT_SMALLER_SIZE + 1).bold())

                SPACE
            }
            .frame(width: 160, height: 38)
            .background(
                /*
                 LinearGradient(
                     gradient: Gradient(colors: [preference.theme.opacity(0.9), preference.theme]),
                     startPoint: .topTrailing,
                     endPoint: .bottomLeading
                 )
                 */
                preference.theme
            )
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(color: preference.themeprimarycolor,
                    radius: 8, x: 0, y: 5)
        }
    }
    
    func startnow() {
        let newedworkout =
            routine.routine
                .planer
                .buildaplanworkout(preference.ofweightunit, planday: Date())

        _ = trainingmodel.opentraining(newedworkout, preference: preference)
    }
}

struct Localmenustyle: MenuStyle {
    var color: Color = NORMAL_BUTTON_COLOR
    var bgcolor: Color = NORMAL_BG_BUTTON_COLOR

    func makeBody(configuration: Configuration) -> some View {
        Menu(configuration)
            .offset(x: 4, y: -4)
            .font(.system(size: DEFINE_FONT_SIZE).weight(.heavy))
            .foregroundColor(color)
            .padding(4)
    }
}

class Viewmore: ObservableObject {
    @Published var value: Bool = false
}
