//
//  Texteditorview.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/3/10.
//

import SwiftUI

struct Texteditorview_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            TexteditorView(
                value: "",
                title: "训练记录"
            )
        }
    }
}

struct TexteditorView: View {
    @Environment(\.presentationMode) var presentmode
    @EnvironmentObject var preference: PreferenceDefinition

    @State var value: String
    var title: String?
    var editor: Texteditor?

    init(value: String,
         title: String? = nil,
         editor: Texteditor? = nil
    ) {
        _value = .init(initialValue: value)
        self.title = title
        self.editor = editor

        UITextView.appearance().backgroundColor = .clear
    }

    @FocusState private var isfocused: Bool

    func save() {
        if let _editor = editor {
            _editor.save(value)
        }
    }

    var uptabview: some View {
        HStack(alignment: .lastTextBaseline) {
            Button {
                presentmode.wrappedValue.dismiss()
            } label: {
                LocaleText("cancel")
                    .foregroundColor(NORMAL_LIGHTER_COLOR)
                    .font(.system(size: DEFINE_FONT_SMALL_SIZE))
                    .frame(width: SHEET_BUTTON_WIDTH, alignment: .leading)
            }

            SPACE

            if let _title = title {
                Text(_title)
            }

            SPACE

            Button {
                withAnimation {
                    save()
                    presentmode.wrappedValue.dismiss()
                }
            } label: {
                LocaleText("finish")
                    .foregroundColor(preference.theme)
                    .font(.system(size: DEFINE_FONT_SMALL_SIZE))
                    .frame(width: SHEET_BUTTON_WIDTH, alignment: .trailing)
            }
        }
        .font(.system(size: DEFINE_FONT_SMALL_SIZE).bold())
        .foregroundColor(NORMAL_COLOR)
        .padding(.horizontal)
        .frame(height: SHEET_HEADER_HEIGHT)
        .background(
            NORMAL_BG_CARD_COLOR.ignoresSafeArea()
        )
    }

    var inputcontent: some View {
        VStack {
            TextEditor(text: $value)
                .lineSpacing(4)
                .font(.system(size: DEFINE_FONT_SIZE))
                .focused($isfocused)
                .foregroundColor(NORMAL_LIGHTER_COLOR)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        isfocused = true
                    }
                }
                .padding(10)

            SPACE
        }
        .background(
            NORMAL_BG_CARD_COLOR
        )
    }

    var body: some View {
        VStack(spacing: 0) {
            uptabview

            inputcontent
        }
        .ignoresSafeArea(.keyboard)
    }
}

struct TexteditorbetaView: View {
    @Environment(\.presentationMode) var presentmode
    @EnvironmentObject var preference: PreferenceDefinition

    @Binding var value: String
    var title: String?

    init(value: Binding<String>, title: String? = nil) {
        _value = value
        self.title = title

        UITextView.appearance().backgroundColor = .clear
    }

    @FocusState private var isfocused: Bool

    var uptabview: some View {
        HStack(alignment: .lastTextBaseline) {
            Button {
                presentmode.wrappedValue.dismiss()
            } label: {
                LocaleText("cancel")
                    .foregroundColor(NORMAL_LIGHTER_COLOR)
                    .font(.system(size: DEFINE_FONT_SMALL_SIZE))
                    .frame(width: SHEET_BUTTON_WIDTH, alignment: .leading)
            }

            SPACE

            if let _title = title {
                Text(_title)
            }
            SPACE

            Button {
                withAnimation {
                    presentmode.wrappedValue.dismiss()
                }
            } label: {
                LocaleText("finish")
                    .foregroundColor(preference.theme)
                    .font(.system(size: DEFINE_FONT_SMALL_SIZE))
                    .frame(width: SHEET_BUTTON_WIDTH, alignment: .trailing)
            }
        }
        .font(.system(size: DEFINE_FONT_SMALL_SIZE).bold())
        .foregroundColor(NORMAL_COLOR)
        .padding(.horizontal)
        .frame(height: SHEET_HEADER_HEIGHT)
        .background(
            NORMAL_BG_CARD_COLOR.ignoresSafeArea()
        )
    }

    var inputcontent: some View {
        VStack {
            TextEditor(text: $value)
                .lineSpacing(4)
                .font(.system(size: DEFINE_FONT_SIZE))
                .focused($isfocused)
                .foregroundColor(NORMAL_LIGHTER_COLOR)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        isfocused = true
                    }
                }
                .padding(10)

            SPACE
        }
        .background(
            NORMAL_BG_CARD_COLOR
        )
    }

    var body: some View {
        VStack(spacing: 0) {
            uptabview

            inputcontent
        }
        .ignoresSafeArea(.keyboard)
    }
}
