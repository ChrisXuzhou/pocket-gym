//
//  RestoffView.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/5/26.
//

import SwiftUI

struct RestoffView_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            RestoffView()
        }
    }
}

struct RestoffView: View {
    var body: some View {
        VStack {
            HStack { SPACE }
            SPACE
            
            Coffee(imgsize: 28)
            LocaleText("dayoff").font(.system(size: DEFINE_FONT_SMALLER_SIZE))
            
            SPACE
        }
        .foregroundColor(NORMAL_GRAY_COLOR)
        .frame(minHeight: 120)
    }
}
