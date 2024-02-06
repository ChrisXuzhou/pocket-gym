import SwiftUI

struct Percent: View {
    var number: Int
    var size: CGFloat = 13

    var numberInDisplay: String {
        String(format: "%.2f", Double(number) / 100)
    }

    var body: some View {
        HStack(alignment: .lastTextBaseline, spacing: 0) {
            Text(numberInDisplay)
                .font(.system(size: size).bold())
                .padding(0)

            Text("%")
                .font(.system(size: 10).bold())
                .padding(.leading, 2)
        }
        .foregroundColor(
            number >= 0 ?
            NORMAL_GREEN_COLOR : NORMAL_RED_COLOR.opacity(0.9)
        )
    }
}

struct Percent_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Percent(number: 7100)
            Percent(number: -7100)
        }
    }
}
