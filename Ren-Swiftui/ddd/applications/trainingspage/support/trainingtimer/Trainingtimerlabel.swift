//
//  Trainingtimerlabel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/8.
//

import SwiftUI

struct Trainingtimerlabel_Previews: PreviewProvider {
    static var previews: some View {
        let timer = mockstartedtimer()

        DisplayedView {
            Trainingtimerlabel(trainingtimer: timer,
                               fontsize: 35)
        }
    }
}

func mockstartedtimer() -> Trainingtimer {
    let timer = Trainingtimer()
    timer.start()

    return timer
}

let TRAINING_TIMER_LABEL_FONT_SIZE: CGFloat = DEFINE_FONT_BIGGEST_SIZE
let TRAINING_TIMER_LABEL_WIDTH: CGFloat = 40

struct Trainingtimerlabel: View {
    @EnvironmentObject var preference: PreferenceDefinition

    @ObservedObject var trainingtimer: Trainingtimer
    var fontsize: CGFloat

    @State private var completedTime: TimeInterval = 0
    @State private var timer: Timer.TimerPublisher = Timer.publish(every: 1, on: .main, in: .common)
    @State private var backgroundAt = Date()
    var leading: Bool
    var fontcolor: Color?

    init(
        trainingtimer: Trainingtimer,
        fontsize: CGFloat = DEFINE_FONT_SIZE,
        leading: Bool = true,
        fontcolor: Color? = nil
    ) {
        self.trainingtimer = trainingtimer
        self.fontsize = fontsize
        self.leading = leading
        self.fontcolor = fontcolor

        if let _starttime = trainingtimer.starttime {
            let interval = TimeInterval(Int(Date().timeIntervalSince(_starttime) + 1))
            _completedTime = .init(initialValue: interval)
        }

        _ = timer.connect()
    }

    private func stopTimer() {
        timer.connect().cancel()
    }

    private func startTimer() {
        timer = Timer.publish(every: 1, on: .main, in: .common)
        _ = timer.connect()
    }

    var colon: some View {
        Text(":")
            .font(.system(size: fontsize).bold())
            .padding(0)
    }

    var contentview: some View {
        HStack(spacing: 0) {
            if !leading {
                SPACE
            }

            Text("\(completedTime.formattedminutseconds)")
                .tracking(0.6)
                .font(.system(size: fontsize, design: .rounded).bold())

            SPACE
        }
        .foregroundColor(
            trainingtimer.isrunning ?
                (fontcolor ?? preference.theme) : NORMAL_LIGHT_GRAY_COLOR
        )
    }

    var body: some View {
        ZStack {
            Color.clear
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                    if self.trainingtimer.isrunning {
                        stopTimer()
                        self.backgroundAt = Date()
                    }
                }

            Color.clear
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                    if self.trainingtimer.isrunning {
                        let backgroundInterval = TimeInterval(Int(Date().timeIntervalSince(self.backgroundAt) + 1))
                        self.completedTime = self.completedTime + backgroundInterval
                        self.startTimer()
                    }
                }

            contentview
        }
        .onReceive(timer, perform: { _ in
            if self.trainingtimer.isrunning {
                self.completedTime += 1
            }
        })
    }
}

struct Timerdigitnumber: View {
    var number: Int
    var fontsize: CGFloat = 20
    var width: CGFloat = 35

    var body: some View {
        Text(String(format: "%02d", number))
            .multilineTextAlignment(.trailing)
            .font(.system(size: fontsize).bold())
            .padding(0)
            .frame(width: width)
    }
}
