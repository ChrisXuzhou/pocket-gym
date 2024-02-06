//
//  SelfieNickEditor.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/2/19.
//

import iPhoneNumberField
import SwiftUI

struct TextfieldditorView_Previews: PreviewProvider {
    static var previews: some View {
        DisplayedView {
            ZStack {
                TextfieldditorView(value: "观博", title: "修改名称")
            }
        }
    }
}

protocol Texteditor {
    func save(_ newvalue: String?)
}

enum textfield {
    case text, phone, number
}

struct TextfieldditorView: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @Environment(\.presentationMode) var present
    var textfield: textfield = .text
    @State var value: String
    var title: String?
    var editor: Texteditor?

    var uptabview: some View {
        HStack(alignment: .lastTextBaseline) {
            Button {
                withAnimation {
                    present.wrappedValue.dismiss()
                }
            } label: {
                LocaleText("cancel")
                    .foregroundColor(NORMAL_LIGHTER_COLOR)
                    .font(.system(size: DEFINE_FONT_SMALL_SIZE))
                    .frame(width: SHEET_BUTTON_WIDTH, alignment: .leading)
            }

            SPACE

            if let _title = title {
                LocaleText(_title)
                    .font(
                        .system(size: DEFINE_SHEET_FONT_SIZE)
                            .bold()
                    )
                    .foregroundColor(NORMAL_LIGHTER_COLOR)
            }
            SPACE

            Button {
                withAnimation {
                    save()
                    present.wrappedValue.dismiss()
                }
            } label: {
                Text(preference.language("save"))
                    .foregroundColor(preference.theme)
                    .font(.system(size: DEFINE_FONT_SMALL_SIZE))
                    .frame(width: SHEET_BUTTON_WIDTH, alignment: .trailing)
            }
        }
        .padding(.horizontal)
        .frame(height: SHEET_HEADER_HEIGHT)
        .background(NORMAL_BG_CARD_COLOR)
    }

    func save() {
        if let _editor = editor {
            _editor.save(value)
        }
    }

    enum FocusField: Hashable {
        case field
    }

    @FocusState var focusedfield: FocusField?

    var inputfield: some View {
        switch textfield {
        case .text:
            return AnyView(
                TextField("", text: $value)
                    .keyboardType(.default)
                    .submitLabel(.done)
            )
        case .phone:
            return AnyView(
                iPhoneNumberField(text: $value)
                    .font(UIFont(size: 16, weight: .light, design: .monospaced))
            )
        case .number:
            return AnyView(
                TextField("", text: $value)
                    .keyboardType(.numberPad)
                    .submitLabel(.done)
            )
        }
    }

    var inputtab: some View {
        HStack {
            inputfield
                .foregroundColor(NORMAL_COLOR)
                .focused($focusedfield, equals: .field)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.focusedfield = .field
                    }
                }

            SPACE

            if textfield != .phone {
                Button {
                    value = ""
                } label: {
                    Image(systemName: "multiply.circle.fill")
                        .foregroundColor(Color(.systemGray4))
                }
            }
        }
        .padding(.horizontal)
        .frame(height: LIST_ITEM_HEIGHT)
        .background(NORMAL_BG_CARD_COLOR)
    }

    var body: some View {
        ZStack {
            NORMAL_BG_COLOR.edgesIgnoringSafeArea(.bottom)

            VStack {
                uptabview

                inputtab

                SPACE
            }
            .font(.system(size: DEFINE_FONT_SMALL_SIZE))
        }
    }
}

struct Textfieldditorsheet: View {
    @EnvironmentObject var preference: PreferenceDefinition
    @Environment(\.presentationMode) var present
    var textfield: textfield = .text
    @State var value: String
    var title: String?
    var hint: String?

    var callback: (_ text: String) -> Void

    var uptabview: some View {
        HStack(alignment: .lastTextBaseline) {
            Button {
                withAnimation {
                    present.wrappedValue.dismiss()
                }
            } label: {
                LocaleText("cancel")
                    .foregroundColor(NORMAL_LIGHTER_COLOR)
                    .font(.system(size: DEFINE_FONT_SMALL_SIZE))
                    .frame(width: SHEET_BUTTON_WIDTH, alignment: .leading)
            }

            SPACE

            if let _title = title {
                LocaleText(_title)
                    .font(
                        .system(size: DEFINE_SHEET_FONT_SIZE)
                            .bold()
                    )
                    .foregroundColor(NORMAL_LIGHTER_COLOR)
            }
            SPACE

            Button {
                withAnimation {
                    save()
                    present.wrappedValue.dismiss()
                }
            } label: {
                Text(preference.language("save"))
                    .foregroundColor(preference.theme)
                    .font(.system(size: DEFINE_FONT_SMALL_SIZE))
                    .frame(width: SHEET_BUTTON_WIDTH, alignment: .trailing)
            }
        }
        .padding(.horizontal)
        .frame(height: SHEET_HEADER_HEIGHT)
        .background(NORMAL_BG_CARD_COLOR)
    }

    func save() {
        callback(value)
    }

    enum FocusField: Hashable {
        case field
    }

    @FocusState var focusedfield: FocusField?

    var inputfield: some View {
        switch textfield {
        case .text:
            return AnyView(
                TextField(hint ?? "", text: $value).keyboardType(.default)
                    .submitLabel(.done)
            )
        case .phone:
            return AnyView(
                iPhoneNumberField(text: $value)
                    .font(UIFont(size: 16, weight: .light, design: .monospaced))
            )
        case .number:
            return AnyView(
                TextField("", text: $value)
                    .keyboardType(.numberPad)
                    .submitLabel(.done)
            )
        }
    }

    var inputtab: some View {
        HStack {
            inputfield
                .foregroundColor(NORMAL_COLOR)
                .focused($focusedfield, equals: .field)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.focusedfield = .field
                    }
                }

            SPACE

            if textfield != .phone {
                Button {
                    value = ""
                } label: {
                    Image(systemName: "multiply.circle.fill")
                        .foregroundColor(Color(.systemGray4))
                }
            }
        }
        .padding(.horizontal)
        .frame(height: LIST_ITEM_HEIGHT)
        .background(NORMAL_BG_CARD_COLOR)
    }

    var body: some View {
        ZStack {
            NORMAL_BG_COLOR.edgesIgnoringSafeArea(.bottom)

            VStack {
                uptabview

                inputtab

                SPACE
            }
            .font(.system(size: DEFINE_FONT_SMALL_SIZE))
        }
    }
}
