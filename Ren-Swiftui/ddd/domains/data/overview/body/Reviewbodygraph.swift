import SwiftUI

enum Frontorback: String, Codable {
    case frontbody, backbody

    var name: String {
        switch self {
        case .frontbody:
            return "Front"
        case .backbody:
            return "Back"
        }
    }
}

struct Reviewbodygraph: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var model: Reviewpanelmodel

    var pagedto: Frontorback

    func img(_ muscle: String, w: CGFloat, h: CGFloat) -> some View {
        let name = muscle.capitalizingfirstletter() + " - " + pagedto.name + "_Normal"
        let image = UIImage(named: name)!
        let width = image.size.width
        let height = image.size.height

        let _w = w * (width / DefinedMuscles.width)
        let _h = h * (height / DefinedMuscles.height)

        return Image(uiImage: image)
            .renderingMode(.template)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: _w, height: _h)
    }

    var background: some View {
        ZStack {
            DefinedMuscles.ofSkins(pagedto)
                .resizable()
                .aspectRatio(contentMode: .fit)

            DefinedMuscles.ofmuscles(pagedto)
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(NORMAL_BG_COLOR)
        }
    }

    func widthAndHeight(w: CGFloat, h: CGFloat) -> (CGFloat, CGFloat) {
        let transferedH = w * (DefinedMuscles.height / DefinedMuscles.width)
        if transferedH >= h {
            let _w = h * (DefinedMuscles.width / DefinedMuscles.height)
            return (_w, h)
        } else {
            return (w, transferedH)
        }
    }

    var overlayed: some View {
        ZStack {
            GeometryReader {
                proxy in

                let width = proxy.size.width
                let height = proxy.size.height

                let dict = MusclepositionDictionary.shared
                let maindescriptors: [Muscledescripor] = model.descriptors

                ForEach(0 ..< maindescriptors.count, id: \.self) {
                    idx in

                    let d: Muscledescripor = maindescriptors[idx]
                    let muscleid = d.graphmuscleid //d.muscleid
                    let musclecolor = model.days.displaymusclecolor(Double(model.days))

                    if let position = dict.of(muscleid, frontorback: pagedto) {
                        img(muscleid, w: width, h: height)
                            .foregroundColor(
                                musclecolor.color
                            )
                            .offset(x: width * position.x, y: height * position.y)
                            .zIndex(Double(position.z + 100))
                            .id(muscleid)
                    }
                }
            }
        }
        .animationsDisabled()
    }

    var musclegrapview: some View {
        HStack(spacing: 0) {
            GeometryReader {
                reader in

                let _f = widthAndHeight(w: reader.size.width, h: reader.size.height)
                let _lw: CGFloat = (reader.size.width - _f.0) / 2

                HStack(spacing: 0) {
                    SPACE
                        .frame(width: _lw)

                    ZStack {
                        background
                        overlayed
                    }
                    .frame(width: _f.0, height: _f.1)

                    SPACE
                        .frame(width: _lw)
                }
            }
        }
    }

    var body: some View {
        VStack {
            musclegrapview
        }
    }
}

extension View {
    func animationsDisabled() -> some View {
        return transaction { (tx: inout Transaction) in
            tx.disablesAnimations = true
            tx.animation = nil
        }
        .animation(nil, value: UUID())
    }
}
