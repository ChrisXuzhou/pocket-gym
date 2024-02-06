//
//  AnimationRingShape.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/15.
//

import SwiftUI

struct AnimationRingShape: Shape {
    private var remain: Double

    init(remain: Double) {
        if (0...1).contains(remain) {
            self.remain = remain
        } else if 1 < remain {
            self.remain = 1
        } else {
            self.remain = 0
        }
    }

    func path(in rect: CGRect) -> Path {
        Path { path in
            path.addArc(
                center: CGPoint(x: rect.size.width/2, y: rect.size.width/2),
                radius: rect.size.width / 2,
                startAngle: Angle(degrees: 0),
                endAngle: Angle(degrees: 360 * remain),
                clockwise: false
            )
        }
    }

    var animatableData: Double {
        get { remain }
        set { remain = newValue }
    }
}
