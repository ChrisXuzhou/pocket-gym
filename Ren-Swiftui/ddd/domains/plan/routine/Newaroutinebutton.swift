//
//  Newatemplatebutton.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/28.
//

import Shapes
import SwiftUI

struct Newaroutinebutton_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Newaroutinebutton()
        }
    }
}

struct Newaroutinebutton: View {
    @EnvironmentObject var preference: PreferenceDefinition

    @State var shownewatemplateview = false

    @EnvironmentObject var model: Routinelistmodel

    var body: some View {
        VStack {
            let newatemplate = preference.language("newatemplate")

            Button {
                shownewatemplateview.toggle()
            } label: {
                HStack {
                    SPACE

                    Image(systemName: "plus")
                        .font(
                            .system(size: 18)
                                .bold()
                        )

                    Text(newatemplate)
                        .tracking(0.5)
                        .lineLimit(2)
                        .minimumScaleFactor(0.01)
                        .multilineTextAlignment(.leading)
                        .font(.system(size: LIBRARY_ADDBUTTON_SIZE).bold())

                    SPACE
                }
                .foregroundColor(.white)
                .frame(width: LIBRARY_DOWNBAR_WIDTH, height: LIBRARY_DOWNBAR_HEIGHT)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(NORMAL_LIGHT_GRAY_COLOR)
                )
            }
            .confirmationDialog(
                Text(newatemplate + "?"),
                isPresented: $shownewatemplateview,
                titleVisibility: .visible
            ) {
                Button {
                    model.createanewtemplate()
                } label: {
                    LocaleText("ok")
                }
            }

        }
    }
}
