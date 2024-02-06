//
//  Cloudshape.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/6/27.
//

import SwiftUI

struct Cloudshape: View {
    var upload: Bool = true
    var imgsize: CGFloat = 26

    var body: some View {
        Image(upload ? "cloudupload" : "clouddownload")
            .renderingMode(.template)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: imgsize, height: imgsize, alignment: .center)
    }
}

struct Cloudshape_Previews: PreviewProvider {
    static var previews: some View {
        Cloudshape()
    }
}
