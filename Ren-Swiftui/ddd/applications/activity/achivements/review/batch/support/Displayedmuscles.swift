//
//  Exerciseandmuscles.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/4.
//

import SwiftUI

struct Displayedmuscles_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            VStack {
                Displayedmuscles(musclelist: [
                ])

                Displayedmuscles(musclelist: [
                    Muscle.shared.definedlist[0],
                    Muscle.shared.definedlist[1],
                ])
            }
        }
    }
}

let DISPLAYED_MUSCLE_ITEM_SIZE: CGFloat = 58
let DISPLAYED_MUSCLE_ITEM_OFFSET_X: CGFloat = 25
let DISPLAYED_MUSCLE_ITEM_REAL_SIZE: CGFloat = DISPLAYED_MUSCLE_ITEM_SIZE - DISPLAYED_MUSCLE_ITEM_OFFSET_X

let DISPLAYED_MUSCLE_MIN_WIDTH: CGFloat = 50
let DISPLAYED_MUSCLE_HEIGHT: CGFloat = 52

struct Displayedmuscles: View {
    @EnvironmentObject var preference: PreferenceDefinition
    var musclelist: [Muscledef]

    var width: CGFloat {
        let _count: CGFloat = musclelist.count < 1 ? CGFloat(0.0) : CGFloat(musclelist.count)
        return DISPLAYED_MUSCLE_ITEM_OFFSET_X + _count * DISPLAYED_MUSCLE_ITEM_REAL_SIZE
    }

    func xoffset(_ idx: Int) -> CGFloat {
        CGFloat(idx) * DISPLAYED_MUSCLE_ITEM_REAL_SIZE
    }

    var body: some View {
        HStack {
            let count = musclelist.count

            if count > 0 {
                ZStack {
                    ForEach(0 ..< count, id: \.self) {
                        idx in
                        let muscle = musclelist[idx]
                        Musclelink(
                            muscle: muscle,
                            displaysize: DISPLAYED_MUSCLE_HEIGHT,
                            showtext: false
                        )
                        .background(
                            Circle()
                                .foregroundColor(preference.themeprimarycolor)
                                .scaleEffect(0.8)
                        )
                        .position(x: DISPLAYED_MUSCLE_ITEM_SIZE / 2, y: DISPLAYED_MUSCLE_HEIGHT / 2)
                        .offset(x: xoffset(idx), y: 0)
                        .zIndex(Double(count - idx))
                    }
                }
                .frame(width: width, height: DISPLAYED_MUSCLE_HEIGHT)
            }
        }
    }
}
