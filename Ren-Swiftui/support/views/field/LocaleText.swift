//
//  LocaleText.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/2/22.
//

import SwiftUI

struct LocaleText: View {
    @EnvironmentObject var preference: PreferenceDefinition

    init(
        _ id: String,
        usefirstuppercase: Bool = true,
        lowercase: Bool = false,
        uppercase: Bool = false,
        linelimit: Int = 4,
        tracking: Double = 0.2,
        alignment: TextAlignment = .leading,
        usescale: Bool = true,
        linespacing: Double = 8
    ) {
        self.id = id
        self.usefirstuppercase = usefirstuppercase
        self.lowercase = lowercase
        self.uppercase = uppercase
        self.linelimit = linelimit
        self.tracking = tracking
        self.alignment = alignment
        self.usescale = usescale
        self.linespacing = linespacing
    }

    var id: String
    var usefirstuppercase: Bool
    var lowercase: Bool
    var uppercase: Bool
    var linelimit: Int
    var tracking: Double
    var alignment: TextAlignment
    var usescale: Bool
    var linespacing: Double
    
    var text: String {
        var text = preference.language(id, firstletteruppercase: usefirstuppercase)
        if lowercase {
            text = text.lowercased()
        }
        if uppercase {
            text = text.uppercased()
        }
        return text
    }

    var body: some View {
        if usescale {
            Text(text)
                .tracking(tracking)
                .lineLimit(linelimit)
                .minimumScaleFactor(0.01)
                .multilineTextAlignment(alignment)
                .lineSpacing(linespacing)

        } else {
            Text(text)
                .tracking(tracking)
                .lineLimit(linelimit)
                .multilineTextAlignment(alignment)
                .lineSpacing(linespacing)
        }
    }
}
