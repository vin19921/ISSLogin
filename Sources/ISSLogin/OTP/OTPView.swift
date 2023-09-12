//
//  File.swift
//  
//
//  Created by Wing Seng Chew on 12/09/2023.
//

import ISSTheme
import SwiftUI
import Combine

public struct OTPView: View {

    @ObservedObject private var presenter: OTPPresenter

    @State private var pin: [String] = Array(repeating: "", count: 4)
    @State private var isFirstResponder: [Bool] = [true, false, false, false]

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
        VStack(spacing: 16) {

            Text("Verify your Email Address")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.top)


            Text("Enter 4 digit code we'll text you on Email")
                .font(.caption)
                .fontWeight(.thin)
                .padding(.top)

            HStack(spacing:15, content: {
                
                ForEach(0..<4, id: \.self) { index in
                    CustomTextField(text: $pin[index],
                                    isFirstResponder: $isFirstResponder[index],
                                    font: Theme.current.bodyTwoMedium.uiFont,
                                    keyboardType: .numberPad,
                                    maxLength: 1,
                                    toolbarButtonTitle: "",
                                    textFieldDidChange: {
                                        print("\(pin[index])")
                                        isFirstResponder[index] = false
                                        if index < pin.count-1 {
                                            isFirstResponder[index+1] = true
                                        }
                                        print("\(isFirstResponder)")
                                    }
//                                    ,
//                                    onTapGesture: {
//                                        print("on Tap \(index)")
//                                        for i in 0..<isFirstResponder.count {
//                                            isFirstResponder[i] = false
//                                        }
//                                        isFirstResponder[index] = true
//                                    }
                    )
//                    .frame(width: 36, height: 36)
                    .padding()
                    .background(Theme.current.issWhite.color)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .accentColor(Color.red) // Set the accent color for the text field
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Theme.current.issBlack.color.opacity(0.5), lineWidth: 2)
                    )
                }
                
                Text("Generate 1234")
                    .foregroundColor(Color.blue)
                    .onTapGesture {
                        let inputString = "1234"
                        for (index, character) in inputString.enumerated() {
                            print("Character at index \(index): \(character)")
                            pin[index] = character
                        }
                    }
                    
//                TextField("", text: $pinOne)
//                    .modifier(OtpModifer(pin:$pinOne))
//                    .onChange(of:pinOne){newVal in
//                        if (newVal.count == 1) {
//                            self.resignFirstResponder()
//                        }
//                    }
////                    .focused($pinFocusState, equals: .pinOne)
//
//                TextField("", text:  $pinTwo)
//                    .modifier(OtpModifer(pin:$pinTwo))
////                    .onChange(of:pinTwo){newVal in
////                        if (newVal.count == 1) {
////                            pinFocusState = .pinThree
////                        }else {
////                            if (newVal.count == 0) {
////                                pinFocusState = .pinOne
////                            }
////                        }
////                    }
////                    .focused($pinFocusState, equals: .pinTwo)
//
//
//                TextField("", text:$pinThree)
//                    .modifier(OtpModifer(pin:$pinThree))
////                    .onChange(of:pinThree){newVal in
////                        if (newVal.count == 1) {
////                            pinFocusState = .pinFour
////                        }else {
////                            if (newVal.count == 0) {
////                                pinFocusState = .pinTwo
////                            }
////                        }
////                    }
////                    .focused($pinFocusState, equals: .pinThree)
//
//
//                TextField("", text:$pinFour)
//                    .modifier(OtpModifer(pin:$pinFour))
////                    .onChange(of:pinFour){newVal in
////                        if (newVal.count == 0) {
////                            pinFocusState = .pinThree
////                        }
////                    }
////                    .focused($pinFocusState, equals: .pinFour)
                
                
            })
            .padding(.vertical)

            Spacer()

//            Button(action: {
//                print("Verify btn")
//            }) {
//                Text("Verify")
//                    .fontWithLineHeight(font: Theme.current.bodyTwoMedium.uiFont,
//                                        lineHeight: Theme.current.bodyTwoMedium.lineHeight,
//                                        verticalPadding: 8)
//                    .foregroundColor(.white)
//                    .frame(maxWidth: .infinity) // Expands the button to full screen width
//                    .background(Color.black)
//                    .cornerRadius(12)
//            }
//            .padding()
        }
        .background(Theme.current.grayDisabled.color)
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
