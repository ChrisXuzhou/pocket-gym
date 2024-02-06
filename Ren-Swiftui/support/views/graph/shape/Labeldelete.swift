//
//  Labeldelete.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/31.
//

import SwiftUI

struct Labeldelete: View {
    var body: some View {
        Delete(fontsize: 18)
            .foregroundColor(NORMAL_RED_COLOR)
            .padding(3)
            .background(
                Circle().foregroundColor(NORMAL_LIGHT_GRAY_COLOR)
            )
    }
}

struct Labeldelete_Previews: PreviewProvider {
    static var previews: some View {
        Labeldelete()
    }
}
