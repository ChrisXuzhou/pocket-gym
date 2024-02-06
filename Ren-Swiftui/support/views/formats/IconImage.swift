import SwiftUI

struct Headerimage: View {
    var imgName: String

    var body: some View {
        Image(imgName)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 40, height: 40, alignment: .center)
    }
}

struct Headerimage_Previews: PreviewProvider {
    static var previews: some View {
        Headerimage(imgName: "icon_muscle")
    }
}
