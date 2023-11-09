//
//  File.swift
//  
//
//  Created by Wing Seng Chew on 09/11/2023.
//

import SwiftUI
import ISSTheme

struct AppleLoginButtonView: View {
    @Binding var isLoggedIn: Bool
    let action: ((String, String) -> Void)?

    var body: some View {
        VStack {
            Button(action: {

            }) {
                HStack {
                    Spacer()
                    Image(systemName: "apple.logo")
                        .renderingMode(.template)
                        .frame(width: 20, height: 20)
                        .aspectRatio(contentMode: .fit)
                    Text("Sign Up with Apple")
                        .fontWithLineHeight(font: Theme.current.bodyTwoMedium.uiFont,
                                            lineHeight: Theme.current.bodyTwoMedium.lineHeight,
                                            verticalPadding: 8)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .foregroundColor(Theme.current.white.color)
                .background(Theme.current.black.color)
                .cornerRadius(12)
            }
        }
    }
}

