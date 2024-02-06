//
//  Muscleselectormenu.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/3.
//

import SwiftUI

struct Muscleselectormenu_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Muscleselectormenu(pagedto: .constant(.mainmusclegroup))
        }
    }
}

struct Muscleselectormenu: View {
    @Binding var pagedto: Muscleclassify

    var body: some View {
        HStack(spacing: 15) {
            MuscleclassifyIcon(muscleclassify: .mainmusclegroup,
                               pagedto: $pagedto)

            MuscleclassifyIcon(muscleclassify: .accessorymusclegroup,
                               pagedto: $pagedto)

            SPACE
        }
    }
}

let MUSCLE_CLASSIFY_WIDTH: CGFloat = 85
let MUSCLE_CLASSIFY_HEIGHT: CGFloat = 25
let MUSCLE_CLASSIFY_FONT_SIZE: CGFloat = DEFINE_FONT_SMALL_SIZE - 2

struct MuscleclassifyIcon: View {
    @EnvironmentObject var preference: PreferenceDefinition

    let muscleclassify: Muscleclassify
    @Binding var pagedto: Muscleclassify

    var isfocused: Bool {
        pagedto == muscleclassify
    }

    var body: some View {
        HStack {
            LocaleText(muscleclassify.name)
                .font(.system(size: MUSCLE_CLASSIFY_FONT_SIZE).bold())
        }
        .frame(height: MUSCLE_CLASSIFY_HEIGHT)
        .foregroundColor(
            isfocused ? preference.theme : NORMAL_BUTTON_COLOR
        )
        .onTapGesture {
            withAnimation {
                pagedto = muscleclassify
            }
        }
    }
}
