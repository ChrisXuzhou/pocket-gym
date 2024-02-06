//
//  Musclefrequencymenu.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/10/23.
//

import SwiftUI

struct Musclefrequencymenu_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Musclefrequencyview()
        }

        DisplayedView {
            Musclefrequencymenu(.constant("chest"))
        }
    }
}

struct Musclefrequencymenu: View {
    @Binding var focuedgroupid: String

    init(_ focuedgroupid: Binding<String>) {
        _focuedgroupid = focuedgroupid
        _librarymuscle = StateObject(wrappedValue: Librarynewdisplayedmuscle.shared)
    }

    /*
     * variables
     */
    @StateObject var librarymuscle: Librarynewdisplayedmuscle

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            ScrollViewReader {
                reader in

                HStack(spacing: 15) {
                    let musclegroups = librarymuscle.musclegroups

                    ForEach(0 ..< musclegroups.count, id: \.self) {
                        idx in

                        MuscleradarmodelmenuIcon(
                            group: musclegroups[idx],
                            focused: focuedgroupid == musclegroups[idx].displayedgroupid
                        )
                        .id(musclegroups[idx].displayedgroupid)
                        .onTapGesture {
                            withAnimation {
                                focuedgroupid = musclegroups[idx].displayedgroupid
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .onChange(of: focuedgroupid) { _ in
                    withAnimation {
                        reader.scrollTo(focuedgroupid, anchor: .center)
                    }
                }
            }
        }
    }
}

struct MuscleradarmodelmenuIcon: View {
    @EnvironmentObject var preference: PreferenceDefinition

    var group: Newdisplayedmusclewrapper
    var focused: Bool

    /*
     * variables
     */
    var fontsize: CGFloat = DEFINE_FONT_SMALL_SIZE - 1

    var body: some View {
        VStack(spacing: 8) {
            LocaleText(group.displayedgroupid)
                .font(.system(size: fontsize))
                /*
                 .font(
                     focused ? .system(size: fontsize).bold() : .system(size: fontsize)
                 )
                 */
                .foregroundColor(
                    focused ? preference.theme : NORMAL_LIGHT_TEXT_COLOR
                )
                .frame(height: 25)

            ZStack(alignment: .bottom) {
                if focused {
                    Rectangle()
                        .frame(width: 15, height: 1.5)
                        .foregroundColor(
                            preference.theme
                        )
                }

                LOCAL_DIVIDER
            }
        }
    }
}
