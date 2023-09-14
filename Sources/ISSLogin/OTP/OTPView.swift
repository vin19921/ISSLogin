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

public struct OTPView: View {

    @ObservedObject private var presenter: OTPPresenter

    @State private var pin: [String] = Array(repeating: "", count: 6)
    @State private var pinText = ""
    @State private var isButtonEnabled = false
    @State private var countdown = 180 // 3 minutes in seconds
//    private var timer: AnyCancellable?
//    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var timer: AnyCancellable?

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
                                .frame(width: 180)
                                .keyboardType(.numberPad)
                                .accentColor(Color.black)
                                .multilineTextAlignment(.center)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Theme.current.issBlack.color.opacity(0.5), lineWidth: 2)
                                )
                        } else {
                            // Fallback on earlier versions
                        }
                        Spacer()
                    }
                    .padding()

                    Button(action: {
                        print("resend btn")
                        resetTimer()
                    }) {
                        Text(isButtonEnabled ? "Resend" : "Can resend in \(countdown)")
                    }
                    .fontWithLineHeight(font: Theme.current.bodyTwoMedium.uiFont,
                                        lineHeight: Theme.current.bodyTwoMedium.lineHeight,
                                        verticalPadding: 8)
                    .frame(maxWidth: .infinity)
                    .disabled(!isButtonEnabled)
                    .foregroundColor(!isButtonEnabled ? Theme.current.disabledGray1.color : Theme.current.issWhite.color)
                    .background(!isButtonEnabled ? Theme.current.grayDisabled.color : Theme.current.issBlack.color)
                    .cornerRadius(12)
                }

                Spacer()
            }
            .padding(.horizontal)
        }
        .onAppear {
            startCountdownTimer()
        }
//        .onReceive(timer) { _ in
//            if presenter.remainingTimeInSeconds > 0 {
//                presenter.remainingTimeInSeconds -= 1
//            }
//            else {
////                presenter.remainingTimeInSeconds = 0
////                presenter.showTimeOutAlert()
//                isButtonEnabled = true
//                timer.upstream.connect().cancel()
//            }
//        }
    }

    private func startCountdownTimer() {
        timer = Timer
            .publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }

                if self.countdown > 0 {
                    self.countdown -= 1
                } else {
                    self.isButtonEnabled = true
                    self.timer?.cancel()
                }
            }
    }

    private func resetTimer() {
        presenter.remainingTimeInSeconds = 10 // Reset the countdown to 3 minutes
        isButtonEnabled = false // Disable the button
        startCountdownTimer() // Start the timer again
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


//import SwiftUI
//
//enum PinFocusState {
//    case pinOne, pinTwo, pinThree, pinFour
//}
//
//public struct OTPView: View {
//
//    @ObservedObject private var presenter: OTPPresenter
//
//    // MARK: Injection
//
//    @Environment(\.presentationMode) var presentationMode
//
//    init(presenter: OTPPresenter) {
//        self.presenter = presenter
//    }
//
//    @State private var pinOne: String = ""
//    @State private var pinTwo: String = ""
//    @State private var pinThree: String = ""
//    @State private var pinFour: String = ""
//    @State private var pinFocusState: PinFocusState = .pinOne
//
//    public var body: some View {
//        VStack {
//            Text("Verify your Email Address")
//                .font(.title2)
//                .fontWeight(.semibold)
//
//            Text("Enter 4 digit code we'll text you on Email")
//                .font(.caption)
//                .fontWeight(.thin)
//                .padding(.top)
//
//            HStack(spacing: 15) {
//                PinTextField(text: $pinOne, focusState: $pinFocusState, nextFocusState: .pinTwo)
//                PinTextField(text: $pinTwo, focusState: $pinFocusState, nextFocusState: .pinThree)
//                PinTextField(text: $pinThree, focusState: $pinFocusState, nextFocusState: .pinFour)
//                PinTextField(text: $pinFour, focusState: $pinFocusState, nextFocusState: nil)
//            }
//            .padding(.vertical)
//
//            Button(action: {
//                print("\(pinOne)\(pinTwo)\(pinThree)\(pinFour)")
//            }, label: {
//                Spacer()
//                Text("Verify")
//                    .font(.system(.title3, design: .rounded))
//                    .fontWeight(.semibold)
//                    .foregroundColor(.white)
//                Spacer()
//            })
//            .padding(15)
//            .background(Color.blue)
//            .clipShape(Capsule())
//            .padding()
//        }
//    }
//}
//
//struct PinTextField: View {
//    @Binding var text: String
//    @Binding var focusState: PinFocusState
//    var nextFocusState: PinFocusState?
//
//    var body: some View {
//        TextField("", text: $text)
//            .frame(width: 45, height: 45)
//            .font(.largeTitle)
//            .textFieldStyle(RoundedBorderTextFieldStyle())
//            .multilineTextAlignment(.center)
//            .keyboardType(.numberPad)
//            .textContentType = .oneTimeCode
//            .onChange(of: text) { newValue in
//                if newValue.count == 1, let nextFocusState = nextFocusState {
//                    focusState = nextFocusState
//                } else if newValue.isEmpty, let previousFocusState = previousFocusState() {
//                    focusState = previousFocusState
//                }
//            }
//    }
//
//    func previousFocusState() -> PinFocusState? {
//        switch focusState {
//        case .pinTwo:
//            return .pinOne
//        case .pinThree:
//            return .pinTwo
//        case .pinFour:
//            return .pinThree
//        default:
//            return nil
//        }
//    }
//}
