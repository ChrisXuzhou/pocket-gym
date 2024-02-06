//
//  Gearsetting.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/9.
//

import SwiftUI

struct Gearsetting: View {
    var body: some View {
        Image("setting")
            .renderingMode(.template)
            .resizable()
            .frame(width: 21, height: 21, alignment: .center)
            .aspectRatio(contentMode: .fill)
            .frame(width: 25, height: 25, alignment: .center)
    }
}

struct Gearsetting_Previews: PreviewProvider {
    static var previews: some View {
        Gearsetting()
    }
}
