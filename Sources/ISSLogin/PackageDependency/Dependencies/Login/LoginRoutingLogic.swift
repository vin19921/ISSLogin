//
//  File.swift
//  
//
//  Created by Wing Seng Chew on 07/09/2023.
//

public protocol LoginRoutingLogic {
    func navigateToRootScreen()
    func navigateToRegisterScreen(fullName: String, email: String)
    func navigateToResetPasswordScreen()
}
