//
//  ProfileRootPresenter.swift
//
//
//  Copyright by iSoftStone 2024.
//

import Combine
import Foundation

final class ProfileRootPresenter: ObservableObject {
    private var interactor: ProfileRootBusinessLogic
    private var router: ProfileRootRouter?
    private var cancellables = Set<AnyCancellable>()

    private let tabBarController = PackageDependency.dependencies?.tabBarController

    @Published var showingAlert = false
    @Published var errorMessage = ""
    @Published var isLoggedIn = false
    @Published var isServiceProvider = false

    // MARK: Injection

    init(interactor: ProfileRootBusinessLogic) {
        self.interactor = interactor
    }

    func setRouter(_ router: ProfileRootRouter) {
        self.router = router
    }

    func viewProfile(request: ViewProfile.Model.FetchRequest, completionHandler: (() -> Void)? = nil) {
        interactor.fetchViewProfile(request: request)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }

                completionHandler?()

                switch completion {
                case let .failure(error):
                    DispatchQueue.main.async {
                        switch error.localizedDescription {
                        case CommonServiceError.internetFailure.localizedDescription:
//                            self.presenterState = .failure(.internet)
                            print("CommonServiceError ::: internet")
                        default:
//                            self.presenterState = .failure(.connectivity)
                            print("CommonServiceError ::: connectivity")
                        }
                    }
                case .finished:
                    break
                }
            }, receiveValue: { response in
                DispatchQueue.main.async {
                    print("\(response)")
                }
            })
            .store(in: &cancellables)
    }
}

// MARK: - Routing

extension ProfileRootPresenter {
    func routeToRoot() {
        router?.navigate(to: .rootScreen)
    }

    func routeToLogin() {
        hideTabBar()
        router?.navigate(to: .loginScreen)
    }

    func routeToViewProfile() {
        router?.navigate(to: .viewProfileScreen)
    }

    func routeToChangePassword() {
        router?.navigate(to: .changePasswordScreen)
    }

    func routeToUserPreference() {
        router?.navigate(to: .userPreference)
    }

    func routeToTimeFrame() {
        router?.navigate(to: .timeFrameScreen)
    }

    func logOut() {
        interactor.logOut()
        updateLoginStatus()
    }
}

// MARK: - UserDefaults

extension ProfileRootPresenter {
    func getUserName() -> String {
        interactor.getUserName()
    }

    func getMobileNo() -> String {
        interactor.getMobileNo()
    }

    func hasRunBefore() -> Bool {
        interactor.hasRunBefore()
    }

    func updateLoginStatus() {
        isLoggedIn = interactor.isLoggedIn()
    }

    func getIsServiceProvider() {
        isServiceProvider = interactor.isServiceProvider()
    }
}

// MARK: - TabBar Controller

extension ProfileRootPresenter {
    func hideTabBar() {
        tabBarController?.hideMainTabBar()
    }
    
    func showTabBar() {
        tabBarController?.showMainTabBar()
    }
}
