import SwiftUI

struct Libraryequipmentindex: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var model: Exerciselabellistmodel
    @GestureState private var isDragging = false

    let proxy: ScrollViewProxy
    let equipments: [String]
    @GestureState private var draglocation: CGPoint = .zero

    var indexlist: [String] {
        if model.recentexerciselist.isEmpty {
            return equipments
        }

        return ["recently"] + equipments
    }

    var body: some View {
        VStack(spacing: 0) {
            ForEach(indexlist, id: \.self) {
                id in
                IndexTitle(id: id)
                    .padding(4)
                    .padding(.trailing, 8)
                    .padding(.vertical, 8)
                    .background(dragObserver(title: id))
            }
        }
        .background(
            isDragging ?
                AnyView(
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(Color.black.opacity(0.1))
                        .padding(.trailing, 8)
                        .padding(.horizontal, 3)
                )
                : AnyView(Color.clear)
        )
        .gesture(
            DragGesture(minimumDistance: 0, coordinateSpace: .global)
                .updating($draglocation) { value, state, _ in
                    state = value.location
                }
                .updating($isDragging) { _, state, _ in
                    state = true
                }
        )
    }

    func dragObserver(title: String) -> some View {
        GeometryReader { geometry in
            dragObserver(geometry: geometry, title: title)
        }
    }

    func dragObserver(geometry: GeometryProxy, title: String) -> some View {
        if geometry.frame(in: .global).contains(draglocation) {
            DispatchQueue.main.async {
                proxy.scrollTo(title, anchor: .center)
            }
        }
        return Rectangle().fill(Color.clear)
    }

    func sfSymbol(for deviceCategory: String) -> Image {
        let systemName: String
        switch deviceCategory {
        default: systemName = "xmark"
        }
        return Image(systemName: systemName)
    }
}

struct IndexTitle: View {
    @EnvironmentObject var preference: PreferenceDefinition
    var id: String

    var firstletter: String {
        let _name = preference.language(id)
        return String(_name.prefix(1))
    }

    var body: some View {
        Text(firstletter)
            .font(
                .system(size: DEFINE_FONT_SMALLER_SIZE - 2)
                // .bold()
            )
            .foregroundColor(
                preference.theme
                // NORMAL_LIGHTER_COLOR.opacity(0.6)
            )
    }
}
