//
//  Newsearchpanel.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/10/3.
//
import SwiftUI

struct Newsearchpanel_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            Librarybetaview()
                .navigationBarHidden(true)
        }
    }
}

let SEARCH_BAR_HEIGHT: CGFloat = 40

struct Newsearchpanel: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @EnvironmentObject var librarymodel: Librarybetamodel

    @FocusState var focused: Bool

    var fontcolor: Color = NORMAL_LIGHTER_COLOR
    var fontsize: CGFloat = DEFINE_FONT_SIZE

    var clearbutton: some View {
        Button {
            librarymodel.searchtext = ""
            focused = true
        } label: {
            Image(systemName: "xmark.circle.fill")
                .font(.system(size: fontsize).bold())
                .foregroundColor(NORMAL_BUTTON_COLOR)
        }
    }

    var content: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: fontsize))

            TextField(
                preference.language("exercisename"),
                text: $librarymodel.searchtext
            )
            .font(.system(size: fontsize))
            .keyboardType(.default)
            .submitLabel(.search)
        }
        .foregroundColor(fontcolor)
        .padding(.horizontal, 12)
        .frame(height: SEARCH_BAR_HEIGHT)
    }

    var body: some View {
        ZStack {
            content

            HStack {
                SPACE

                if !librarymodel.searchtext.isEmpty {
                    clearbutton
                }
            }
            .padding(.horizontal, 12)
        }
        .background(LIBRARY_CONTENT_COLOR)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
