//
//  ISSGateway.swift
//
//
//  Copyright by iSoftStone 2024.
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
                                       router: ProfileRootRoutingLogic) ->
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

    public static func makeChangePassword(theme: Theme,
                                          provider: ChangePasswordDataProviderLogic,
//                                       router: ProfileRootRoutingLogic,
                                          networkMonitor: NetworkMonitor) ->
    ChangePasswordView
    {
        Theme.current = theme
        let interactor = ChangePasswordInteractor(provider: provider)
        let presenter = ChangePasswordPresenter(interactor: interactor)

        let view = ChangePasswordView(presenter: presenter)
//        let profileRootRouter = ProfileRootRouter(navigator: router)

//        presenter.setRouter(profileRootRouter)
        return view
    }

    public static func makeTimeFrame(theme: Theme,
                                     provider: TimeFrameDataProviderLogic,
                                     networkMonitor: NetworkMonitor) ->
    SPTimeFrameView
    {
        Theme.current = theme
        let interactor = TimeFrameInteractor(provider: provider)
        let presenter = TimeFramePresenter(interactor: interactor)

        let view = SPTimeFrameView(presenter: presenter)

        return view
    }

    public static func makeMyAvailabilityList(theme: Theme,
                                              provider: MyAvailabilityListDataProviderLogic,
                                              router: MyAvailabilityListRoutingLogic,
                                              networkMonitor: NetworkMonitor) ->
    MyAvailabilityListView
    {
        Theme.current = theme
        let interactor = MyAvailabilityListInteractor(provider: provider)
        let presenter = MyAvailabilityListPresenter(interactor: interactor)

        let view = MyAvailabilityListView(presenter: presenter)
        let myAvailabilityListRouter = MyAvailabilityListRouter(navigator: router)
        presenter.setRouter(myAvailabilityListRouter)

        return view
    }
}
