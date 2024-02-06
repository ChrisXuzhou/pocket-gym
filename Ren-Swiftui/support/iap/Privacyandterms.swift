//
//  Privacyandterms.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/6/7.
//

import SwiftUI

struct Privacyandterms_Previews: PreviewProvider {
    static var previews: some View {
        let privacy = Privacyandtermstype.privacy

        DisplayedView {
            Linklabel(
                label: privacy.label,
                url: privacy.url
            )
        }
    }
}

struct Privacyandterms: View {
    var body: some View {
        HStack(spacing: 30) {
            SPACE
            Linklabel(label: Privacyandtermstype.terms.label,
                      url: Privacyandtermstype.terms.url
            )
            Linklabel(label: Privacyandtermstype.privacy.label,
                      url: Privacyandtermstype.privacy.url
            )
            SPACE
        }
    }
}

enum Privacyandtermstype {
    case privacy, terms

    var url: String {
        switch self {
        case .privacy:
            return "https://www.termsfeed.com/live/a091e2c3-36c2-4311-8d34-9fe3e197dc71"
        case .terms:
            return "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/"
        }
    }

    var label: String {
        switch self {
        case .privacy:
            return "privacy"
        case .terms:
            return "terms"
        }
    }
}

struct Linklabel: View {
    var label: String
    var url: String
    var color: Color = NORMAL_LIGHT_BUTTON_COLOR

    var body: some View {
        Button {
            UIApplication.shared.open(URL(string: url)!)
        } label: {
            LocaleText(label)
                .font(.system(size: DEFINE_FONT_SMALLER_SIZE).bold())
                .foregroundColor(color)
        }
    }
}
