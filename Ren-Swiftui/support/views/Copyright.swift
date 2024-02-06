import SwiftUI

let COPYRIGHT_BUTTOM_PADDING: CGFloat = UIScreen.height / 10
let COPYRIGHT: some View = Copyright()

let COPYRIGHT_FONT_SIZE: CGFloat = DEFINE_FONT_SMALL_SIZE - 2

struct Copyright: View {
    var copyrightview: some View {
        VStack {
            HStack {
                SPACE
                Text("Created")
                    .font(.system(size: COPYRIGHT_FONT_SIZE))
                SPACE
            }

            Text("by @QuantumBubble")
                .font(.system(size: COPYRIGHT_FONT_SIZE - 2))
        }
        .foregroundColor(NORMAL_GRAY_COLOR.opacity(0.6))
    }

    var body: some View {
        VStack {
            SPACE
            copyrightview
            SPACE
        }
        .frame(height: UIScreen.height / 4)
    }
}

struct Copyright_Previews: PreviewProvider {
    static var previews: some View {
        Copyright()
    }
}
