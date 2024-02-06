//
//  HighlightTextField.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/8/13.
//

import Combine
import Foundation
import SwiftUI

struct HighlightTextField: UIViewRepresentable {
    private let title: String?
    @Binding var text: String

    let onEditingChanged: (Bool) -> Void
    let onCommit: () -> Void

    let textField = PUITextField() //UITextField()

    init(title: String? = nil,
         text: Binding<String>,
         keyboardtype: UIKeyboardType,
         fontsize: CGFloat,
         onEditingChanged: @escaping (Bool) -> Void = { _ in }, onCommit: @escaping () -> Void = {}) {
        self.title = title
        _text = text

        self.onEditingChanged = onEditingChanged
        self.onCommit = onCommit

        textField.keyboardType = keyboardtype
        textField.textAlignment = .center
        textField.textColor = UIColor(NORMAL_LIGHTER_COLOR)
        textField.font = UIFont.systemFont(ofSize: fontsize)
    }

    func makeCoordinator() -> _TextFieldCoordinator {
        _TextFieldCoordinator(self)
    }

    func makeUIView(context: Context) -> UITextField {
        textField.placeholder = title
        textField.delegate = context.coordinator
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        textField.text = text
    }
}

final class _TextFieldCoordinator: NSObject, UITextFieldDelegate {
    var control: HighlightTextField

    init(_ control: HighlightTextField) {
        self.control = control
        super.init()

        control.textField.addTarget(self, action: #selector(textFieldEditingDidBegin(_:)), for: .editingDidBegin)
        control.textField.addTarget(self, action: #selector(textFieldEditingDidEnd(_:)), for: .editingDidEnd)
        control.textField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        control.textField.addTarget(self, action: #selector(textFieldEditingDidEndOnExit(_:)), for: .editingDidEndOnExit)
    }

    @objc private func textFieldEditingDidBegin(_ textField: UITextField) {
        textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)
        control.onEditingChanged(true)
    }

    @objc private func textFieldEditingDidEnd(_ textField: UITextField) {
        control.onEditingChanged(false)
    }

    @objc private func textFieldEditingChanged(_ textField: UITextField) {
        control.text = textField.text ?? ""
    }

    @objc private func textFieldEditingDidEndOnExit(_ textField: UITextField) {
        control.onCommit()
    }
}

/*

 struct HighlightTextField: UIViewRepresentable {
     @Binding var text: String
     var keyboardtype: UIKeyboardType
     var fontsize: CGFloat
     var onEditingChanged: (Bool) -> Void

     func makeUIView(context: Context) -> UITextField {
         let textField = UITextField() // PUITextField()
         textField.keyboardType = keyboardtype
         textField.delegate = context.coordinator
         textField.textAlignment = .center
         textField.textColor = UIColor(NORMAL_LIGHTER_COLOR)
         textField.font = UIFont.systemFont(ofSize: fontsize)

         return textField
     }

     func updateUIView(_ textField: UITextField, context: Context) {
         textField.text = text
     }

     func makeCoordinator() -> Coordinator {
         Coordinator(parent: self, onEditingChanged: onEditingChanged)
     }

     class Coordinator: NSObject, UITextFieldDelegate {
         var parent: HighlightTextField
         var onEditingChanged: (Bool) -> Void

         init(parent: HighlightTextField, onEditingChanged: @escaping (Bool) -> Void) {
             self.parent = parent
             self.onEditingChanged = onEditingChanged
         }

         func textFieldDidBeginEditing(_ textField: UITextField) {
             textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)
             // textField.selectAll(nil)
         }

         /*

          func textFieldDidEndEditing(_ textField: UITextField) {
              let t1 = textField.text ?? ""
              let t2 = parent.text

              parent.text = textField.text ?? ""
              onEditingChanged(true)
          }
          */

     }
 }
 */

 class PUITextField: UITextField {
     override open func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
         if isFirstResponder {
             if action != #selector(UIResponder.resignFirstResponder) {
                 DispatchQueue.main.async {
                     UIMenuController.shared.hideMenu()
                 }
                 return false
             }
         }

         return super.canPerformAction(action, withSender: sender)
     }
 }

