//
//  File.swift
//  
//
//  Created by Wing Seng Chew on 12/10/2023.
//

import FirebaseAuth
import Firebase
import GoogleSignIn
import SwiftUI
import ISSTheme

struct GoogleLoginButtonView: View {
//    @State private var isLoggedIn = false
//    @AppStorage("uid") var uid: String?
    @StateObject var presenter: LoginPresenter
    @Binding var isLoggedIn: Bool

    var body: some View {
        VStack {
            if isLoggedIn {
                Text("Logout")
                    .onTapGesture {
                        presenter.signOut()
                    }
            } else {
                Button(action: {
                    // Trigger the Facebook login
                    presenter.signIn()
                }) {
                    HStack {
                        Spacer()
                        LoginImageAssets.facebook.image
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 20, height: 20)
                            .aspectRatio(contentMode: .fit)
                        Text("Sign Up with Google")
                            .fontWithLineHeight(font: Theme.current.bodyTwoMedium.uiFont,
                                                lineHeight: Theme.current.bodyTwoMedium.lineHeight,
                                                verticalPadding: 8)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundColor(Theme.current.issWhite.color)
                    .background(Color.blue)
                    .cornerRadius(12)
                }
//                .facebookLoginButtonStyle() // Apply custom button style
            }
        }
    }
}

