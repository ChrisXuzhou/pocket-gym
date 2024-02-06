//
//  Labeltitle.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/8.
//

import SwiftUI

let LABEL_TITLE_FONT_SIZE: CGFloat = DEFINE_FONT_SIZE

struct Labeltitle_Previews: PreviewProvider {
    static var previews: some View {
        Labeltitle(title: "今日训练计划")
            .padding(.horizontal)
            
    }
}

struct Labeltitle: View {
    let title: String

    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(NORMAL_LIGHTER_COLOR)
                .font(.system(size: LABEL_TITLE_FONT_SIZE).bold())
            Spacer()
        }
    }
}

/*
 * batch view up tab 分【收起】【展开】两种状态
 */
enum Uptabstate {
    case full, packed, writing

    func isPacked() -> Bool {
        self == .packed
    }

    func toggle() -> Uptabstate {
        switch self {
        case .full:
            return .packed
        case .packed:
            return .full
        case .writing:
            return .writing
        }
    }
}
