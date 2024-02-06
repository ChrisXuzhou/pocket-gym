//
//  SwiftUIView.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/9/18.
//

import SwiftUI
import SwiftUIPager

struct Routinetreeview_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            ContentView()
        }
    }
}

let ROUTINE_FOLDER_CORNER: CGFloat = 15
let ROUTINE_DISPLAYED_TYPE: String = "routinedisplayedtype"

enum Displaybygrid: String {
    case bygrid, bycolumn
}

class Bygrid: ObservableObject {
    @Published var value: Displaybygrid

    init() {
        value = .bygrid

        if let _cache = AppDatabase.shared.queryappcache(ROUTINE_DISPLAYED_TYPE) {
            value = Displaybygrid(rawValue: _cache.cachevalue) ?? .bygrid
        }
    }
}

struct Routinetreeview: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var foldersmodel: Foldersmodel
    @EnvironmentObject var routinesmodel: Folderroutinesmodel
    @EnvironmentObject var menuisopen: Menuisopen

    @StateObject var newswitch = Viewopenswitch()

    var viewusage: Labelusage = .forview
    var onselected: (Int64) -> Void = { _ in }

    var body: some View {
        LazyVStack(spacing: 0) {
            Routinefolderspanel()

            Foldersroutinesview()
        }
        .padding(.bottom)
        .environmentObject(routinesmodel)
        .environmentObject(foldersmodel)
        .environmentObject(menuisopen)
    }
}

struct Routinefolderspanel: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var menuisopen: Menuisopen
    @EnvironmentObject var foldersmodel: Foldersmodel
    @EnvironmentObject var routinesmodel: Folderroutinesmodel

    /*
     * variables
     */
    @StateObject var orderswitch = Viewopenswitch()

    @StateObject var page: Page = .first()

    var body: some View {
        panel
            .frame(height: 40)
            .fullScreenCover(isPresented: $orderswitch.value) {
                Routinefolderreorderview(folders: foldersmodel.rootfolders) {
                    folders in

                    var _folders = folders.map { $0.folder }
                    try! AppDatabase.shared.savefolders(&_folders)

                    foldersmodel.initfolders()
                }
            }
    }
}

extension Routinefolderspanel {
    var panel: some View {
        HStack(spacing: 20) {
            let ff: Folderwrapper = foldersmodel.offocusedfolder(menuisopen.openedfolderid)

            NavigationLink {
                Folderselectionview(
                    name: "folders",
                    selectedoption: ff
                ) { f in
                    menuisopen.openfolder(f)
                }
                .environmentObject(foldersmodel)
                .environmentObject(routinesmodel)
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)

            } label: {
                HStack(spacing: 5) {
                    LocaleText(ff.folder.name)
                        .font(.system(size: DEFINE_FONT_SMALLER_SIZE))
                        .foregroundColor(NORMAL_BUTTON_COLOR)

                    Image(systemName: "chevron.right")
                        .font(.system(size: 12).weight(.heavy))
                        .foregroundColor(preference.theme)
                }
            }

            SPACE

            Button {
                menuisopen.togglefocus()
            } label: {
                Systemimage(name: "bookmark.circle", color: menuisopen.focused ? NORMAL_GOLD_COLOR : NORMAL_GRAY_COLOR, height: 40)
            }

            Button {
                orderswitch.value = true
            } label: {
                Systemimage(name: "list.bullet", color: NORMAL_GRAY_COLOR)
            }
        }
        .padding(.horizontal)
    }
}

struct Routinefolderreorderview: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var foldersmodel: Foldersmodel
    @Environment(\.presentationMode) var present

    @State var folders: [Folderwrapper]
    var callback: (_ folders: [Folderwrapper]) -> Void = { _ in }

    var body: some View {
        ZStack {
            NORMAL_BG_COLOR.ignoresSafeArea()

            VStack(spacing: 0) {
                sheetupheader

                List {
                    ForEach(0 ..< folders.count, id: \.self) {
                        idx in

                        let folder = folders[idx]

                        HStack(spacing: 5) {
                            LocaleText(folder.folder.name)

                            SPACE
                        }
                        .id(folder.folderid)
                    }
                    .onMove(perform: move)
                    .onDelete(perform: delete)
                }
                .environment(\.editMode, .constant(.active))
            }
        }
    }
}

extension Routinefolderreorderview {
    var sheetupheader: some View {
        HStack(alignment: .lastTextBaseline) {
            Button {
                withAnimation {
                    present.wrappedValue.dismiss()
                }
            } label: {
                LocaleText("cancel")
                    .foregroundColor(NORMAL_LIGHTER_COLOR)
                    .font(.system(size: DEFINE_FONT_SMALL_SIZE))
                    .frame(width: SHEET_BUTTON_WIDTH, alignment: .leading)
            }

            SPACE

            LocaleText("reorder")

            SPACE

            Button {
                withAnimation {
                    present.wrappedValue.dismiss()
                }

                save()
            } label: {
                Text(preference.language("save"))
                    .foregroundColor(preference.theme)
                    .font(.system(size: DEFINE_FONT_SMALL_SIZE))
                    .frame(width: SHEET_BUTTON_WIDTH, alignment: .trailing)
            }
        }
        .font(.system(size: DEFINE_SHEET_FONT_SIZE))
        .padding(.horizontal)
        .frame(height: SHEET_HEADER_HEIGHT)
        .background(NORMAL_BG_CARD_COLOR)
    }

    func save() {
        var newfolders: [Folderwrapper] = []
        var num = 0
        for folder in folders {
            folder.folder.order = num
            num += 1
            newfolders.append(folder)
        }

        callback(newfolders)
    }

    func move(from source: IndexSet, to destination: Int) {
        folders.move(fromOffsets: source, toOffset: destination)
    }

    func delete(at offsets: IndexSet) {
        let folderstodelete = offsets.map { self.folders[$0] }
        folders.remove(atOffsets: offsets)

        for folder in folderstodelete {
            foldersmodel.delete(folder)
        }
    }
}

/*
 ScrollView(.horizontal, showsIndicators: false) {
     HStack(spacing: 15) {
         Routinefolderspanelicon(folder: Folderwrapper(EMPTY_FOLDER))

         ForEach(0 ..< foldersmodel.rootfolders.count, id: \.self) {
             idx in
             let folder = foldersmodel.rootfolders[idx]

             Routinefolderspanelicon(folder: folder)
         }
     }

     SPACE
 }

 Button {
     orderswitch.value = true
 } label: {
     Systemimage(name: "list.bullet")
 }

 Button {
     menuisopen.togglefocus()
 } label: {
     Systemimage(name: "bookmark.circle", color: menuisopen.focused ? NORMAL_GOLD_COLOR : NORMAL_BUTTON_COLOR, height: 40)
 }

 struct Routinefolderspanelicon: View {
     @EnvironmentObject var preference: PreferenceDefinition

     @EnvironmentObject var menuisopen: Menuisopen
     var folder: Folderwrapper

     var name: String {
         folder.folder.name
     }

     var isfocused: Bool {
         menuisopen.openedfolderid == folder.folderid
     }

     var body: some View {
         VStack(spacing: 0) {
             SPACE
             LocaleText(name)
                 .font(.system(size: DEFINE_FONT_SMALL_SIZE, design: .rounded).weight(.medium))
             SPACE
         }
         .background(
             VStack {
                 SPACE

                 if isfocused {
                     Rectangle().frame(height: 1.5)
                 }
             }
         )
         .frame(height: 43)
         .foregroundColor(isfocused ? preference.theme : NORMAL_BUTTON_COLOR)
         .contentShape(Rectangle())
         .onTapGesture {
             menuisopen.openfolder(folder)
         }
     }
 }

 */

/*

 extension Batchlistreorderview {
     func save() {
         var newbatchs: [Batch] = []
         var num = 0
         for var eachnewbatch in batchs {
             eachnewbatch.num = num
             num += 1
             newbatchs.append(eachnewbatch)
         }

         reordered(newbatchs)
     }

     func move(from source: IndexSet, to destination: Int) {
         batchs.move(fromOffsets: source, toOffset: destination)
     }

     func delete(at offsets: IndexSet) {
         let batchstodelete = offsets.map { self.batchs[$0] }

         for var batch in batchstodelete {
             if let batchid = batch.id {
                 DispatchQueue.global().async {
                     try! AppDatabase.shared.deletebatch(&batch)
                     try! AppDatabase.shared.deletebatchexercisedef(batchid: batchid)
                     try! AppDatabase.shared.deletebatcheachlog(batchid: batchid)
                 }
             }
         }

         batchs.remove(atOffsets: offsets)
     }

     func exercisedefs(number: Int) -> [Batchexercisedef] {
         fetcher.fetch(number) ?? []
     }
 }

 var panel: some View {
     HStack {
         let allfolders = foldersmodel.allfolders

         Button {
         } label: {
             Image(systemName: "chevron.left")
                 .font(.system(size: 16))
                 .foregroundColor(NORMAL_BUTTON_COLOR)
         }
         .frame(width: 50)

         Pager(page: page, data: 0 ..< allfolders.count, id: \.self) {
             idx in

             let folder = allfolders[idx]

             HStack {
                 SPACE

                 LocaleText(folder.folder.name)
                     .foregroundColor(NORMAL_LIGHTER_COLOR)
                     .font(.system(size: DEFINE_FONT_SMALL_SIZE, design: .rounded).bold())

                 SPACE
             }
             .padding(.horizontal)
         }
         .alignment(.center)
         .itemSpacing(0)
         .sensitivity(.high)
         .preferredItemSize(CGSize(width: UIScreen.width - 100, height: 90))
         .multiplePagination()
         .interactive(opacity: 0.25)
         .onPageChanged({ index in
             let _f = allfolders[index]
             menuisopen.openfolder(_f)
         })

         Button {
         } label: {
             Image(systemName: "chevron.right")
                 .font(.system(size: 16))
                 .foregroundColor(NORMAL_BUTTON_COLOR)
         }
         .frame(width: 50)
     }
     .frame(height: 60)
 }

 */
