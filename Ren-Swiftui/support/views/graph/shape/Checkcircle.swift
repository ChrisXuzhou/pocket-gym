//
//  Checkcircle.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/2.
//

import SwiftUI


struct Checkcircle_Previews: PreviewProvider {
    static var previews: some View {
        Checkcircle()
    }
}


struct Checkcircle: View {
    var selected: Bool = false

    var body: some View {
        Image(systemName: selected ? "checkmark.circle.fill" : "circle")
            .font(.system(size: NORMAL_BUTTON_SIZE - 4).bold())
    }
}
