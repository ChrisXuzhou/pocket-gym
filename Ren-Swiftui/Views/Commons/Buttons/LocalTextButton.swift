import SwiftUI

struct LocalTextButton: View {
    var text: String
    var textWidth: CGFloat = 70

    var body: some View {
        HStack {
            Text(text).bold()
        }
        .frame(width: textWidth, height: 45, alignment: .center)
        .background(Color.gray)
        .foregroundColor(.white)
        .clipShape(
            RoundedRectangle(cornerRadius: 15)
        )
        .padding(10)
    }
}

struct LocalTextButton_Previews: PreviewProvider {
    static var previews: some View {
        LocalTextButton(text: "添加")
    }
}
