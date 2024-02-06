//
//  Textinputfield.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/2/21.
//

import iPhoneNumberField
import SwiftUI

struct Textinputfield_Previews: PreviewProvider {
    static var previews: some View {
        Textinputfield(textfield: .phone,
                       value: .constant(""),
                       label: "输入手机号码")

        Textinputfield(value: .constant(""), label: "输入昵称")
    }
}

extension String {
    var isPhoneNumber: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSRange(location: 0, length: count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == count
            } else {
                return false
            }
        } catch {
            return false
        }
    }
}

struct Textinputfield: View {
    var textfield: textfield = .text
    @Binding var value: String
    var label: String

    var inputfield: some View {
        switch textfield {
        case .text:
            return AnyView(
                TextField(label, text: $value)
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
                TextField(label, text: $value)
                    .keyboardType(.numberPad)
                    .submitLabel(.done)
            )
        }
    }

    var body: some View {
        HStack {
            inputfield
                .foregroundColor(NORMAL_COLOR)

            Spacer()
        }
        .padding(.horizontal)
        .frame(height: MIN_UP_TAB_HEIGHT - 5)
        .background(
            NORMAL_BG_CARD_COLOR
        )
    }
}
