import SwiftUI

struct LocalDivider: View {
    var color: Color = NORMAL_GRAY_COLOR
    var width: CGFloat = 0.5
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(height: width)
            .edgesIgnoringSafeArea(.horizontal)
    }
}

struct LocalDivider_Previews: PreviewProvider {
    static var previews: some View {
        LocalDivider()
    }
}
