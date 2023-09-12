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
//                                          provider: EventsDataProviderLogic,
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
        
//        let interactor = EventsOverviewInteractor(provider: provider)
        let presenter = LoginPresenter()
        
        let view = LoginView(presenter: presenter)
        let loginRouter = LoginRouter(navigator: router)
        
        presenter.setRouter(loginRouter)
        return view
    }

    public static func makeRegister(theme: Theme,
//                                          provider: EventsDataProviderLogic,
                                          router: RegisterRoutingLogic,
                                          networkMonitor: NetworkMonitor
    ) ->
    RegisterView
    {
        /// Explicity setting the theme to register fonts and colors required by events package.
        Theme.current = theme
//        injectEventsOverviewProvider(provider)
//        injectEventsOverviewRouter(router)
//        injectNetworkMonitor(networkMonitor)
        
//        let interactor = EventsOverviewInteractor(provider: provider)
        let presenter = RegisterPresenter()
        
        let view = RegisterView(presenter: presenter)
        let registerRouter = RegisterRouter(navigator: router)
        
        presenter.setRouter(registerRouter)
        return view
    }

    public static func makeOTP(theme: Theme,
//                                          provider: EventsDataProviderLogic,
                                          router: OTPRoutingLogic,
                                          networkMonitor: NetworkMonitor
    ) ->
    OTPView
    {
        /// Explicity setting the theme to register fonts and colors required by events package.
        Theme.current = theme
//        injectEventsOverviewProvider(provider)
//        injectEventsOverviewRouter(router)
//        injectNetworkMonitor(networkMonitor)
        
//        let interactor = EventsOverviewInteractor(provider: provider)
        let presenter = OTPPresenter()
        
        let view = OTPView(presenter: presenter)
        let otpRouter = OTPRouter(navigator: router)
        
        presenter.setRouter(otpRouter)
        return view
    }
}
