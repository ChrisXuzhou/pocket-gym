//
//  Newmusclemenu.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/9/21.
//
import SwiftUI

struct Newmusclemenu_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Librarybetaview(showbackbutton: false)
                .navigationBarHidden(true)
        }

        DisplayedView {
            Newmusclemenu()
                .environmentObject(Librarybetamodel.shared)
        }
    }
}

func preparedisplayedmuscle() -> Bool {
    try! AppDatabase.shared.deleteNewdisplayedmuscles()
    Libraryinitializer.shared.initialize()

    return true
}

let NEWDISPLAYEDMUSCLEMENU_PANEL_HEIGHT: CGFloat = 45
let NEWDISPLAYEDMUSCLEMENU_PANEL_WIDTH: CGFloat = 0 // UIScreen.width / 5 // 130
let NEWDISPLAYEDMUSCLEMENU_PANEL_UNPACKED_WIDTH: CGFloat = 150

class Menuextended: ObservableObject {
    @Published var value = false
}

struct Newmusclemenu: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var librarymodel: Librarybetamodel

    @StateObject var model = Librarynewdisplayedmuscle.shared

    var body: some View {
        ZStack {
            /*
             
                 if extendswitch.value {
                     Color.black.opacity(0.02)
                         .onTapGesture {
                             extendswitch.value = false
                         }
                 }
             */

            HStack {
                content

                SPACE
            }
        }
        .environmentObject(librarymodel)
    }

    /*
     * variables
     */
    @StateObject var extendswitch = Menuextended()

    var content: some View {
        ZStack {
            let width: CGFloat = extendswitch.value ? NEWDISPLAYEDMUSCLEMENU_PANEL_UNPACKED_WIDTH : NEWDISPLAYEDMUSCLEMENU_PANEL_WIDTH

            VStack {
                packbutton

                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        ForEach(model.groups, id: \.muscle.ident) { wrapper in
                            NewmusclemenuPanel(wrapper)
                        }
                    }
                    .padding(.vertical)
                }
                .environmentObject(extendswitch)
            }
            /*
             
             .background(
                 ZStack {
                     NORMAL_BG_COLOR
                     preference.theme.opacity(0.1)
                 }
             )
             
             */
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .frame(width: width)
        }
        .padding(.leading, 2)
        //.padding(.vertical)
    }
}

extension Newmusclemenu {
    var packbutton: some View {
        HStack {
            Button {
                withAnimation {
                    extendswitch.value.toggle()
                }
            } label: {
                Image(systemName: "chevron.\(extendswitch.value ? "left" : "right")")
                    .font(.system(size: 18).weight(.heavy))
                    .foregroundColor(preference.theme)
                    .frame(height: 42)
            }

            if extendswitch.value {
                LocaleText("targetarea")
                    .font(.system(size: DEFINE_FONT_SMALL_SIZE).weight(.heavy))
                    .foregroundColor(NORMAL_LIGHT_TEXT_COLOR)

                SPACE
            }
        }
        .padding(.horizontal, 8)
    }
}

let NEWDISPLAYEDMUSCLEMENU_COLOR: Color = NORMAL_LIGHTER_COLOR

struct NewmusclemenuPanel: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var librarymodel: Librarybetamodel

    init(_ muscle: Newdisplayedmusclewrapper) {
        _muscle = StateObject(wrappedValue: muscle)
    }

    @StateObject var muscle: Newdisplayedmusclewrapper

    /*
     * variables
     */
    var groupfontsize: CGFloat = DEFINE_FONT_SMALLER_SIZE
    var musclefontsize: CGFloat = DEFINE_FONT_SMALLER_SIZE

    var focusedcolor: Color = NORMAL_LIGHTER_COLOR
    var unfocusedcolor: Color = NORMAL_BUTTON_COLOR.opacity(0.6)

    @EnvironmentObject var extendswitch: Menuextended

    var body: some View {
        HStack(spacing: 0) {
            let isfocused = librarymodel.isfocused(muscle)

            VStack(alignment: .leading, spacing: 0) {
                headerpanel(isfocused)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        librarymodel.focuse(muscle)
                    }

                /*
                 if isfocused {
                     if !muscle.children.isEmpty {
                         VStack(alignment: .leading, spacing: 0) {
                             ForEach(muscle.children, id: \.muscle.id) {
                                 child in

                                 contentpanel(child)
                                     .contentShape(Rectangle())
                                     .onTapGesture {
                                         librarymodel.focuse(child)
                                     }
                             }
                         }
                         .padding(.top, 5)
                         .padding(.bottom, 15)
                     }
                 }
                 */
            }

            /*

             .background(
                 Rectangle()
                     .cornerRadius(12, corners: [.bottomLeft, .topLeft])
                     .foregroundColor(isfocused ? LIBRARY_CONTENT_COLOR : Color.clear)
             )

             */
        }
    }
}

let PANEL_LEFT_HINT: some View = AnyView(
    Rectangle().frame(width: 3)
)

extension NewmusclemenuPanel {
    func headerpanel(_ isfocused: Bool) -> some View {
        ZStack {
            HStack(spacing: 0) {
                let _text = preference.language(muscle.muscle.ident, firstletteruppercase: false)

                Text(extendswitch.value ? _text : String(_text.prefix(2)))
                    .lineLimit(1)
                    .lineSpacing(0)

                if extendswitch.value {
                    SPACE
                }
            }
            .padding(.leading, 8)
            .padding(.trailing, 8)
            .foregroundColor(isfocused ? preference.theme : unfocusedcolor)
            .font(.system(size:
                extendswitch.value ? groupfontsize + 1 : groupfontsize
            ).bold())
            .frame(height: 42)
        }
    }

    func contentpanel(_ muscle: Newdisplayedmusclewrapper) -> some View {
        ZStack {
            let isfocused = librarymodel.isfocused(muscle)

            HStack(spacing: 8) {
                LocaleText(muscle.muscle.ident,
                           usefirstuppercase: false,
                           linelimit: 2, linespacing: 0)
                    .foregroundColor(
                        isfocused ? focusedcolor : unfocusedcolor.opacity(0.8)
                    )
                    .font(
                        .system(size: musclefontsize).bold()
                    )

                SPACE
            }
            .frame(height: 38)
            .padding(.leading, 15)
            .background(
                isfocused ? preference.theme.opacity(0.15) : Color.clear
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal, 5)
        }
    }
}

/*

     HStack {
         SPACE
         let _d = Librarynewdisplayedmuscle.shared.dictionary[librarymodel.focusedid]
         LocaleText(_d?.muscle.ident ?? "")
             .font(.system(size: DEFINE_FONT_SIZE).weight(.heavy))
             .foregroundColor(NORMAL_LIGHT_TEXT_COLOR.opacity(0.8))

         SPACE
     }
     .padding(.horizontal, 5)
     .padding(.bottom, 8)
     .background(NORMAL_BG_COLOR.opacity(0.95))

 */
