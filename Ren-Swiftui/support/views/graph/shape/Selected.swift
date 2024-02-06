//
//  Selected.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/4/20.
//

import SwiftUI

struct Selected_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {Selected()
        }
    }
}

struct Selected: View {
    @EnvironmentObject var preference: PreferenceDefinition

    var fontsize: CGFloat = 12

    var body: some View {
        Image(systemName: "checkmark")
            .renderingMode(.template)
            .resizable()
            .frame(width: fontsize + 5, height: fontsize, alignment: .center)
            .foregroundColor(preference.theme)
            .frame(width: 22, height: 22, alignment: .center)
    }
}
