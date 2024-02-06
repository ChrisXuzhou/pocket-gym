//
//  Libraryupviewtab.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/2/22.
//
import SwiftUI

struct Libraryupviewtab_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Libraryupviewtab(
                present: .constant(false)
            )
            .environmentObject(Exerciseactioncontext(Viewusage: .select))
            .environmentObject(Librarymodel())
        }
    }
}

class Sidebarbool: ObservableObject {
    @Published var showSidebar: Bool = false

    func toggle() {
        showSidebar.toggle()
    }
}

struct Libraryupviewtab: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var exerciseactioncontext: Exerciseactioncontext
    @EnvironmentObject var librarymodel: Librarymodel
    @EnvironmentObject var sidebarbool: Sidebarbool

    @Binding var present: Bool
    var showbackbutton: Bool = true
    var showhomebutton: Bool = false

    var uptabview: some View {
        UptabHeaderView(
            present: $present,
            showbackbutton: showbackbutton //,
            // title: preference.language(LANGUAGE_EXERCISES)
        ) {
            HStack(spacing: 10) {
                /*
                 if exerciseactioncontext.showonlyview {
                     Button {
                         modify.toggle()
                     } label: {
                         Gearsetting()
                     }
                     .foregroundColor(
                         modify.modify ?
                             preference.themeprimarycolor : NORMAL_BUTTON_COLOR
                     )
                 }

                 Button {
                     withAnimation {
                         librarymodel.togglemuscleselector()
                     }
                 } label: {
                     Image(systemName: "line.3.horizontal.decrease.circle.fill")
                 }
                 .foregroundColor(
                     librarymodel.showmuscleselector ?
                         preference.theme : NORMAL_BUTTON_COLOR
                 )

                 Button {
                     displaysearchbar.toggle()
                 } label: {
                     Image(systemName: "magnifyingglass.circle.fill")
                 }
                 .foregroundColor(NORMAL_BUTTON_COLOR)

                 */
                
                searchBar

                Button {
                    librarymodel.toggleshowmarked()
                } label: {
                    Pentagram(size: 22)
                }
                .foregroundColor(
                    librarymodel.showmarked ?
                        .yellow : NORMAL_BUTTON_COLOR
                )

                /*
                 
                 if exerciseactioncontext.showselect {
                     selectedbutton
                 }
                 
                 */
            }
            .font(.system(size: DEFINE_BUTTON_FONT_SMALL_SIZE))
        }
    }

    var searchBar: some View {
        HStack {
            Searchbar(searchText: $librarymodel.searchtext)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(NORMAL_LIGHTER_COLOR.opacity(0.1))
                        .frame(height: 30)
                )

        }
        .frame(height: MIN_UP_TAB_HEIGHT)
    }

    var sidebarbutton: some View {
        Button {
            sidebarbool.toggle()
        } label: {
            Linesshape()
                .padding(.horizontal, 10)
        }
    }

    var body: some View {
        HStack {
            if showhomebutton {
                sidebarbutton.padding(.trailing, 10)
            }

            uptabview
        }
        .padding(.horizontal)
    }

    /*
     
     Button {
         librarymodel.searchtext = ""
         displaysearchbar.toggle()
     } label: {
         LocaleText("cancel")
             .foregroundColor(preference.theme)
             .font(.system(size: DEFINE_BUTTON_FONT_SMALLEST_SIZE - 2).bold())
     }

         if displaysearchbar {
             searchBar
         } else {
             HStack {
                 if showhomebutton {
                     sidebarbutton.padding(.trailing, 10)
                 }

                 uptabview
             }
         }
     @State var displaysearchbar = false
     */
}

extension Libraryupviewtab {
    func releaseMuscleselection() {
        withAnimation {
            librarymodel.showmuscleselector = false
            librarymodel.selectedmuscle = nil
        }
    }

    var selectedbutton: some View {
        HStack {
            let count = exerciseactioncontext.checkedexerciseidlist.count
            if count > 0 {
                Text("x \(count)")
                    .lineLimit(1)
                    .minimumScaleFactor(0.01)
                    .font(.system(size: DEFINE_FONT_SIZE).bold())
                    .foregroundColor(preference.theme)
                    .frame(width: 30, alignment: .trailing)
            }

            Button {
                librarymodel.toggleshowselected()
            } label: {
                Checkcircle(selected: librarymodel.showselected)
            }
            .foregroundColor(
                librarymodel.showselected ?
                    preference.theme : NORMAL_BUTTON_COLOR
            )
        }
    }
}
