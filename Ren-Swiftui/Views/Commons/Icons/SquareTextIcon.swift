import SwiftUI

struct SquareTextIcon: View {
    var i: String
    var bgColor: Color = Color.orange

    var size: CGFloat = 21
    var width: CGFloat = 30

    var body: some View {
        ZStack {
            bgColor

            Text(i)
                .font(.system(size: size).bold())
                .foregroundColor(Color.white)
        }
        .cornerRadius(10)
        .frame(width: width, height: width, alignment: .center)
    }
}

struct SquareTextIcon_Previews: PreviewProvider {
    static var previews: some View {
        SquareTextIcon(i: "1", bgColor: Color.orange)
    }
}
