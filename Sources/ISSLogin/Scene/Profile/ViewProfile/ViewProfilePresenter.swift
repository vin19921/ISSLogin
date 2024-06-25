//
//  ViewProfilePresenter.swift
//
//
//  Copyright by iSoftStone 2024.
//

import Combine
import Foundation

final class ViewProfilePresenter: ObservableObject {
    private var interactor: ViewProfileBusinessLogic
    private var cancellables = Set<AnyCancellable>()

    @Published var state = State.isLoading
    @Published var showingAlert = false
    @Published var alertMessage = ""

    @Published var isDisabled = true
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
                print(error)
            }
        }
    }

    func fetchViewProfile(request: ViewProfile.Model.FetchRequest, completion: @escaping (Result<ViewProfile.Model.Response, Error>) -> Void) {
        interactor.fetchViewProfile(request: request)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                
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
                    completion(.success(response))
                }
            })
            .store(in: &cancellables)
    }

    func updateData(completionHandler: (() -> Void)? = nil) {
        updateProfile(request: ViewProfile.Model.UpdateRequest(name: fullNameText, email: emailText), completionHandler: completionHandler) { result in
            switch result {
            case let .success(success):
                self.handleViewProfileResponse(response: success)
            case let .failure(error):
                print(error)
            }
        }
    }

    func updateProfile(request: ViewProfile.Model.UpdateRequest,
                       completionHandler: (() -> Void)? = nil,
                       completion: @escaping (Result<ViewProfile.Model.Response, Error>) -> Void
    ) {
        interactor.updateProfile(request: request)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                
                completionHandler?()
                
                switch completion {
                case let .failure(error):
                    DispatchQueue.main.async {
                        switch error.localizedDescription {
                        case CommonServiceError.internetFailure.localizedDescription:
                            print("CommonServiceError ::: internet")
                            self.state = .failure(.internet)
                        default:
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
                    completion(.success(response))
                }
            })
            .store(in: &cancellables)
    }

    private func handleViewProfileResponse(response: ViewProfile.Model.Response) {
        let status = response.status
        let data = response.data

        if let code = response.resultCode,
           let message = response.resultMessage {
            print("resultCode ::: \(code), resultMessage ::: \(message)")

            if code > 0 {
                showingAlert = true
                alertMessage = message
            } else {
                fullNameText = data.user?.name ?? ""
                emailText = data.user?.email ?? ""
                phoneText = data.user?.mobileNo ?? ""

                saveUserInfo(viewProfileDataModel: data)

                if !message.isEmpty {
                    showingAlert = true
                    alertMessage = message
                }
                self.state = .success(ViewProfile.Model.ViewModel(message: message,
                                                                  viewProfileData: response.data))
            }
        }
    }
}

// MARK: - Store User Info

extension ViewProfilePresenter {
    func saveUserInfo(viewProfileDataModel: ViewProfileDataModel) {
        interactor.saveUserInfo(viewProfileDataModel: viewProfileDataModel)
    }
}
