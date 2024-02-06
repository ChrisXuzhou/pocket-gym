import SwiftUI

struct SmallTitle: View {
    let name: String

    var body: some View {
        HStack {
            Text(name)
                .lineLimit(1)
                .foregroundColor(Color.primary.opacity(0.7))
                .font(.system(size: TITLE_TEXT_SIZE).bold())
                .frame(minWidth: 0, maxWidth: 150, alignment: .leading)
                .padding(.horizontal, 10)
                .padding(.bottom, 0)

            Spacer()
        }
    }
}

struct SmallTitle_Previews: PreviewProvider {
    static var previews: some View {
        SmallTitle(name: "引体向上")
    }
}
