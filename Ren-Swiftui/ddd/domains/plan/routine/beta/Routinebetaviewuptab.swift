//
//  Routinebetaviewuptab.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/9/29.
//

import SwiftUI

struct Routinebetaviewuptab_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            ContentView()
        }
    }
}

struct Routinebetaviewuptab: View {
    @Binding var present: Bool
    @Environment(\.presentationMode) var presentmode
    @EnvironmentObject var preference: PreferenceDefinition

    @EnvironmentObject var viewmodel: Routineviewmodel
    @EnvironmentObject var routine: Routine

    @Binding var showsummary: Bool

    @StateObject var editing = Viewmore()
    @StateObject var moreroutine = Viewmore()

    func close() {
        present = false
        presentmode.wrappedValue.dismiss()
    }

    var color: (Color, Color) {
        if showsummary {
            return (.white, Color.clear)
        }

        return (NORMAL_LIGHTER_COLOR, NORMAL_BG_COLOR)
    }

    var content: some View {
        VStack {
            let _color = color

            HStack(spacing: 0) {
                Button {
                    close()
                } label: {
                    Backarrow(color: _color.0)
                }
                .padding(.trailing, 10)

                if !showsummary {
                    LocaleText(routine.displayedname(preference), linelimit: 1, usescale: false)
                        .font(.system(size: UP_HEADER_TITLE_FONT_SIZE, design: .rounded).bold())
                        .foregroundColor(NORMAL_LIGHTER_COLOR)
                }

                SPACE

                HStack(spacing: 20) {
                    Button {
                        editing.value = true
                    } label: {
                        Pencile(imgsize: 20)
                            .foregroundColor(_color.0)
                    }

                    Button {
                        routine.togglefocus()
                    } label: {
                        Systemtempimage(name: "bookmark.fill", imgsize: 16)
                            .foregroundColor(
                                routine.isfocused ? NORMAL_GOLD_COLOR : _color.0
                            )
                    }

                    morebutton
                        .frame(width: 20, height: 20)
                        .foregroundColor(_color.0)
                }
            }
            .frame(height: MIN_UP_TAB_HEIGHT)
            .padding(.horizontal)
            .background(
                _color.1.ignoresSafeArea()
            )
        }
    }

    var morebutton: some View {
        Menu {
            Button {
                let _routine = routine.routine

                DispatchQueue.global().async {
                    _routine
                        .ascopier
                        .copy()
                }
            } label: {
                Label("\(preference.language("duplicate"))", systemImage: "square.on.square")
            }

            Button(role: .destructive) {
                DispatchQueue.global().async {
                    deleteroutine()
                }
            } label: {
                Label("\(preference.language("delete"))", systemImage: "trash")
            }

        } label: {
            Label("", systemImage: "ellipsis")
        }
        .menuStyle(Tabmenustyle())
        .frame(height: 16)
        .contentShape(Rectangle())
    }

    var body: some View {
        content
            .fullScreenCover(isPresented: $editing.value) {
                Routinebetaeditor(Routine(routine.routine)) {
                    routine.refresh()
                }
            }
    }
}


struct Tabmenustyle: MenuStyle {

    func makeBody(configuration: Configuration) -> some View {
        Menu(configuration)
            .offset(x: 4, y: -4)
            .font(.system(size: DEFINE_FONT_SIZE).weight(.heavy))
            .padding(4)
    }
}


extension Routinebetaviewuptab {
    func deleteroutine() {
        // close()

        if let _routineid = routine.routine.id {
            deleteworkout(_routineid)
        }
    }
}

/*
 .confirmationDialog("", isPresented: $moreroutine.value) {
     Button("\(preference.language("duplicate"))") {
         let _routine = routine.routine

         DispatchQueue.global().async {
             _routine
                 .ascopier
                 .copy()
         }
     }

     Button("\(preference.language("delete"))", role: .destructive) {
         DispatchQueue.global().async {
             deleteroutine()
         }
     }
 }
 */
