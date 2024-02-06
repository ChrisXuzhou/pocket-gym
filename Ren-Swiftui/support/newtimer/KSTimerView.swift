
import SwiftUI

struct KSTimerView_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            VStack {
                KSTimerView(timerInterval: 10.0) {
                    _ in
                }
            }
        }
    }
}

public enum KSTimerStatus {
    case notStarted, running, paused
}

let TIMER_LABEL_HEIGH: CGFloat = WORKOUT_DATA_HEIGHT

public struct KSTimerView: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var trainingpreference: TrainingpreferenceDefinition

    @State private var offset: CGFloat = 70
    @State var completedTime: TimeInterval = 0
    @State private var status: KSTimerStatus = .notStarted
    @State private var timer: Timer.TimerPublisher = Timer.publish(every: 1, on: .main, in: .common)
    @State private var backgroundAt = Date()

    private var progress: CGFloat {
        CGFloat((timerInterval - completedTime) / timerInterval)
    }

    @State var timerInterval: TimeInterval
    var stepperValue: TimeInterval = 15

    var textfontsize: CGFloat = DEFINE_FONT_BIGGEST_SIZE
    var buttonfontsize: CGFloat = DEFINE_FONT_SMALL_SIZE + 1
    var desctextfontsize: CGFloat = 11
    var graphheight: CGFloat = 55
    var textcolor: Color = NORMAL_LIGHTER_COLOR

    var callback: (_ counter: Int) -> Void

    var background: some View {
        ZStack {
            Color.clear
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                    self.stopTimer()
                    self.backgroundAt = Date()
                }
            Color.clear
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                    if self.status == .running {
                        let backgroundInterval = TimeInterval(Int(Date().timeIntervalSince(self.backgroundAt) + 1))
                        if (self.completedTime + backgroundInterval) >= (self.timerInterval - 1) {
                            self.resetDetails()
                        } else {
                            self.completedTime = self.completedTime + backgroundInterval
                            self.startTimer()
                        }
                    }
                }
        }
    }

    var leftsecondscount: Int {
        (Int(timerInterval - completedTime) == 0) ?
            Int(timerInterval) : Int(timerInterval - completedTime)
    }

    var animation: Animation {
        Animation
            .linear(duration: 1)
            .repeatCount(1)
    }

    var ringview: some View {
        ZStack {
            Circle()
                .stroke(
                    Color.white.opacity(0.5),
                    style: .init(
                        lineWidth: 4,
                        lineCap: .round
                    )
                )

            if status == .running || status == .paused {
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        LinearGradient(
                            gradient: .init(colors: [preference.theme, preference.theme.opacity(0.9)]),
                            startPoint: .init(x: 0.5, y: 0.0),
                            endPoint: .init(x: 0.5, y: 0.6)
                        ),
                        style: .init(
                            lineWidth: 4,
                            lineCap: .round
                        )
                    )
                    .animation(status == .running || status == .paused ? self.animation : nil)
                    .rotationEffect(.degrees(-90))
            }
        }
        .frame(width: graphheight, height: graphheight)
    }

    var timetab: some View {
        VStack(spacing: 3) {
            LocaleText("\(leftsecondscount)")
                .font(
                    .system(size: 40)
                        .weight(.heavy)
                )
                .foregroundColor(preference.theme)

            Text("\(timerInterval.formattedminutseconds)")
                .font(
                    .system(size: desctextfontsize)
                        .bold()
                )
                .foregroundColor(
                    textcolor.opacity(0.7)
                )

            ProgressView(value: completedTime, total: timerInterval)
                .tint(preference.theme)
                .background(NORMAL_BG_GRAY_COLOR) //
                .scaleEffect(x: 1, y: 1.5, anchor: .center)
                .frame(height: 25)
        }
        .frame(width: 145)
        .contentShape(Rectangle())
        .onTapGesture {
            skip()
        }
        .onAppear {
            status = .running
            configureTimerAndNotification()
        }
    }

    func skip() {
        HapticHelper.shared.hapticFeedback()
        if status == .running {
            resetDetails()
            LocalNotificationHelper.shared.resetTimerNotification()
        } else {
            status = .running
            configureTimerAndNotification()
        }
    }

    var skipbutton: some View {
        Button {
            skip()
        } label: {
            HStack {
                
                
                LocaleText("skip")
                    .font(
                        .system(size: DEFINE_FONT_SMALLER_SIZE, design: .rounded)
                            .bold()
                    )
                    .foregroundColor(preference.theme)
            }
            .frame(width: 50, height: 20)
            .background(NORMAL_BG_GRAY_COLOR)
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }

    var smallcontentview: some View {
        VStack(spacing: 0) {
            SPACE
            HStack(alignment: .bottom, spacing: 10) {
                SPACE

                minusbutton

                timetab

                plusbutton

                SPACE
            }
            skipbutton
            SPACE
        }
    }

    var minusbutton: some View {
        Button(action: {
            HapticHelper.shared.hapticFeedback(style: .soft)
            if self.timerInterval > stepperValue {
                self.timerInterval = self.timerInterval - stepperValue
                LocalNotificationHelper.shared.addLocalNoification(interval: TimeInterval(self.timerInterval - self.completedTime))

                asyncsaveresttime(Int(self.timerInterval) ?? 60)
            }
        }) {
            ZStack {
                NORMAL_BG_GRAY_COLOR

                Text("-\(Int(stepperValue))")
                    .font(
                        .system(size: buttonfontsize, design: .rounded)
                            .weight(.heavy)
                    )
                    .foregroundColor(textcolor)
            }
            .frame(width: 45, height: 30)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }

    var plusbutton: some View {
        Button(action: {
            HapticHelper.shared.hapticFeedback(style: .soft)
            self.timerInterval = self.timerInterval + stepperValue
            LocalNotificationHelper.shared.addLocalNoification(interval: TimeInterval(self.timerInterval - self.completedTime))

            asyncsaveresttime(Int(self.timerInterval) ?? 60)

        }) {
            ZStack {
                NORMAL_BG_GRAY_COLOR

                Text("+\(Int(stepperValue))")
                    .font(
                        .system(size: buttonfontsize, design: .rounded)
                            .weight(.heavy)
                    )
                    .foregroundColor(textcolor)
            }
            .frame(width: 45, height: 30)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }

    public var body: some View {
        ZStack {
            background

            NORMAL_BG_CARD_COLOR

            smallcontentview
        }
        .frame(height: 140)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(color: NORMAL_CARD_SHADDOW_COLOR, radius: 30)
        .onReceive(timer, perform: { _ in
            if self.status == .running {
                self.completedTime += 1
                if self.completedTime >= self.timerInterval - 1 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.resetDetails()
                    }
                }
            }
        })
    }

    private func configureTimerAndNotification() {
        if status == .running {
            startTimer()
            LocalNotificationHelper.shared.addLocalNoification(interval: TimeInterval(timerInterval - completedTime))
        } else if status == .paused {
            stopTimer()
            LocalNotificationHelper.shared.resetTimerNotification()
        }
    }

    let lock = NSLock()

    private func resetDetails() {
        lock.lock()
        defer {
            lock.unlock()
        }

        if status == .notStarted {
            return
        }

        callback(Int(completedTime))

        status = .notStarted
        stopTimer()
        completedTime = 0
    }

    private func stopTimer() {
        timer.connect().cancel()
    }

    private func startTimer() {
        timer = Timer.publish(every: 1, on: .main, in: .common)
        _ = timer.connect()
    }
    
    func asyncsaveresttime(_ newseconds: Int) {
        if var _config = preference.config {
            _config.restinterval = newseconds
            
            DispatchQueue(label: "savesecondsasync", qos: .background).async {
                try! AppDatabase.shared.saveConfig(&_config)
            }
        }
    }
}

public extension KSTimerView {
    struct Configuration {
        var timerBgColor: Color = .blue
        var timerRingBgColor: Color = .blue
        var actionButtonsBgColor: Color = .blue
        var foregroundColor: Color = .white
        var stepperValue: TimeInterval = 10
        var enableLocalNotification: Bool = true
        var enableHapticFeedback: Bool = true

        public init(timerBgColor: Color = .blue, timerRingBgColor: Color = .blue, actionButtonsBgColor: Color = .blue, foregroundColor: Color = .white, stepperValue: TimeInterval = 10, enableLocalNotification: Bool = true, enableHapticFeedback: Bool = true) {
            self.timerBgColor = timerBgColor
            self.timerRingBgColor = timerRingBgColor
            self.actionButtonsBgColor = actionButtonsBgColor
            self.foregroundColor = foregroundColor
            self.stepperValue = stepperValue
            LocalNotificationHelper.shared.isEnabled = enableLocalNotification
            HapticHelper.shared.isEnabled = enableHapticFeedback
        }
    }
}

struct TimerControlStyle: ViewModifier {
    var backgroundColor: Color

    func body(content: Content) -> some View {
        content
            .font(.body)
            .frame(width: 60, height: 30)
            .background(backgroundColor)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

extension View {
    func timerControlStyle(backgroundColor: Color) -> some View {
        modifier(TimerControlStyle(backgroundColor: backgroundColor))
    }
}
