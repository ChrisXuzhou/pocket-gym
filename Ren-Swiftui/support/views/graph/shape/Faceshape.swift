//
//  Faceshape.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/7/2.
//

import SwiftUI

struct Faceshape_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Faceshape()
        }
    }
}

enum Face: String {
    case smile, sad, normal
}

struct Faceshape: View {
    var imgsize: CGFloat = 22
    var face: Face = .normal

    var body: some View {
        Image(face.rawValue)
            .renderingMode(.template)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: imgsize, height: imgsize, alignment: .center)
            .foregroundColor(NORMAL_LIGHTER_COLOR)
    }
}
