import SwiftUI

struct DownControlBar<ButtonsView>: View where ButtonsView: View {
    let content: () -> ButtonsView

    init(@ViewBuilder content: @escaping () -> ButtonsView) {
        self.content = content
    }

    var body: some View {
        ZStack {
            Color.black.opacity(0.1)
                .ignoresSafeArea()
            HStack(spacing: 0) {
                self.content()
                    .ignoresSafeArea()
            }
        }
        .frame(height: NORMAL_SUB_CONTROL_HEIGHT,
               alignment: .center)
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(.system(size: NORMAL_BUTTON_SIZE + 10))
            .foregroundColor(configuration.isPressed ? Color.primary : Color.secondary)
            .scaleEffect(configuration.isPressed ? 1.4 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct NormalButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(.system(size: NORMAL_BUTTON_SIZE - 8))
            .foregroundColor(configuration.isPressed ? Color.primary : Color.secondary)
            .scaleEffect(configuration.isPressed ? 1.4 : 1)
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct SmallButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(.system(size: NORMAL_BUTTON_SIZE - 12))
            .foregroundColor(configuration.isPressed ? Color.primary : Color.secondary)
            .scaleEffect(configuration.isPressed ? 1.4 : 1)
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct DownControlBar_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Spacer()

            DownControlBar {
                HStack(alignment: .lastTextBaseline) {
                    Spacer()
                    Button(action: {
                    }, label: {
                        Image(systemName: "stopwatch.fill")

                    })
                        .buttonStyle(SmallButtonStyle())

                    Spacer()
                    Button(action: {
                    }, label: {
                        Image(systemName: "plus.circle")
                    })
                        .buttonStyle(PrimaryButtonStyle())

                    Spacer()
                    Button(action: {
                    }, label: {
                        Image(systemName: "heart.text.square.fill")

                    })
                        .buttonStyle(SmallButtonStyle())
                    Spacer()
                }
            }
        }
    }
}
