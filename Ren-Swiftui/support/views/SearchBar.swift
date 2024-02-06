import SwiftUI

struct Searchbar_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Searchbar(searchText: .constant(""))
        }
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct ResignKeyboardOnDragGesture: ViewModifier {
    var gesture = DragGesture().onChanged { _ in
        UIApplication.shared.endEditing()
    }

    func body(content: Content) -> some View {
        content.gesture(gesture)
    }
}

extension View {
    func resignKeyboardOnDragGesture() -> some View {
        modifier(ResignKeyboardOnDragGesture())
    }
}

struct Searchbar: View {
    @EnvironmentObject var preference: PreferenceDefinition

    @Binding var searchText: String
    @FocusState var focusedfield: Bool

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .padding(.leading, 5)

            TextField(
                preference.language("search"),
                text: $searchText,
                onCommit: {
                    UIApplication.shared.endEditing()
                }
            )
            .font(.system(size: DEFINE_FONT_SMALL_SIZE))
            .keyboardType(.default)
            .submitLabel(.done)

            Button(action: {
                self.searchText = ""
                focusedfield = true
            }) {
                Image(systemName: "xmark.circle.fill").opacity(searchText == "" ? 0 : 1)
            }
            .padding(.trailing, 5)
        }
        .foregroundColor(NORMAL_LIGHTER_COLOR.opacity(0.7))
        .focused($focusedfield)
        .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
        .cornerRadius(10)
        .onTapGesture {
            focusedfield = true
        }
    }
}
