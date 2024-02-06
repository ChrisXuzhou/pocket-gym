import SwiftUI

struct Rate_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Rate(first: 1.0, second: 3.0)
        }
    }
}

struct Rate: View {
    var first: Double
    var firstfontsize: CGFloat = 30
    var second: Double
    var secondfontsize: CGFloat = 18

    var firstColor: Color {
        first == 0.0 ? NORMAL_LIGHTER_COLOR :
            (first == second ? NORMAL_GREEN_COLOR : NORMAL_GRAY_COLOR)
    }

    var body: some View {
        HStack(alignment: .lastTextBaseline, spacing: 1) {
            Text(String(format: "%.1f", first))
                .font(.system(size: firstfontsize).bold())
                .foregroundColor(firstColor)
                .padding(0)

            Text("/")
                .bold()
                .scaleEffect(0.8)
                .padding(2)

            Text(String(format: "%.1f", second))
                .font(.system(size: secondfontsize).bold())
        }
        .foregroundColor(Color(.systemGray3))
        .padding(0)
    }
}

let PROCESS_WIDTH: CGFloat = 40

struct Process: View {
    var first: Int
    var second: Int

    var firstfontsize: CGFloat = DEFINE_FONT_SMALL_SIZE - 1
    var secondfontsize: CGFloat = DEFINE_FONT_SMALL_SIZE - 2

    var number: CGFloat = 23
    var primarycolor: Color = NORMAL_GREEN_COLOR
    var fontcolor: Color = BATCH_LABEL_BUTTON_COLOR

    var body: some View {
        HStack(alignment: .lastTextBaseline, spacing: 1) {
            Text(first.description)
                .lineLimit(1)
                .minimumScaleFactor(0.01)
                .font(.system(size: firstfontsize, design: .rounded).bold())
                .foregroundColor(primarycolor)

            HStack(alignment: .lastTextBaseline, spacing: 1) {
                Text("/").bold().scaleEffect(0.8)

                Text(second.description)
                    .lineLimit(1)
                    .minimumScaleFactor(0.01)
            }
            .font(.system(size: secondfontsize, design: .rounded).bold())
            .foregroundColor(fontcolor)
        }
        .frame(width: PROCESS_WIDTH)
    }
}
