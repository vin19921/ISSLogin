//
//  File.swift
//  
//
//  Created by Wing Seng Chew on 07/11/2023.
//

import ISSCommonUI
import Combine
import Foundation

final class ChangePasswordPresenter: ObservableObject {
    private var interactor: ChangePasswordBusinessLogic
    private var cancellables = Set<AnyCancellable>()

    @Published var showingAlert = false
    @Published var alertMessage = ""
    @Published var alertInfo: AlertInfo?

    @Published var isDisabled = true
    @Published var oldPasswordText = ""
    @Published var newPassowrdText = ""
    @Published var confirmNewPasswordText = ""

    @Published var oldPasswordErrorState = false
    @Published var newPasswordErrorState = false
    @Published var confirmNewPasswordErrorState = false

    // MARK: Injection

    init(interactor: ChangePasswordBusinessLogic) {
        self.interactor = interactor
    }

    func updateData(completionHandler: (() -> Void)? = nil) {
        changePassword(request: ChangePassword.Model.UpdateRequest(oldPassword: oldPasswordText, newPassword: confirmNewPasswordText), completionHandler: completionHandler) { result in
            switch result {
            case let .success(success):
                self.handleChangePasswordResponse(response: success)
            case let .failure(error):
                //                self.handleError(error: error)
                print(error)
            }
        }
    }

    func changePassword(request: ChangePassword.Model.UpdateRequest,
                        completionHandler: (() -> Void)? = nil,
                        completion: @escaping (Result<ChangePassword.Model.Response, Error>) -> Void
    ) {
        interactor.changePassword(request: request)
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
//                            self.state = .failure(.internet)
                        default:
                            //                            self.presenterState = .failure(.connectivity)
                            print("CommonServiceError ::: connectivity")
//                            self.state = .failure(.connectivity)
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

    private func handleChangePasswordResponse(response: ChangePassword.Model.Response) {
        let status = response.status

        if let code = response.resultCode,
           let message = response.resultMessage {
            print("resultCode ::: \(code), resultMessage ::: \(message)")

            if code == 0 {
                alertInfo = AlertInfo(alertType: .success, message: message, onDismiss: {
                    alertInfo = nil
                })
            } else {
                alertInfo = AlertInfo(alertType: .failure, message: message, onDismiss: {
                    alertInfo = nil
                })
            }
            showingAlert.toggle()
        }
    }
}
