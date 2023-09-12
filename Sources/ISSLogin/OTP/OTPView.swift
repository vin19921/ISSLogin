//
//  File.swift
//  
//
//  Created by Wing Seng Chew on 12/09/2023.
//

import ISSTheme
import SwiftUI

public struct OTPView: View {
    @ObservedObject private var presenter: OTPPresenter
    
    @State private var emailText = ""
    @State private var passwordText = ""

    // MARK: Injection

    @Environment(\.presentationMode) var presentationMode

    init(presenter: OTPPresenter) {
        self.presenter = presenter
    }

    @State private var otp: String = ""
    
    public var body: some View {
        VStack {
            Text("Enter OTP")
                .font(.largeTitle)
                .padding()
            
            HStack(spacing: 20) {
                ForEach(0..<6, id: \.self) { index in
                    OTPDigitTextField(value: digitAtIndex(index), isLastField: index == 5) {
                        if index < 5 {
                            let nextIndex = otp.index(otp.startIndex, offsetBy: index + 1)
                            let nextDigit = String(otp[nextIndex])
                            if nextDigit.isEmpty {
                                // Set focus to the next digit field
                                otp.replaceSubrange(nextIndex...nextIndex, with: "0") // Place a placeholder digit
                            }
                        }
                    }
                }
            }
            .padding()
            
            Button(action: {
                // Implement OTP verification logic here
                // You can compare the entered OTP (otp) with the expected OTP
                // and display an alert or navigate to the next screen based on the result
                print("Entered OTP: \(otp)")
            }) {
                Text("Verify OTP")
                    .font(.headline)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            
            Spacer()
        }
        .background(Theme.current.grayDisabled.color)
    }
    
    func digitAtIndex(_ index: Int) -> Binding<String> {
        return Binding<String>(
            get: {
                if index < otp.count {
                    let currentIndex = otp.index(otp.startIndex, offsetBy: index)
                    return String(otp[currentIndex])
                } else {
                    return ""
                }
            },
            set: { newValue in
                if newValue.count > 0 {
                    if index < otp.count {
                        let currentIndex = otp.index(otp.startIndex, offsetBy: index)
                        otp.replaceSubrange(currentIndex...currentIndex, with: newValue)
                        if index < 5 {
                            let nextIndex = otp.index(otp.startIndex, offsetBy: index + 1)
                            DispatchQueue.main.async {
                                UIApplication.shared.sendAction(#selector(UIResponder.becomeFirstResponder), to: nil, from: nil, for: nil)
                            }
                        }
                    }
                }
            }
        )
    }
}

struct OTPDigitTextField: View {
    @Binding var value: String
    var isLastField: Bool = false
    var nextResponder: (() -> Void)? = nil
    
    var body: some View {
        TextField("", text: $value)
            .frame(width: 40, height: 40)
            .font(.largeTitle)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .multilineTextAlignment(.center)
            .keyboardType(.numberPad)
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { _ in
                if self.isLastField {
                    self.nextResponder?()
                }
            }
    }
}
