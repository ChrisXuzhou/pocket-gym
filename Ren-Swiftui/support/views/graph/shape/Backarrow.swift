import SwiftUI

struct Backarrow: View {
    var color: Color = NORMAL_LIGHTER_COLOR

    var body: some View {
        Image(systemName: "chevron.left")
            .font(.system(size: DEFINE_FONT_BIG_SIZE).bold())
            .foregroundColor(color)
            .scaleEffect(1)
            .opacity(1)
            .frame(width: 18, height: 50)
            .contentShape(Rectangle())
    }
}

struct BackArrow_Previews: PreviewProvider {
    static var previews: some View {
        Backarrow()
    }
}


struct Systemimage: View {
    var name: String
    var fontsize: CGFloat = DEFINE_FONT_BIG_SIZE
    var color: Color = NORMAL_BUTTON_COLOR
    
    var width: CGFloat = 18
    var height: CGFloat = 50

    var body: some View {
        Image(systemName: name)
            .font(.system(size: fontsize))
            .foregroundColor(color)
            .scaleEffect(1)
            .opacity(1)
            .frame(width: width, height: height)
            .contentShape(Rectangle())
    }
}

struct Systemtempimage: View {
    var name: String
    var imgsize: CGFloat = 26
    
    var body: some View {
        Image(systemName: name)
            .renderingMode(.template)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: imgsize, height: imgsize, alignment: .center)
    }
}
