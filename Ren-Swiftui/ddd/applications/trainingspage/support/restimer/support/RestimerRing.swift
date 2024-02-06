//
//  CountdownRingView.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/15.
//

import SwiftUI

struct RingSpinnerView_Previews: PreviewProvider {
    static var previews: some View {
        let timer = Restimer(interval: 10) {_ in}

        VStack {
            RestimerRing(
                restimer: timer
            )
        }
        .frame(width: REST_TIMER_VIEW_SIZE, height: REST_TIMER_VIEW_SIZE)
    }
}

public struct RestimerRing: View {
    @ObservedObject var restimer: Restimer

    private(set) var gradientcolors: [Color]
    private(set) var linewidth: CGFloat

    public init(
        restimer: Restimer,
        gradientcolors: [Color] = [.red, .pink],
        linewidth: CGFloat = 5
    ) {
        self.gradientcolors = gradientcolors
        self.linewidth = linewidth
        self.restimer = restimer
    }

    public var body: some View {
        VStack {
            GeometryReader { _ in
                ZStack {
                    /*
                     
                     AnimationRingShape(remain: 1 - self.restimer.nextfractioncompleted)
                         .stroke(
                             LinearGradient(
                                 gradient: .init(colors: self.gradientcolors),
                                 startPoint: .init(x: 0.5, y: 0.0),
                                 endPoint: .init(x: 0.5, y: 0.6)
                             ),
                             style: .init(
                                 lineWidth: self.linewidth,
                                 lineCap: .round
                             )
                         )
                         .rotationEffect(.init(degrees: -90))
                         .animation(self.restimer.status == .countdown ? self.animation : nil)
                     
                     
                     */
                }
            }
            .aspectRatio(1, contentMode: .fit)
            .padding(8)
        }
    }
}

private extension RestimerRing {
    var animation: Animation {
        Animation
            .linear(duration: 1)
            .repeatCount(1)
    }
}
