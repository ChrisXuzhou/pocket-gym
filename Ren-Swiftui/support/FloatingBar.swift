
import SwiftUI

struct FloatingBar<ButtonsView>: View where ButtonsView: View {
    var width: CGFloat
    var height: CGFloat

    let content: () -> ButtonsView

    init(width: CGFloat = 50, height: CGFloat = 50,
         @ViewBuilder content: @escaping () -> ButtonsView) {
        self.width = width
        self.height = height
        self.content = content
    }

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                self.content()
                    .padding(.trailing, 30)
                    .padding(.bottom, 40)
            }
        }
    }
}

struct FloatingButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(.system(size: 45))
            .scaleEffect(configuration.isPressed ? 1.4 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
            .background(
                Circle().foregroundColor(Color(.systemGray6))
                    .scaleEffect(0.8).shadow(radius: 3)
            )
    }
}

struct SmallFloatingButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(.system(size: 40))
            .scaleEffect(configuration.isPressed ? 1.4 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
            .background(
                Circle().foregroundColor(Color(.systemGray6))
                    .scaleEffect(0.8).shadow(radius: 3)
            )
    }
}

struct TinyFloatingButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(.system(size: 35))
            .scaleEffect(configuration.isPressed ? 1.4 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
            .background(
                Circle().foregroundColor(Color(.systemGray6))
                    .scaleEffect(0.8)
            )
    }
}

struct FloatingBar_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Color.clear
                .overlay(
                    FloatingBar {
                        Button {
                        } label: {
                            Image(systemName: "play.circle.fill").foregroundColor(NORMAL_GREEN_COLOR)
                        }
                        .buttonStyle(FloatingButtonStyle())
                    }
                )
        }
    }
}
