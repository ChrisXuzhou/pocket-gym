//
//  Plusbutton.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/12/1.
//

import SwiftUI

struct Plusbutton_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            ContentView()
        }
    }
}

struct Plusbutton: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var trainingmodel: Trainingmodel

    var imgsize: CGFloat = 20
    var imgcolor: Color = .white
    var fullsize: CGFloat = 45

    /*
     * call back function while button pressed
     */
    var callback: () -> Void = {}

    var body: some View {
        VStack {
            SPACE

            HStack {
                SPACE

                ZStack(alignment: .trailing) {
                    progressinglable

                    HStack {
                        SPACE

                        Button {
                            callback()
                        } label: {
                            button
                        }
                        .buttonStyle(LocalbuttonStyle())
                    }
                    .padding(.trailing, 3)
                }
                .frame(minWidth: UIScreen.width / 3, maxWidth: UIScreen.width / 2)
                .frame(height: 52)
            }
            .padding(.trailing, 30)
            .padding(.bottom, 80)
        }
    }

    var button: some View {
        Image(systemName: "plus")
            .renderingMode(.template)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: imgsize, height: imgsize, alignment: .center)
            .foregroundColor(imgcolor)
            .frame(width: fullsize, height: fullsize, alignment: .center)
            .background(
                Circle()
                    .foregroundColor(preference.theme)
                    .shadow(color: preference.theme.opacity(0.3), radius: 6)
            )
    }

    var progressinglable: some View {
        ZStack {
            if let timer = trainingmodel.trainingtimer {
                if timer.state == .running {
                    HStack {
                        Trainingtimerlabel(
                            trainingtimer: timer,
                            fontsize: 20,
                            leading: false
                        )

                        SPACE.frame(width: 42)
                    }
                    .background(NORMAL_BG_BUTTON_COLOR)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .contentShape(Rectangle())
                    .onTapGesture {
                        trainingmodel.presentworkoutview = true
                    }
                }
            }
        }
    }
}

enum AlertType {
    case success
    case error(title: String, message: String = "")

    func title() -> String {
        switch self {
        case .success:
            return "Success"
        case let .error(title: title, _):
            return title
        }
    }

    func message() -> String {
        switch self {
        case .success:
            return "Please confirm that you're still open to session requests"
        case let .error(_, message: message):
            return message
        }
    }

    /// Left button action text for the alert view
    var leftActionText: String {
        switch self {
        case .success:
            return "Go"
        case .error:
            return "Go"
        }
    }

    /// Right button action text for the alert view
    var rightActionText: String {
        switch self {
        case .success:
            return "Cancel"
        case .error:
            return "Cancel"
        }
    }

    func height(isShowVerticalButtons: Bool = false) -> CGFloat {
        switch self {
        case .success:
            return isShowVerticalButtons ? 220 : 150
        case .error:
            return isShowVerticalButtons ? 220 : 150
        }
    }
}

struct CustomAlert: View {
    /// Flag used to dismiss the alert on the presenting view
    @Binding var presentAlert: Bool

    /// The alert type being shown
    @State var alertType: AlertType = .success

    /// based on this value alert buttons will show vertically
    var isShowVerticalButtons = false

    var leftButtonAction: (() -> Void)?
    var rightButtonAction: (() -> Void)?

    let verticalButtonsHeight: CGFloat = 80

    var body: some View {
        ZStack {
            // faded background
            Color.black.opacity(0.75)
                .edgesIgnoringSafeArea(.all)

            alert
        }
    }

    var alert: some View {
        VStack(spacing: 0) {
            if alertType.title() != "" {
                // alert title
                Text(alertType.title())
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .frame(height: 25)
                    .padding(.top, 16)
                    .padding(.bottom, 8)
                    .padding(.horizontal, 16)
            }

            // alert message
            Text(alertType.message())
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .font(.system(size: 14))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
                .minimumScaleFactor(0.5)

            Divider()
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 0.5)
                .padding(.all, 0)
        }
        .frame(width: 270, height: alertType.height(isShowVerticalButtons: isShowVerticalButtons))
        .background(
            Color.white
        )
        .cornerRadius(4)
    }
}
