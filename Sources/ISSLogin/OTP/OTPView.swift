//
//  File.swift
//  
//
//  Created by Wing Seng Chew on 12/09/2023.
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
//    @State private var countdown = 180 // 3 minutes in seconds
//    private var timer: AnyCancellable?
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
//    @State private var timer: AnyCancellable?

    // MARK: Injection

    @Environment(\.presentationMode) var presentationMode

    init(presenter: OTPPresenter) {
        self.presenter = presenter
    }

    //MARK -> BODY
    public var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: .zero) {
                ISSNavigationBarSUI(data: navigationBarData)

                VStack(spacing: 16) {
//                    Text("Verify your Email Address")
//                        .fontWithLineHeight(font: Theme.current.subtitle2.uiFont,
//                                            lineHeight: Theme.current.subtitle2.lineHeight,
//                                            verticalPadding: 0)
                    Text("Please enter OTP code sent to +60")
                        .fontWithLineHeight(font: Theme.current.bodyTwoMedium.uiFont,
                                            lineHeight: Theme.current.bodyTwoMedium.lineHeight,
                                            verticalPadding: 0)
                    HStack(spacing: 0) {
                        Spacer()

                        if #available(iOS 16.0, *) {
                            TextField("", text: $pinText)
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
                                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                    }
                                })
                                .frame(width: 204, height: 32)
                                .keyboardType(.numberPad)
                                .accentColor(Color.black)
                                .multilineTextAlignment(.center)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Theme.current.issBlack.color.opacity(0.5), lineWidth: 2)
                                )
                        } else {
                            OTPTextField(otp: $pinText, maxLength: 6, symbolWidth: 26, font: Theme.current.headline4.uiFont)
//                                .padding(.leading, 30)
                                .lineLimit(1)
                                .background(Theme.current.backgroundGray.color)
                                .textContentType(.oneTimeCode)
                                .onChange(of: pinText, perform: {
                                    pinText = String($0.prefix(6))
                                    if pinText.count == 6 {
                                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                    }
                                })
                                .frame(width: 200, height: 28)
                                .keyboardType(.numberPad)
                                .accentColor(Color.black)
//                                .multilineTextAlignment(.center)
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

                Spacer()
            }
            .padding(.horizontal)
        }
//        .onAppear {
//            startCountdownTimer()
//        }
        .onReceive(timer) { _ in
            if presenter.remainingTimeInSeconds > 0 {
                presenter.remainingTimeInSeconds -= 1
            }
            else {
//                presenter.remainingTimeInSeconds = 0
//                presenter.showTimeOutAlert()
                isButtonEnabled = true
//                timer.upstream.connect().cancel()
            }
        }
        .onDisappear {
            timer.upstream.connect().cancel()
        }
    }

//    private func startCountdownTimer() {
//        timer = Timer
//            .publish(every: 1, on: .main, in: .common)
//            .autoconnect()
//            .sink { [weak self] _ in
//                guard let self = self else { return }
//
//                if self.countdown > 0 {
//                    self.countdown -= 1
//                } else {
//                    self.isButtonEnabled = true
//                    self.timer?.cancel()
//                }
//            }
//    }

    private func resetTimer() {
        presenter.remainingTimeInSeconds = 10 // Reset the countdown to 3 minutes
        isButtonEnabled = false // Disable the button
//        startCountdownTimer() // Start the timer again
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
            .includeStatusBarArea(false)
            .build()
        return issNavBarData
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
            let symbolWidth = parent.symbolWidth
            let font = parent.font

            if string == "" {
                return true
            }

            if textField.text!.count + string.count - range.length > maxLength {
                return false
            }

            let currentText = NSMutableAttributedString(attributedString: NSAttributedString(string: textField.text ?? ""))
            currentText.deleteCharacters(in: range)
            var newStringLength = 0

            for char in string {
                let newSymbol = NSMutableAttributedString(string: String(char))
                newSymbol.addAttribute(.font, value: font, range: NSMakeRange(0, 1))
                let currentSymbolWidth = newSymbol.size().width
                let kern = symbolWidth - currentSymbolWidth
                newSymbol.addAttribute(.kern, value: kern, range: NSMakeRange(0, 1))

                currentText.insert(newSymbol, at: range.location + newStringLength)
                newStringLength += 1
            }

            if currentText.length == maxLength {
                currentText.addAttribute(.kern, value: 0, range: NSMakeRange(maxLength - 1, 1))
            }

            textField.attributedText = currentText
            parent.otp = currentText.string

            return false
        }
    }
}

