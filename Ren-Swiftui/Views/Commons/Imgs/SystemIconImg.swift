import SwiftUI

struct SystemIconImg: View {
    var systemName: String

    var body: some View {
        Image(systemName: systemName)
            .font(.system(size: LARGE_TEXT_SIZE + 2))
    }
}

struct SystemIconImg_Previews: PreviewProvider {
    static var previews: some View {
        SystemIconImg(systemName: "stopwatch.fill")
    }
}
