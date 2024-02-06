import SwiftUI

struct SheetHeardBar: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 2)
            .frame(width: 50, height: 5)
            .foregroundColor(Color("Background"))
            .padding(.vertical)
    }
}

struct SheetHeardBar_Previews: PreviewProvider {
    static var previews: some View {
        SheetHeardBar()
    }
}
