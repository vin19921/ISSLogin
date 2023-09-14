//
//  File.swift
//  
//
//  Created by Wing Seng Chew on 12/09/2023.
//

import ISSCommonUI
import ISSTheme
import SwiftUI
import Combine

public struct OTPView: View {

    @ObservedObject private var presenter: OTPPresenter

    @State private var pin: [String] = Array(repeating: "", count: 4)
    @State private var isFirstResponder: [Bool] = Array(repeating: false, count: 4)
    @State private var pinText = ""

    // MARK: Injection

    @Environment(\.presentationMode) var presentationMode

    init(presenter: OTPPresenter) {
        self.presenter = presenter
    }

    //MARK -> PROPERTIES

//    enum FocusPin {
//        case  pinOne, pinTwo, pinThree, pinFour
//    }

//    @FocusState private var pinFocusState : FocusPin?
//    @State var pinOne: String = ""
//    @State var pinTwo: String = ""
//    @State var pinThree: String = ""
//    @State var pinFour: String = ""

    //MARK -> BODY
    public var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: .zero) {
                ISSNavigationBarSUI(data: navigationBarData)

                VStack(spacing: 16) {
                    Text("Verify your Email Address")
                        .fontWithLineHeight(font: Theme.current.subtitle2.uiFont,
                                            lineHeight: Theme.current.subtitle2.lineHeight,
                                            verticalPadding: 0)
                    Text("Enter 4 digit code we'll text you on Email")
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
                                    pinText = String($0.prefix(4))
                                    if pinText.count == 4 {
                                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                    }
                                })
                                .frame(width: 140)
                                .keyboardType(.numberPad)
                                .accentColor(Color.black)
                                .multilineTextAlignment(.center)
                        } else {
                            // Fallback on earlier versions
                        }
                        Spacer()
                    }
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Theme.current.issBlack.color.opacity(0.5), lineWidth: 2)
                    )
                }

                Spacer()
            }
        }
        
//        .onAppear {
//            DispatchQueue.main.async {
//                isFirstResponder[0] = true
//            }
//        }
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
