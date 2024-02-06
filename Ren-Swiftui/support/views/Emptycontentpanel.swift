//
//  Emptycontentpanel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/4/9.
//

import SwiftUI

struct Emptycontentpanel_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Emptycontentpanel()
        }
    }
}

struct Emptycontentpanel: View {
    var fontsize: CGFloat = DEFINE_FONT_SMALLER_SIZE - 1

    var body: some View {
        HStack {
            SPACE

            //LocaleText("empty")
            Text("...")
                .foregroundColor(NORMAL_LIGHT_GRAY_COLOR)
                .font(.system(size: fontsize, design: .rounded))
            
            SPACE
        }
        .padding(.bottom)
        .frame(minHeight: 50)
    }
}

struct DeletedcontentView: View {
    var fontsize: CGFloat = DEFINE_FONT_SMALL_SIZE

    var body: some View {
        VStack {
            SPACE
            LocaleText("deleted")
                .font(.system(size: fontsize).bold())
                .padding(.horizontal)
            SPACE
        }
        .foregroundColor(NORMAL_RED_COLOR)
    }
}
