//
//  File.swift
//  
//
//  Created by Wing Seng Chew on 26/10/2023.
//

import Combine
import Foundation

final class ViewProfilePresenter: ObservableObject {
    private var interactor: ViewProfileBusinessLogic
    private var cancellables = Set<AnyCancellable>()

    @Published var state = State.isLoading
    @Published var showingAlert = false
    @Published var errorMessage = ""

    @Published var fullNameText = ""
    @Published var emailText = ""
    @Published var phoneText = ""

    @Published var fullNameErrorState = false
    @Published var emailErrorState = false
    @Published var phoneErrorState = false

    enum State {
        case isLoading
        case failure(FailureType)
        case success(ViewProfile.Model.ViewModel?)
    }

    enum FailureType {
        case connectivity
        case internet
    }

    // MARK: Injection

    init(interactor: ViewProfileBusinessLogic) {
        self.interactor = interactor
    }

    func fetchData(request: ViewProfile.Model.FetchRequest) {
        fetchViewProfile(request: request) { result in
            switch result {
            case let .success(success):
                self.handleViewProfileResponse(response: success)
            case let .failure(error):
                //                self.handleError(error: error)
                print(error)
            }
        }
    }

    func fetchViewProfile(request: ViewProfile.Model.FetchRequest, completion: @escaping (Result<ViewProfile.Model.Response, Error>) -> Void) {
        interactor.fetchViewProfile(request: request)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                
                //                completionHandler?()
                
                switch completion {
                case let .failure(error):
                    DispatchQueue.main.async {
                        switch error.localizedDescription {
                        case CommonServiceError.internetFailure.localizedDescription:
                            //                            self.presenterState = .failure(.internet)
                            print("CommonServiceError ::: internet")
                            self.state = .failure(.internet)
                        default:
                            //                            self.presenterState = .failure(.connectivity)
                            print("CommonServiceError ::: connectivity")
                            self.state = .failure(.connectivity)
                        }
                    }
                case .finished:
                    break
                }
            }, receiveValue: { response in
                DispatchQueue.main.async {
                    print("\(response)")
//                    self.handleViewProfileResponse(response: response)
                    completion(.success(response))
                }
            })
            .store(in: &cancellables)
    }

    func updateData() {
        updateProfile(request: ViewProfile.Model.UpdateRequest(name: fullNameText, email: emailText)) { result in
            switch result {
            case let .success(success):
                self.handleViewProfileResponse(response: success)
            case let .failure(error):
                //                self.handleError(error: error)
                print(error)
            }
        }
    }

    func updateProfile(request: ViewProfile.Model.UpdateRequest, completion: @escaping (Result<ViewProfile.Model.Response, Error>) -> Void) {
        interactor.updateProfile(request: request)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                
                //                completionHandler?()
                
                switch completion {
                case let .failure(error):
                    DispatchQueue.main.async {
                        switch error.localizedDescription {
                        case CommonServiceError.internetFailure.localizedDescription:
                            //                            self.presenterState = .failure(.internet)
                            print("CommonServiceError ::: internet")
                            self.state = .failure(.internet)
                        default:
                            //                            self.presenterState = .failure(.connectivity)
                            print("CommonServiceError ::: connectivity")
                            self.state = .failure(.connectivity)
                        }
                    }
                case .finished:
                    break
                }
            }, receiveValue: { response in
                DispatchQueue.main.async {
                    print("\(response)")
//                    self.handleViewProfileResponse(response: response)
                    completion(.success(response))
                }
            })
            .store(in: &cancellables)
    }

    private func handleViewProfileResponse(response: ViewProfile.Model.Response) {
//        let resultCode = response.resultCode
//        let resultMessage = response.resultMessage
        let status = response.status
        let data = response.data

        if let code = response.resultCode,
           let message = response.resultMessage {
            print("resultCode ::: \(code), resultMessage ::: \(message)")

            if code > 0 {
                showingAlert = true
                errorMessage = message
            } else {
//                print("Login Successful ::: \(data)")
//                if let data = response.data.token?.appToken {
//                    saveUserInfo(key: .userEmail, value: data.email ?? "")
//                    saveUserInfo(key: .accessToken, value: data.token?.appToken ?? "")
//                    saveUserInfo(key: .isLoggedIn, value: true)
//                    saveUserInfo(loginDataModel: data)
//                }
                fullNameText = data.name ?? ""
                emailText = data.email ?? ""
                phoneText = data.mobileNo ?? ""
                self.state = .success(ViewProfile.Model.ViewModel(message: response.resultMessage ?? "",
                                                                  viewProfileData: response.data))
            }
        }
//        else {
////            loginDataModel = data
//            print("Login Successful ::: \(data)")
//            //            routeToOTP(mobileNo: data.mobileNo)
//            //        }
//        }
    }
}
