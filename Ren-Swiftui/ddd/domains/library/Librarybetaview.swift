


import SwiftUI

struct Librarybetaview_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            ContentView()
        }
        
    }
}

let LIBRARY_CONTENT_COLOR: Color = Color(.systemGray6)

struct Libraryfacadeview: View {
    var body: some View {
        VStack(spacing: 0) {
            Librarybetaview(showbackbutton: false)
                .environmentObject(Exerciseactioncontext.shared)

            SPACE.frame(height: MIN_DOWN_TAB_HEIGHT)
        }
    }
}

struct Librarybetaview: View, KeyboardReadable {
    @EnvironmentObject var preference: PreferenceDefinition

    var showbackbutton: Bool
    let libraryusage: Libraryusage

    @StateObject var librarymodel: Librarybetamodel

    /*
     * variables
     */
    @StateObject var newexerciseswitch = Viewopenswitch()
    
    var callback: () -> Void = {}

    init(showbackbutton: Bool = true,
         usage: Libraryusage = Libraryusage(usage: .forview),
         callback: @escaping () -> Void = {}) {
        self.showbackbutton = showbackbutton
        self.callback = callback
        libraryusage = usage

        _librarymodel = StateObject(wrappedValue: Librarybetamodel.shared)
    }

    var body: some View {
        ZStack {
            NORMAL_BG_COLOR.ignoresSafeArea()

            VStack(spacing: 0) {
                upheader
                    .background(NORMAL_BG_CARD_COLOR)
                    .shadow(color: NORMAL_CARD_SHADDOW_COLOR, radius: 15)

                content

                SPACE
            }
        }
        .environmentObject(librarymodel)
        .environmentObject(Libraryexercisemodel.shared)
        .environmentObject(libraryusage)
        .navigationBarHidden(true)
        .ignoresSafeArea(.keyboard)
        .onTapGesture {
            endtextediting()
        }
    }
}

/*
 * view related.
 */
extension Librarybetaview {
    var upheader: some View {
        VStack(spacing: 0) {
            tabupheader

            if librarymodel.searchtext.isEmpty {
                HStack(spacing: 10) {
                    Newselectmusclebutton()
                    Newselectequipmentbutton()
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
            }
        }
        .background(
            NORMAL_BG_CARD_COLOR.ignoresSafeArea()
        )
    }

    var content: some View {
        Libraryexercisecontent()
    }
}

extension Librarybetaview {
    var tabupheader: some View {
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

    var backbutton: some View {
        Button {
            callback()
        } label: {
            Backarrow()
        }
        .padding(.trailing, 10)
    }

    var searchbar: some View {
        Newsearchpanel()
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

class Libraryusage: ObservableObject {
    var usage: Labelusage

    var libraryaction: Libraryaddexerciseaction? // Librarybetaaction?

    init(usage: Labelusage = .forview, libraryaction: Libraryaddexerciseaction? = nil) {
        self.usage = usage
        self.libraryaction = libraryaction
    }
}
