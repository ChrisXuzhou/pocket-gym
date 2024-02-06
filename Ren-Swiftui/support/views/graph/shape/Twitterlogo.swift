//
//  Twitterlogo.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/5/20.
//

import SwiftUI
struct Twitterlogo_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Twitterlogo()
        }
    }
}

struct Twitterlogo: View {
    var imgsize: CGFloat = 30

    var body: some View {
        Image("twitter")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: imgsize, height: imgsize, alignment: .center)
    }
}

struct Contactuslogo: View {
    var istwitter: Bool = true
    var imgsize: CGFloat = 30
    var color: Color = NORMAL_GRAY_COLOR

    var body: some View {
        Image(istwitter ? "twitter" : "weibo")
            .renderingMode(.template)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: imgsize, height: imgsize, alignment: .center)
            .foregroundColor(color)
    }
}
