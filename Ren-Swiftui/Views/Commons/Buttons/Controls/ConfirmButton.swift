import SwiftUI

struct ConfirmButton: View {
    var body: some View {
        Button(action: {
        }, label: {
            HStack {
                Text("超级组")
                    .font(.system(size: 17))
                    .bold()
                    .frame(width: 100, height: 60)
                    .foregroundColor(.blue)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.blue, lineWidth: 3).padding(6)
                    )
            }

        })
    }
}

struct ConfirmButton_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmButton()
    }
}
