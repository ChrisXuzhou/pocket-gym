//
//  Valuedescriptor.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/27.
//

import SwiftUI

struct Valuedescriptor: View {
    var value: String
    var footer: String?

    var body: some View {
        HStack(spacing: 3) {
            Text(value)
            if let _footer = footer {
                Text(_footer)
            }
        }
        .foregroundColor(NORMAL_LIGHTER_COLOR)
        .font(.system(size: DEFINE_FONT_SIZE - 1))
        .padding(.leading, 10)
    }
}
