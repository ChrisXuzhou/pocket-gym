//
//  Exercisevideo.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/29.
//

import SwiftUI

struct Exercisevideo_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Exercisevideo()
        }
    }
}

let EXERCISE_VIDEO_LIST: [String] = [
    "video_gym",
]

let VIDEO_GYM_WIDTH: CGFloat = UIScreen.width - 20

struct Exercisevideo: View {
    var img: String {
        let idx = 0 // Int.random(in: 0 ..< 6)
        return EXERCISE_VIDEO_LIST[idx]
    }

    var body: some View {
        VideoView(v: img)
            .frame(width: VIDEO_GYM_WIDTH, height: VIDEO_GYM_WIDTH * 3 / 5)
            .animationsDisabled()
    }
}
