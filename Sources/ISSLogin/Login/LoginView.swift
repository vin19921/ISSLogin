//
//  File.swift
//  
//
//  Created by Wing Seng Chew on 07/09/2023.
//

import ISSTheme
import SwiftUI

public struct LoginView: View {

    @ObservedObject private var presenter: LoginPresenter
    
    @State private var emailText = ""
    @State private var passwordText = ""

    // MARK: Injection

    @Environment(\.presentationMode) var presentationMode

    init(presenter: LoginPresenter) {
        self.presenter = presenter
    }

    // MARK: View

    public var body: some View {
        ZStack {
            VStack(spacing: 16) {
                HStack {
                    Spacer()
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 36, height: 36)
                        .aspectRatio(contentMode: .fill)
                        .foregroundColor(Color.black)
                        .onTapGesture {
                            presentationMode.wrappedValue.dismiss()
                        }
                }
                Spacer()
                TextField("Email", text: $emailText)
                TextField("Password", text: $passwordText)
                Spacer()
            }
        }
    }
}
