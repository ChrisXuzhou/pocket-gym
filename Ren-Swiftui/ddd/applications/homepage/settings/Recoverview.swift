//
//  Recoverview.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/6/27.
//

import SwiftUI

struct Recoverview_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            ErrConnect2Cloud()
        }

        DisplayedView {
            Recoverview()
        }
    }
}

let BACKUP_BUTTON_WIDTH: CGFloat = UIScreen.width - 20
let BACKUP_BUTTON_HEIGHT: CGFloat = 180

struct Recoverlabel: View {
    @State var icloudiserr: Bool = false

    var body: some View {
        ZStack {
            Listitemlabel(
                img: icloudiserr ? Image("warning") : nil,
                keyortitle: "datarecovery"
            ) {
                Image(systemName: "chevron.right")
                    .foregroundColor(NORMAL_GRAY_COLOR)
            }
            .onAppear {
                DispatchQueue(label: "Recoverstatchecker", qos: .background).async {
                    Backupadaptor.shared.checkcloud { succeed, msg in
                        icloudiserr = !succeed

                        if !succeed {
                            if let _msg = msg {
                                log("[check cloud err] \(_msg)")
                            }
                        }
                    }
                }
            }
        }
    }
}

struct Recoverview: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @Environment(\.presentationMode) var presentmode

    @State var icloudisready: Bool = false
    @State var icloudiserr: Bool = false
    @State var msg: String = "fetching err.."
    @State var bkuserid: String = ""

    var body: some View {
        ZStack {
            NORMAL_BG_COLOR.ignoresSafeArea()

            VStack(spacing: 0) {
                upheader

                ZStack {
                    VStack(spacing: 0) {
                        ScrollView(.vertical, showsIndicators: false) {
                            content
                        }

                        SPACE
                    }

                    icloudstatuslayer
                }
            }
        }
        .onAppear {
            DispatchQueue.main.async {
                Backupadaptor.shared.checkcloud { succeed, msg in
                    icloudisready = true
                    icloudiserr = !succeed

                    if let _msg = msg {
                        self.msg = _msg
                    }
                }
            }
        }
    }
}

extension Recoverview {
    var upheader: some View {
        HStack {
            Button {
                presentmode.wrappedValue.dismiss()
            } label: {
                Backarrow()
            }
            .padding(.trailing, 10)

            SPACE

            LocaleText("datarecovery", usefirstuppercase: false)
                .font(.system(size: DEFINE_FONT_SMALL_SIZE).bold())
                .foregroundColor(NORMAL_LIGHTER_COLOR)

            SPACE

            SPACE.frame(width: 28)
        }
        .padding(.horizontal)
        .background(
            NORMAL_UPTAB_BACKGROUND_COLOR.ignoresSafeArea()
        )
    }

    var content: some View {
        VStack {
            SPACE.frame(height: 20)

            Recoverpanel()

            recoverattension
                .padding(.horizontal, 25)
                .padding(.vertical, 10)

            LOCAL_DIVIDER

            SPACE

            SPACE.frame(height: MIN_DOWN_TAB_HEIGHT)
        }
    }

    var recoverattension: some View {
        VStack(spacing: 10) {
            HStack {
                if !bkuserid.isEmpty {
                    let todisplay = preference.languagewithplaceholder("recoverfrom", firstletteruppercase: false, value: bkuserid)

                    Text(todisplay)
                        .lineSpacing(5)
                }

                SPACE
            }
            .task {
                Icloudadaptor.shared.fetchuserid { userid in
                    self.bkuserid = userid
                }
            }

            HStack {
                LocaleText("recoverydesc", usefirstuppercase: false, linespacing: 5)

                SPACE
            }
        }
        .font(.system(size: DEFINE_FONT_SMALLER_SIZE))
        .foregroundColor(NORMAL_LIGHTER_COLOR.opacity(0.7))
    }
}

extension Recoverview {
    var icloudstatuslayer: some View {
        ZStack {
            if !icloudisready {
                NORMAL_BG_COLOR.opacity(0.95).ignoresSafeArea()

                VStack {
                    LocaleText("connecttoicloud")
                        .font(.system(size: DEFINE_FONT_SMALLER_SIZE).bold().italic())
                        .foregroundColor(preference.themeprimarycolor)

                    Spinner()
                }
            }

            if icloudiserr {
                ErrConnect2Cloud(msg: msg)
            }
        }
    }
}

struct Spinner: View {
    let rotationTime: Double = 0.75
    let animationTime: Double = 1.9 // Sum of all animation times
    let fullRotation: Angle = .degrees(360)
    static let initialDegree: Angle = .degrees(270)

    @State var spinnerStart: CGFloat = 0.0
    @State var spinnerEndS1: CGFloat = 0.03
    @State var spinnerEndS2S3: CGFloat = 0.03

    @State var rotationDegreeS1 = initialDegree
    @State var rotationDegreeS2 = initialDegree
    @State var rotationDegreeS3 = initialDegree

    var body: some View {
        ZStack {
            ZStack {
                // S3
                SpinnerCircle(start: spinnerStart, end: spinnerEndS2S3, rotation: rotationDegreeS3, color: NORMAL_THEME_COLOR)

                // S2
                SpinnerCircle(start: spinnerStart, end: spinnerEndS2S3, rotation: rotationDegreeS2, color: NORMAL_THEME_PINK_COLOR)

                // S1
                SpinnerCircle(start: spinnerStart, end: spinnerEndS1, rotation: rotationDegreeS1, color: NORMAL_THEME_COLOR.opacity(0.3))

            }.frame(width: 100, height: 100)
        }
        .onAppear {
            self.animateSpinner()
            Timer.scheduledTimer(withTimeInterval: animationTime, repeats: true) { _ in
                self.animateSpinner()
            }
        }
    }

    // MARK: Animation methods

    func animateSpinner(with duration: Double, completion: @escaping (() -> Void)) {
        Timer.scheduledTimer(withTimeInterval: duration, repeats: false) { _ in
            withAnimation(Animation.easeInOut(duration: self.rotationTime)) {
                completion()
            }
        }
    }

    func animateSpinner() {
        animateSpinner(with: rotationTime) { self.spinnerEndS1 = 1.0 }

        animateSpinner(with: (rotationTime * 2) - 0.025) {
            self.rotationDegreeS1 += fullRotation
            self.spinnerEndS2S3 = 0.8
        }

        animateSpinner(with: rotationTime * 2) {
            self.spinnerEndS1 = 0.03
            self.spinnerEndS2S3 = 0.03
        }

        animateSpinner(with: (rotationTime * 2) + 0.0525) { self.rotationDegreeS2 += fullRotation }

        animateSpinner(with: (rotationTime * 2) + 0.225) { self.rotationDegreeS3 += fullRotation }
    }
}

// MARK: SpinnerCircle

struct SpinnerCircle: View {
    var start: CGFloat
    var end: CGFloat
    var rotation: Angle
    var color: Color

    var body: some View {
        Circle()
            .trim(from: start, to: end)
            .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round))
            .fill(color)
            .rotationEffect(rotation)
    }
}

struct ErrConnect2Cloud: View {
    @EnvironmentObject var preference: PreferenceDefinition

    var msg: String = ""

    var body: some View {
        ZStack {
            NORMAL_BG_COLOR.opacity(0.95).ignoresSafeArea()

            VStack(spacing: 50) {
                HStack {
                    Image(systemName: "multiply.circle.fill")
                        .font(.system(size: 16))

                    LocaleText("errconnecttoicloud", usefirstuppercase: false)
                        .font(.system(size: DEFINE_FONT_SIZE).bold().italic())
                        .foregroundColor(NORMAL_GRAY_COLOR)
                }
                .foregroundColor(NORMAL_RED_COLOR)

                LocaleText("errconnecttoiclouddec", usefirstuppercase: false)
                    .font(.system(size: DEFINE_FONT_SMALL_SIZE))
                    .foregroundColor(NORMAL_LIGHTER_COLOR)

                if !msg.isEmpty {
                    Text(msg)
                        .font(.system(size: DEFINE_FONT_SMALL_SIZE))
                        .foregroundColor(NORMAL_LIGHTER_COLOR)
                }
            }
            .frame(width: 250)
        }
    }
}
