//
//  File 2.swift
//  
//
//  Created by Wing Seng Chew on 12/10/2023.
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
    @Published var isLoggedIn: Bool

    // MARK: Injection

    init(interactor: ProfileRootBusinessLogic) {
        self.interactor = interactor
        self.isLoggedIn = interactor.isLoggedIn()
        print("isLoggedIn ::: \(self.isLoggedIn)")
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
//                    self.handleLoginResponse(response: response)
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

    func logOut() {
        interactor.logOut()
        isLoggedIn = interactor.isLoggedIn()
        print("isLoggedIn ::: \(isLoggedIn)")
    }
}

// MARK: - UserDefaults

extension ProfileRootPresenter {
    func getUserName() -> String {
        interactor.getUserName()
    }
//
//    func isLoggedIn() -> Bool {
//        interactor.isLoggedIn()
//    }
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
