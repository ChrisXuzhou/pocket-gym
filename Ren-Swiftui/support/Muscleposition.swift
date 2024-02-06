import Foundation
import SwiftUI

class Muscleposition {
    var muscle: String
    var x: Double
    var y: Double
    var z: Double

    init(_ muscle: String, x: Double, y: Double, z: Double) {
        self.muscle = muscle
        self.x = x
        self.y = y
        self.z = z
    }
}

extension Muscleposition: Equatable {
    static func == (lhs: Muscleposition, rhs: Muscleposition) -> Bool {
        lhs.muscle == rhs.muscle
    }
}

class MusclepositionDictionary {
    static var backParts = [
        Muscleposition("abductors", x: 0.345, y: 0.462, z: 19),
        Muscleposition("back", x: 0.340, y: 0.221, z: 13),
        Muscleposition("glutes", x: 0.378, y: 0.417, z: 23),
        Muscleposition("hamstrings", x: 0.335, y: 0.497, z: 22),
        Muscleposition("obliques", x: 0.374, y: 0.352, z: 14),
        Muscleposition("shoulders", x: 0.281, y: 0.182, z: 6),
        Muscleposition("triceps", x: 0.242, y: 0.245, z: 10),
        Muscleposition("lowerback", x: 0.411, y: 0.340, z: 16),
        Muscleposition("calves", x: 0.338, y: 0.681, z: 25),
        Muscleposition("trapezius", x: 0.358, y: 0.116, z: 3),
        Muscleposition("forearms", x: 0.150, y: 0.326, z: 9),
    ]

    static var frontParts = [
        Muscleposition("chest", x: 0.323, y: 0.186, z: 7),
        Muscleposition("abs", x: 0.393, y: 0.266, z: 15),
        Muscleposition("abductors", x: 0.345, y: 0.421, z: 19),
        Muscleposition("adductors", x: 0.44, y: 0.470, z: 20),
        Muscleposition("back", x: 0.341, y: 0.257, z: 13),
        Muscleposition("biceps", x: 0.248, y: 0.249, z: 12),
        Muscleposition("obliques", x: 0.372, y: 0.310, z: 14),
        Muscleposition("quadriceps", x: 0.335, y: 0.4422, z: 18),
        Muscleposition("shoulders", x: 0.275, y: 0.177, z: 6),
        Muscleposition("calves", x: 0.336, y: 0.718, z: 25),
        Muscleposition("trapezius", x: 0.366, y: 0.148, z: 3),
        Muscleposition("forearms", x: 0.150, y: 0.328, z: 9),
        Muscleposition("neck", x: 0.454, y: 0.140, z: 4),
    ]

    var frontDict: [String: Muscleposition]

    var backDict: [String: Muscleposition]

    func of(_ key: String, frontorback: Frontorback = .frontbody) -> Muscleposition? {
        switch frontorback {
        case .frontbody:
            return frontDict[key]

        case .backbody:
            return backDict[key]
        }
    }

    private init() {
        frontDict = Dictionary(uniqueKeysWithValues: MusclepositionDictionary.frontParts.map({
            ($0.muscle, $0)
        }))

        backDict = Dictionary(uniqueKeysWithValues: MusclepositionDictionary.backParts.map({
            ($0.muscle, $0)
        }))
    }
}

extension MusclepositionDictionary {
    static var shared = MusclepositionDictionary()
}

class DefinedMuscles {
    static var width: CGFloat = 417
    static var height: CGFloat = 752

    static func ofSkins(_ frontorback: Frontorback) -> Image {
        let img = "Man-" + frontorback.name + "-Skin_Normal"
        let image = UIImage(named: img)!
        /*

         let width = image.size.width
         let height = image.size.height

         */

        return Image(uiImage: image)
    }

    static func ofmuscles(_ frontorback: Frontorback) -> Image {
        let img = "Man-" + frontorback.name + "-Muscles_Normal"
        let image = UIImage(named: img)!

        /*

         let width = image.size.width
         let height = image.size.height

         */

        return Image(uiImage: image)
    }
}
