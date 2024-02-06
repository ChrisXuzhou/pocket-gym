//
//  Muscleselectedmenu.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/4/9.
//

import SwiftUI
import SwiftUIPager

struct Muscleselectedmenu_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            ZStack {
                NORMAL_GREEN_COLOR

                Muscleselectedmenu(
                    selected: .constant("chest"), muscleidlist: ["chest", "shoulders", "back"]
                )
            }
        }
    }
}

struct Muscleselectedmenu: View {
    @Binding var selected: String
    var selectedcolor: Color
    var muscleidlist: [String]

    init(selected: Binding<String>, selectedcolor: Color = .white, muscleidlist: [String]) {
        _selected = selected
        self.selectedcolor = selectedcolor
        self.muscleidlist = muscleidlist
    }

    @StateObject var page: Page = .withIndex(0)

    var body: some View {
        HStack {
            SPACE

            menuview
                .frame(width: CGFloat(muscleidlist.count * 30) + 10)

            SPACE
        }
    }

    var menuview: some View {
        VStack {
            Pager(page: page, data: muscleidlist, id: \.self) {
                muscleid in
                LocaleText(muscleid)
                    .foregroundColor(
                        muscleid == selected ?
                            selectedcolor : NORMAL_LIGHT_GRAY_COLOR
                    )
                    .font(.system(size:
                        muscleid == selected ?
                            DEFINE_FONT_SIZE : DEFINE_FONT_SMALL_SIZE - 2
                    ))
            }
            .alignment(.start)
            .preferredItemSize(CGSize(width: 30, height: 30))
            .horizontal()
            .itemSpacing(0)
            .sensitivity(.high)
            .multiplePagination()
            .onPageChanged({ pageIndex in
                guard pageIndex == 1 else { return }

                log("page idx \(pageIndex)")
                selected = muscleidlist[pageIndex]
            })
        }
    }
}
