//
//  File.swift
//  
//
//  Created by Wing Seng Chew on 07/09/2023.
//

import ISSNetwork
import ISSTheme
import Foundation

/// The ISSGateway facilitate creation of Login Screen with injection of dependencies from the app
/// This helps provide proper separation of concerns between app and events package.
public enum ISSGateway {
    public static func makeLogin(theme: Theme,
                                 provider: LoginDataProviderLogic,
                                 router: LoginRoutingLogic,
                                 networkMonitor: NetworkMonitor
    ) ->
    LoginView
    {
        /// Explicity setting the theme to register fonts and colors required by events package.
        Theme.current = theme
//        injectEventsOverviewProvider(provider)
//        injectEventsOverviewRouter(router)
//        injectNetworkMonitor(networkMonitor)
        
        let interactor = LoginInteractor(provider: provider)
        let presenter = LoginPresenter(interactor: interactor)
        
        let view = LoginView(presenter: presenter)
        let loginRouter = LoginRouter(navigator: router)
        
        presenter.setRouter(loginRouter)
        return view
    }

    public static func makeRegister(theme: Theme,
                                    provider: RegisterDataProviderLogic,
                                    router: RegisterRoutingLogic,
                                    networkMonitor: NetworkMonitor) -> RegisterView {
        /// Explicity setting the theme to register fonts and colors required by events package.
        Theme.current = theme
        
        let interactor = RegisterInteractor(provider: provider)
        let presenter = RegisterPresenter(interactor: interactor)
        
        let view = RegisterView(presenter: presenter)
        let registerRouter = RegisterRouter(navigator: router)
        
        presenter.setRouter(registerRouter)
        return view
    }

    public static func makeOTP(theme: Theme,
                               provider: OTPDataProviderLogic,
                               router: OTPRoutingLogic,
                               networkMonitor: NetworkMonitor) ->
    OTPView
    {
        Theme.current = theme
        let interactor = OTPInteractor(provider: provider)
        let presenter = OTPPresenter(interactor: interactor)
        
        let view = OTPView(presenter: presenter)
        let otpRouter = OTPRouter(navigator: router)
        
        presenter.setRouter(otpRouter)
        return view
    }

    public static func makeResetPassword(theme: Theme,
                                         router: ResetPasswordRoutingLogic,
                                         networkMonitor: NetworkMonitor) ->
    ResetPasswordView
    {
        Theme.current = theme
        let presenter = ResetPasswordPresenter()
        let view = ResetPasswordView(presenter: presenter)
        let resetPasswordRouter = ResetPasswordRouter(navigator: router)

        presenter.setRouter(resetPasswordRouter)
        return view
    }

    public static func makeProfileRoot(theme: Theme,
                                       provider: ProfileRootDataProviderLogic,
                                       router: ProfileRootRoutingLogic,
                                       networkMonitor: NetworkMonitor) ->
    ProfileRootView
    {
        Theme.current = theme
        let interactor = ProfileRootInteractor(provider: provider)
        let presenter = ProfileRootPresenter(interactor: interactor)

        let view = ProfileRootView(presenter: presenter)
        let profileRootRouter = ProfileRootRouter(navigator: router)

        presenter.setRouter(profileRootRouter)
        return view
    }

    public static func makeViewProfile(theme: Theme,
                                       provider: ViewProfileDataProviderLogic,
//                                       router: ProfileRootRoutingLogic,
                                       networkMonitor: NetworkMonitor) ->
    ViewProfileView
    {
        Theme.current = theme
        let interactor = ViewProfileInteractor(provider: provider)
        let presenter = ViewProfilePresenter(interactor: interactor)

        let view = ViewProfileView(presenter: presenter)
//        let profileRootRouter = ProfileRootRouter(navigator: router)

//        presenter.setRouter(profileRootRouter)
        return view
    }
}
