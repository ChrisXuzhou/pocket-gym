//
//  Weibologo.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/5/20.
//

import SwiftUI

struct Weibologo_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Weibologo()
        }
    }
}

struct Weibologo: View {
    var imgsize: CGFloat = 30

    var body: some View {
        Image("weibo")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: imgsize, height: imgsize, alignment: .center)
    }
}
