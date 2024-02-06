import SwiftUI

struct Muscleselector_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Muscleselector(
                showtext: true,
                direction: .horizontal,
                pagedto: .constant(.mainmusclegroup),
                selectedmuscle: .constant("chest")
            )
        }

        DisplayedView {
            Muscleselector(
                showtext: true,
                pagedto: .constant(.mainmusclegroup),
                selectedmuscle: .constant("chest")
            )
        }
    }
}

enum LibrarymusclemenuDirection {
    case horizontal, vertival
}

enum Muscleclassify {
    case mainmusclegroup, accessorymusclegroup

    var name: String {
        switch self {
        case .mainmusclegroup:
            return "mainmusclegroup"
        case .accessorymusclegroup:
            return "accessorymusclegroup"
        }
    }
}

struct Muscleselector: View {
    var showtext = false
    var direction: LibrarymusclemenuDirection = .vertival

    @Binding var pagedto: Muscleclassify // = .mainmusclegroup
    @Binding var selectedmuscle: String?

    func muscleview(_ muscle: Muscledef) -> some View {
        Musclelink(
            muscle: muscle,
            highlight: selectedmuscle == muscle.id,
            showtext: showtext
        )
        .onTapGesture {
            if self.selectedmuscle == muscle.id {
                self.selectedmuscle = nil
            } else {
                self.selectedmuscle = muscle.id
            }
        }
    }

    var musclelist: [Muscledef] {
        switch pagedto {
        case .mainmusclegroup:
            return Muscle.shared.mainmuscles
        case .accessorymusclegroup:
            return Muscle.shared.accessorymuscles
        }
    }

    var vertivalview: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 5) {
                let muscles = musclelist

                ForEach(muscles, id: \.id) {
                    each in
                    muscleview(each)
                }
            }
            .padding(.top, 30)
        }
    }

    var horizontalview: some View {
        VStack(spacing: 0) {
            muscleclassifyview
                .padding(.vertical, 5)
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                ScrollViewReader {
                    reader in

                    HStack(spacing: 1) {
                        let muscles = musclelist

                        ForEach(muscles, id: \.id) {
                            each in
                            muscleview(each)
                                .id(each.id)
                        }
                    }
                    .padding(.leading, 5)
                    .onAppear {
                        withAnimation {
                            if let _selected = selectedmuscle {
                                reader.scrollTo(_selected, anchor: .center)
                            }
                        }
                    }
                    .onChange(of: selectedmuscle) { _ in
                        withAnimation {
                            if let _selected = selectedmuscle {
                                reader.scrollTo(_selected, anchor: .center)
                            }
                        }
                    }
                }
            }
        }
    }

    var body: some View {
        VStack {
            switch direction {
            case .horizontal:
                horizontalview
            case .vertival:
                vertivalview
            }
        }
    }

    var muscleclassifyview: some View {
        Muscleselectormenu(pagedto: $pagedto)
    }
}
