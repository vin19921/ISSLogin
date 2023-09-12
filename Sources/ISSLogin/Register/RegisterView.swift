//
//  File.swift
//  
//
//  Created by Wing Seng Chew on 12/09/2023.
//

import ISSTheme
import SwiftUI

public struct RegisterView: View {

//    @ObservedObject private var presenter: LoginPresenter
    
    @State private var fullNameText = ""
    @State private var passwordText = ""

    // MARK: Injection

    @Environment(\.presentationMode) var presentationMode

//    init(presenter: LoginPresenter) {
//        self.presenter = presenter
//    }

    // MARK: View

    public var body: some View {
        ZStack {
            VStack(spacing: 16) {
                HStack {
                    Spacer()
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .aspectRatio(contentMode: .fill)
                        .foregroundColor(Color.black)
                        .onTapGesture {
                            presentationMode.wrappedValue.dismiss()
                        }
                        .padding()
                }
                ZStack {
                    HStack {
                        TextField("Full Name (as Per NRIC)", text: $fullNameText)
                    }
                    .frame(height: 32)
                    .padding(.horizontal)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Theme.current.issBlack.color.opacity(0.5), lineWidth: 2)
                    )
                }
            }
        }
    }
}
