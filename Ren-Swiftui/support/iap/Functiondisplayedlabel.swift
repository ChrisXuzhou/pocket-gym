//
//  Functiondisplayedlabel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/6/6.
//

import SwiftUI
import SwiftUIPager

struct Functiondisplayedlabel_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Functiondisplayedlabellist()
        }
    }
}

let FUNCTION_LABEL_HEIGHT: CGFloat = 290

struct Functiondisplayedlabel: View {
    @EnvironmentObject var preference: PreferenceDefinition

    var imgname: String
    var description: String

    var body: some View {
        VStack(spacing: 25) {
            Image(imgname)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: FUNCTION_LABEL_HEIGHT - 110, alignment: .center)

            let _description = preference.language(description, firstletteruppercase: false)

            Text(_description)
                .tracking(0.5)
                .lineLimit(4)
                .multilineTextAlignment(.center)
                .lineSpacing(3)
                .font(.system(size: DEFINE_FONT_SMALLER_SIZE).bold())
                .foregroundColor(NORMAL_GRAY_COLOR)

            SPACE
        }
        .frame(maxWidth: FUNCTION_LABEL_HEIGHT, alignment: .center)
    }
}

struct Functiondisplayedlabellist: View {
    @EnvironmentObject var preference: PreferenceDefinition

    @StateObject var page: Page = .first()

    var picanddesclist: [(String, String)] = [
        ("workout_log", "workoutlogdesc"),
        ("calendar_sample", "calendardesc"),
        ("review", "reviewdesc"),
        ("hardworking", "hardworkingdesc"),
    ]

    var contentview: some View {
        VStack {
            Pager(page: page, data: 0 ..< picanddesclist.count, id: \.self) {
                idx in

                let picanddesc = picanddesclist[idx]

                Functiondisplayedlabel(imgname: picanddesc.0,
                                       description: picanddesc.1)
                    .contentShape(Rectangle())
            }
            .alignment(.center)
            .preferredItemSize(CGSize(width: UIScreen.width, height: FUNCTION_LABEL_HEIGHT))
            .horizontal()
            .itemSpacing(0)
            .sensitivity(.high)
            .multiplePagination()
            .interactive(opacity: 0.25)
        }
    }

    var indexlabel: some View {
        VStack {
            SPACE

            HStack(spacing: 12) {
                SPACE

                ForEach(0 ..< picanddesclist.count, id: \.self) {
                    idx in

                    Circle()
                        .frame(width: 7, height: 7)
                        .foregroundColor(
                            page.index == idx ?
                                preference.theme : NORMAL_LIGHT_GRAY_COLOR
                        )
                }

                SPACE
            }
            .frame(height: 26)
        }
    }

    var body: some View {
        ZStack {
            contentview

            indexlabel
        }
        .frame(height: FUNCTION_LABEL_HEIGHT)
    }
}
