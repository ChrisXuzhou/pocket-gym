//
//  Newaroutinebetasheet.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/9/29.
//

import SwiftUI

struct Newaroutinebetasheet_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            ContentView()
        }
    }
}

enum Newaroutineaction {
    case newfolder, newroutine, newworkout, noneaction
}

struct Newaroutinebetasheet: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var foldersmodel: Foldersmodel

    var callback: (_ isfolder: Newaroutineaction) -> Void = { _ in }

    var nextbutton: some View {
        HStack(spacing: 0) {
            Button {
                callback(.newroutine)
            } label: {
                Imagetextbutton(
                    img: Image(systemName: "plus.circle").renderingMode(.template),
                    imgsize: 25,
                    imgcolor: NORMAL_BUTTON_COLOR,
                    text: "routine",
                    width: 120
                )
                .frame(width: BUTTON_START_WIDTH)
            }
    
            Button {
                callback(.newworkout)
            } label: {
                Imagetextbutton(
                    img: Image(systemName: "plus.circle.fill").renderingMode(.template),
                    imgsize: 25,
                    imgcolor: preference.theme,
                    text: "newworkout",
                    width: 120
                )
                .frame(width: BUTTON_START_WIDTH)
            }
        }
    }

    var cancelbutton: some View {
        Button {
            callback(.noneaction)
        } label: {
            HStack {
                LocaleText("cancel")
                    .font(.system(size: DEFINE_FONT_SMALL_SIZE, design: .rounded))
                    .foregroundColor(NORMAL_LIGHTER_COLOR)
            }
            .frame(height: 50)
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            SPACE

            nextbutton

            SPACE

            LOCAL_DIVIDER

            cancelbutton
        }
    }
}
