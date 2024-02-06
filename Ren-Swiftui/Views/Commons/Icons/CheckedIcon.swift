import SwiftUI

struct CheckedIcon: View {
    var body: some View {
        Image(systemName: "checkmark.circle.fill")
            .font(.system(size: 40))
            .foregroundColor(Color.blue)
            .frame(width: 50, height: 50)
            .background(Color.clear)
    }
}

struct CheckedIcon_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CheckedIcon()
        }
    }
}
