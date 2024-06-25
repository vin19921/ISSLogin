//
//  OTPView.swift
//
//
//  Copyright by iSoftStone 2024.
//

import Combine
import ISSCommonUI
import ISSTheme
import SwiftUI
import UIKit

public struct OTPView: View {

    @ObservedObject private var presenter: OTPPresenter

    @State private var pin: [String] = Array(repeating: "", count: 6)
    @State private var pinText = ""
    @State private var isButtonEnabled = false
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var isLoading = false

    // MARK: Injection

    @Environment(\.presentationMode) var presentationMode

    init(presenter: OTPPresenter) {
        self.presenter = presenter
    }

    // MARK: Body

    public var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: .zero) {
                ISSNavigationBarSUI(data: navigationBarData)

                VStack(spacing: 16) {
                    Text("Please enter OTP code sent to +\(presenter.getMobileNo())")
                        .fontWithLineHeight(font: Theme.current.bodyTwoMedium.uiFont,
                                            lineHeight: Theme.current.bodyTwoMedium.lineHeight,
                                            verticalPadding: 0)
                    HStack(spacing: 0) {
                        Spacer()

                        if #available(iOS 16.0, *) {
                            TextField("", text: $pinText)
                                .padding(.vertical, 4)
                                .tracking(16)
                                .lineLimit(1)
                                .fontWithLineHeight(font: Theme.current.headline4.uiFont,
                                                    lineHeight: Theme.current.headline4.lineHeight,
                                                    verticalPadding: 0)
                                .background(Theme.current.backgroundGray.color)
                                .textContentType(.oneTimeCode)
                                .onChange(of: pinText, perform: {
                                    pinText = String($0.prefix(6))
                                    if pinText.count == 6 {
                                        isLoading.toggle()
                                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                        presenter.validateOTP(request: OTP.Model.Request(mobileNo: presenter.getMobileNo(),
                                                                                         code: Int(pinText),
                                                                                         otpAttemptCount: presenter.otpAttemptCount),
                                                              completionHandler: {
                                            isLoading.toggle()
                                        })
                                    }
                                })
                                .frame(width: 204)
                                .keyboardType(.numberPad)
                                .accentColor(Color.black)
                                .multilineTextAlignment(.center)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Theme.current.issBlack.color.opacity(0.5), lineWidth: 2)
                                )
                        } else {
                            KerningTextField(text: $pinText)
                                .padding(.vertical, 4)
                                .frame(width: 204, height: 32)
                                .keyboardType(.numberPad)
                                .accentColor(Color.black)
                                .onChange(of: pinText, perform: {
                                    pinText = String($0.prefix(6))
                                    if pinText.count == 6 {
                                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                    }
                                })
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Theme.current.issBlack.color.opacity(0.5), lineWidth: 2)
                                )
                        }
                        Spacer()
                    }
                    .padding()

                    Button(action: {
                        print("resend btn")
                        resetTimer()
                        presenter.fetchOTP(otpAction: presenter.getOTPAction(),
                                           request: OTP.Model.Request(mobileNo: presenter.getMobileNo(),
                                                                      otpAttemptCount: presenter.otpAttemptCount))
                    }) {
                        Text(isButtonEnabled ? "Resend" : "Can resend in \(presenter.getFormattedRemainingTime())")
                            .fontWithLineHeight(font: Theme.current.bodyTwoMedium.uiFont,
                                                lineHeight: Theme.current.bodyTwoMedium.lineHeight,
                                                verticalPadding: 8)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(!isButtonEnabled ? Theme.current.disabledGray1.color : Theme.current.issWhite.color)
                            .background(!isButtonEnabled ? Theme.current.grayDisabled.color : Theme.current.issBlack.color)
                            .cornerRadius(12)
                    }
                    .disabled(!isButtonEnabled)
                }
                .padding(.horizontal)

                Spacer()
            }
        }
        .onAppear {
            presenter.fetchOTP(otpAction: presenter.getOTPAction(),
                               request: OTP.Model.Request(mobileNo: presenter.getMobileNo(),
                                                          otpAttemptCount: presenter.otpAttemptCount))
        }
        .onReceive(timer) { _ in
            if presenter.remainingTimeInSeconds > 0 {
                presenter.remainingTimeInSeconds -= 1
            }
            else {
                isButtonEnabled = true
            }
        }
        .onDisappear {
            timer.upstream.connect().cancel()
        }
        .alert(isPresented: $presenter.showingAlert) {
            AlertSUI(alertInfo: presenter.alertInfo)
        }
        .loading(isLoading: $isLoading)
    }

    private func resetTimer() {
        presenter.remainingTimeInSeconds = 10 // Reset the countdown to 3 minutes
        isButtonEnabled = false // Disable the button
    }

    private var navigationBarData: ISSNavigationBarBuilder.ISSNavigationBarData {
        let leftAlignedItem = ToolBarItemDataBuilder()
            .setImage(Image(systemName: "chevron.backward"))
            .setCallback {
                self.presentationMode.wrappedValue.dismiss()
            }
            .build()
        let toolBarItems = ToolBarItemsDataBuilder()
            .setLeftAlignedItem(leftAlignedItem)
            .build()
        let issNavBarData = ISSNavigationBarBuilder()
            .setToolBarItems(toolBarItems)
            .setTintColor(Theme.current.issBlack.color)
            .includeStatusBarArea(true)
            .build()
        return issNavBarData
    }

    public func setMobileNo(_ mobileNo: String) {
        presenter.setMobileNo(mobileNo)
    }

    public func setOTPAction(_ otpAction: OTPAction) {
        presenter.setOTPAction(otpAction)
    }
}

struct OtpModifer: ViewModifier {

    @Binding var pin : String

    var textLimt = 1

    func limitText(_ upper : Int) {
        if pin.count > upper {
            self.pin = String(pin.prefix(upper))
        }
    }

    //MARK -> BODY
    func body(content: Content) -> some View {
        content
            .multilineTextAlignment(.center)
            .keyboardType(.numberPad)
            .onReceive(Just(pin)) {_ in limitText(textLimt)}
            .frame(width: 45, height: 45)
            .background(Color.white.cornerRadius(5))
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.blue, lineWidth: 2)
            )
    }
}

struct OTPTextField: UIViewRepresentable {
    @Binding var otp: String
    var maxLength: Int = 6
    var symbolWidth: CGFloat = 16
    var font: UIFont = .systemFont(ofSize: 30)

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.delegate = context.coordinator
        textField.font = font
        textField.textAlignment = .center
        textField.textContentType = .oneTimeCode
        textField.keyboardType = .numberPad
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = otp
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: OTPTextField

        init(_ parent: OTPTextField) {
            self.parent = parent
        }

        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            let maxLength = parent.maxLength

            // Calculate the new text after applying the user's input
            var currentText = textField.text ?? ""
            let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
            print("Updated Text: \(updatedText)")
            print("Max Length: \(maxLength)")

            // Check if the new length exceeds the maximum length
            if updatedText.count > maxLength {
                return false
            }

            // Apply kerning to all characters except the last one
            if updatedText.count > 0 {
                currentText = updatedText
                let kernValue: CGFloat = 5 // Adjust this value as needed
                let attributedText = addKerningExcludingLastCharacter(text: updatedText, kernValue: kernValue)
                textField.attributedText = attributedText
            }

            parent.otp = currentText

            return false
        }

        func addKerningExcludingLastCharacter(text: String, kernValue: CGFloat) -> NSAttributedString {
            let attributedText = NSMutableAttributedString(string: text)

            // Check if the text is not empty
            if text.count > 0 {
                // Apply kerning to all characters except the last one
                for i in 0..<text.count - 1 {
                    let range = NSRange(location: i, length: 1)
                    attributedText.addAttribute(NSAttributedString.Key.kern, value: kernValue, range: range)
                }
            }

            return attributedText
        }
    }
}

struct KerningTextField: UIViewRepresentable {
    @Binding var text: String
    let kernValue: CGFloat = 16.0
    let font: UIFont = Theme.current.headline4.uiFont

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.delegate = context.coordinator
        textField.font = font
        textField.textAlignment = .center
        textField.textContentType = .oneTimeCode
        textField.keyboardType = .numberPad

        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
        applyKerning(to: uiView)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: KerningTextField

        init(_ parent: KerningTextField) {
            self.parent = parent
        }

        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            parent.text = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
            return true
        }
    }

    private func applyKerning(to textField: UITextField) {
        if let text = textField.text, text.count > 0 {
           // Exclude the last character from kerning
           let textExcludingLastCharacter = String(text.dropLast())
           let attributedText = NSMutableAttributedString(string: textExcludingLastCharacter)
           attributedText.addAttribute(.kern, value: kernValue, range: NSRange(location: 0, length: attributedText.length))
           attributedText.append(NSAttributedString(string: String(text.last!)))
           textField.attributedText = attributedText
       }
    }
}
