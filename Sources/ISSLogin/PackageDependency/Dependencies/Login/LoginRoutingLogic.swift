//
//  LoginRoutingLogic.swift
//
//
//  Copyright by iSoftStone 2024.
//

public protocol LoginRoutingLogic {
    func navigateToRootScreen()
    func navigateToRegisterScreen(fullName: String, email: String)
    func navigateToResetPasswordScreen()
}
