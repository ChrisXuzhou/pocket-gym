//
//  Addatemplatebutton.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/30.
//

import SwiftUI

struct Addatemplatebutton_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Addatemplatebutton(showaddatemplateview: .constant(false))
        }
    }
}

struct Addatemplatebutton: View {
    @EnvironmentObject var preference: PreferenceDefinition

    @Binding var showaddatemplateview: Bool

    var body: some View {
        VStack {
            let addatemplate = preference.language("addatemplate", firstletteruppercase: false)

            Button {
                showaddatemplateview.toggle()
            } label: {
                HStack(spacing: 8) {
                    SPACE

                    Image(systemName: "plus")

                    Text(addatemplate)
                        .tracking(0.5)
                        .lineLimit(2)
                        .minimumScaleFactor(0.01)
                        .multilineTextAlignment(.leading)

                    SPACE
                }
                .font(.system(size: LIBRARY_ADDBUTTON_SIZE).weight(.heavy))
                .foregroundColor(preference.theme)
                .frame(height: 35)
                .clipShape(
                    RoundedRectangle(cornerRadius: 8)
                )
                .padding(.horizontal, 10)
            }
        }
    }
}
