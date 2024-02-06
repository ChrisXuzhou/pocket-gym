//
//  Revoke.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/10.
//

import SwiftUI

struct Revoke: View {
    var body: some View {
        Image("revoke")
            .renderingMode(.template)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 25, height: 25, alignment: .center)
    }
}

struct Revoke_Previews: PreviewProvider {
    static var previews: some View {
        Revoke()
    }
}
