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

    @State private var emailText = ""
    @State private var passwordText = ""

    // MARK: Injection

    @Environment(\.presentationMode) var presentationMode

    init(presenter: OTPPresenter) {
        self.presenter = presenter
    }

    //MARK -> PROPERTIES

    enum FocusPin {
        case  pinOne, pinTwo, pinThree, pinFour
    }

    @FocusState private var pinFocusState : FocusPin?
    @State var pinOne: String = ""
    @State var pinTwo: String = ""
    @State var pinThree: String = ""
    @State var pinFour: String = ""

    //MARK -> BODY
    public var body: some View {
        VStack {

            Text("Verify your Email Address")
                .font(.title2)
                .fontWeight(.semibold)


            Text("Enter 4 digit code we'll text you on Email")
                .font(.caption)
                .fontWeight(.thin)
                .padding(.top)

            if #available(iOS 15.0, *) {
                HStack(spacing:15, content: {
                    
                    TextField("", text: $pinOne)
                        .modifier(OtpModifer(pin:$pinOne))
                        .onChange(of:pinOne){newVal in
                            if (newVal.count == 1) {
                                pinFocusState = .pinTwo
                            }
                        }
                        .focused($pinFocusState, equals: .pinOne)
                    
                    TextField("", text:  $pinTwo)
                        .modifier(OtpModifer(pin:$pinTwo))
                        .onChange(of:pinTwo){newVal in
                            if (newVal.count == 1) {
                                pinFocusState = .pinThree
                            }else {
                                if (newVal.count == 0) {
                                    pinFocusState = .pinOne
                                }
                            }
                        }
                        .focused($pinFocusState, equals: .pinTwo)
                    
                    
                    TextField("", text:$pinThree)
                        .modifier(OtpModifer(pin:$pinThree))
                        .onChange(of:pinThree){newVal in
                            if (newVal.count == 1) {
                                pinFocusState = .pinFour
                            }else {
                                if (newVal.count == 0) {
                                    pinFocusState = .pinTwo
                                }
                            }
                        }
                        .focused($pinFocusState, equals: .pinThree)
                    
                    
                    TextField("", text:$pinFour)
                        .modifier(OtpModifer(pin:$pinFour))
                        .onChange(of:pinFour){newVal in
                            if (newVal.count == 0) {
                                pinFocusState = .pinThree
                            }
                        }
                        .focused($pinFocusState, equals: .pinFour)
                    
                    
                })
                .padding(.vertical)
            }

            Button(action: {
                print("\(pinOne)\(pinTwo)\(pinThree)\(pinFour)")
            }, label: {
                Spacer()
                Text("Veify")
                    .font(.system(.title3, design: .rounded))
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                Spacer()
            })
            .padding(15)
            .background(Color.blue)
            .clipShape(Capsule())
            .padding()
        }
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
                    .stroke(Color("blueColor"), lineWidth: 2)
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
