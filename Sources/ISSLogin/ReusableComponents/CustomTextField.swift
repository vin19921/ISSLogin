//
//  File.swift
//  
//
//  Created by Wing Seng Chew on 12/09/2023.
//

import SwiftUI

struct CustomTextField: UIViewRepresentable {
    @Binding var text: String
    @Binding var isFirstResponder: Bool

    var font: UIFont?
    var keyboardType: UIKeyboardType = .default
    var maxLength: Int?
    var toolbarButtonTitle: String
    var toolbarAction: ((ToolbarAction) -> Void)?
    var textFieldDidChange: () -> Void = {}
    var onTapGesture: (() -> Void)?
    var placeholder: String? // Placeholder property
    var placeholderImage: UIImage? // Placeholder image
    var textFieldDidReturn: () -> Void = {}


    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        textField.font = font
        textField.keyboardType = keyboardType
        textField.delegate = context.coordinator
        textField.attributedPlaceholder = createPlaceholder() // Set the attributed placeholder
        // Add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.textFieldTapped))
        textField.addGestureRecognizer(tapGesture)
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        if isFirstResponder {
            DispatchQueue.main.async {
                uiView.becomeFirstResponder() // Show the keyboard if isFirstResponder is true
            }
        } else {
            DispatchQueue.main.async {
                uiView.resignFirstResponder() // Dismiss the keyboard if isFirstResponder is false
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self,
                    textFieldDidChange: {
                        self.textFieldDidChange()
                    },
                    textFieldDidReturn: {
                        self.textFieldDidReturn()
                    })
    }

    private func createPlaceholder() -> NSAttributedString {
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.gray,
            .font: font ?? UIFont.systemFont(ofSize: 14)
        ]
        
        let placeholderAttachment = NSTextAttachment()
        placeholderAttachment.image = placeholderImage?.withRenderingMode(.alwaysTemplate)
        placeholderAttachment.bounds = CGRect(x: 0, y: -2, width: 16, height: 16) // Adjust the image position as needed
        
        let placeholderString = NSMutableAttributedString()
        placeholderString.append(NSAttributedString(attachment: placeholderAttachment))
        placeholderString.append(NSAttributedString(string: "  "))
        placeholderString.append(NSAttributedString(string: placeholder ?? "", attributes: placeholderAttributes))

        placeholderString.addAttribute(.foregroundColor, value: UIColor.gray, range: NSRange(location: 0, length: 1))
        
        return placeholderString
    }
}

// MARK: - Coordinator

extension CustomTextField {
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: CustomTextField
        var textFieldDidChange: () -> Void
        var textFieldDidReturn: () -> Void

        init(parent: CustomTextField,
             textFieldDidChange: @escaping () -> Void,
             textFieldDidReturn: @escaping () -> Void)
        {
            self.parent = parent
            self.textFieldDidChange = textFieldDidChange
            self.textFieldDidReturn = textFieldDidReturn
        }

        // Became first responder
        func textFieldDidBeginEditing(_: UITextField) {
            print("textFieldDidBeginEditing")
            DispatchQueue.main.async {
                self.parent.isFirstResponder = true
            }
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            parent.text = textField.text ?? ""
            textFieldDidChange()
        }

        // Resign first responder
        func textFieldDidEndEditing(_: UITextField) {
            DispatchQueue.main.async {
                self.parent.isFirstResponder = false
            }
        }

        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            print("keyboard return")
            textFieldDidReturn()
            textField.resignFirstResponder()
            return true
        }

        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            guard let maxLength = parent.maxLength else {
                return true
            }
            let currentString = (textField.text ?? "") as NSString
            let newString = currentString.replacingCharacters(in: range, with: string)
            return newString.count <= maxLength
        }

        @objc func textFieldTapped() {
            parent.onTapGesture?()
        }
    }
}

// MARK: - Private

extension CustomTextField {
    func addToolbar(_ textField: UITextField) {
        let numberToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: Constant.toolbarHeight))
        numberToolbar.barStyle = .default
        numberToolbar.items = [UIBarButtonItem(image: UIImage(systemName: Constant.arrowUpImage),
                                               primaryAction: UIAction { _ in
                                                   toolbarAction?(.up)
                                               }),
                               UIBarButtonItem(image: UIImage(systemName: Constant.arrowDownImage),
                                               primaryAction: UIAction { _ in
                                                   toolbarAction?(.down)
                                               }),
                               UIBarButtonItem(systemItem: .flexibleSpace),
                               UIBarButtonItem(title: toolbarButtonTitle,
                                               primaryAction: UIAction { _ in
                                                   textField.resignFirstResponder()
                                                   toolbarAction?(.done)
                                               })]
        numberToolbar.sizeToFit()
        textField.inputAccessoryView = numberToolbar
    }
}

// MARK: - Nested type

extension CustomTextField {
    enum Constant {
        static let toolbarHeight: CGFloat = 50
        static let arrowUpImage = "chevron.up"
        static let arrowDownImage = "chevron.down"
    }
}

enum ToolbarAction {
    case done, up, down
}

