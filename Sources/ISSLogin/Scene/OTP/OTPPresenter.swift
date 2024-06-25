//
//  OTPPresenter.swift
//
//
//  Copyright by iSoftStone 2024.
//

import Combine
import Foundation
import ISSCommonUI

final class OTPPresenter: ObservableObject {
    private var interactor: OTPBusinessLogic
    private var router: OTPRouter?
    private var cancellables = Set<AnyCancellable>()
    private var mobileNo: String = ""
    private var otpAction = OTPAction.registration

    @Published var remainingTimeInSeconds: Int = 10 // 180
    @Published var showingAlert = false
    @Published var alertInfo = AlertInfo(message: "")
    @Published var otpDataModel: OTPDataModel?
    @Published var otpAttemptCount: Int16 = 1

    // MARK: Injection

    init(interactor: OTPBusinessLogic) {
        self.interactor = interactor
    }

    func setRouter(_ router: OTPRouter) {
        self.router = router
    }

    func getFormattedRemainingTime() -> String {
        let minutes = remainingTimeInSeconds / 60
        let seconds = remainingTimeInSeconds % 60

        return String(format: "%02i:%02i", minutes, seconds)
    }

    func fetchOTP(otpAction: OTPAction, request: OTP.Model.Request, completionHandler: (() -> Void)? = nil) {
        interactor.fetchOTP(request: request)
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
                        default:
                            print("CommonServiceError ::: connectivity")
                        }
                    }
                case .finished:
                    break
                }
            }, receiveValue: { response in
                DispatchQueue.main.async {
                    self.handleOTPResponse(response: response)
                }
            })
            .store(in: &cancellables)
    }

    private func handleOTPResponse(response: OTP.Model.Response) {
        let resultCode = response.resultCode
        let resultMessage = response.resultMessage
        let data = response.data
        print("OTP Successful ::: \(data)")
    }

    func validateOTP(request: OTP.Model.Request, completionHandler: (() -> Void)? = nil) {
        print("otpAction ::: \(otpAction)")
        interactor.validateOTP(otpAction: otpAction, request: request)
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
                        default:
                            print("CommonServiceError ::: connectivity")
                        }
                    }
                case .finished:
                    break
                }
            }, receiveValue: { response in
                DispatchQueue.main.async {
                    self.handleValidateOTPResponse(response: response)
                }
            })
            .store(in: &cancellables)
    }

    private func handleValidateOTPResponse(response: OTP.Model.Response) {
        let resultCode = response.resultCode
        let resultMessage = response.resultMessage
        let data = response.data
        print("OTP Successful ::: \(data)")

        if let code = response.resultCode,
           let message = response.resultMessage {
            print("resultCode ::: \(code), resultMessage ::: \(message)")

            if code > 0 {
                let isExceedAttempt = otpAttemptCount + 1 > 3
                otpAttemptCount = data.otpAttemptCount ?? 0
                alertInfo = AlertInfo(alertType: .failure, message: message, onDismiss: {
                    if isExceedAttempt {
                        self.routeToLogin()
                    }
                })
            } else {
                if let message = data.message {
                    alertInfo = AlertInfo(alertType: .success, message: message, onDismiss: {
                        self.routeToLogin()
                    })
                }
            }
            showingAlert.toggle()
        }
    }
}

// MARK: - Routing

extension OTPPresenter {
    func routeToLogin() {
        router?.navigate(to: .loginScreen)
    }
}

extension OTPPresenter {
    func setMobileNo(_ mobileNo: String) {
        self.mobileNo = mobileNo
    }

    func getMobileNo() -> String {
        mobileNo
    }

    func setOTPAction(_ otpAction: OTPAction) {
        self.otpAction = otpAction
    }

    func getOTPAction() -> OTPAction {
        otpAction
    }
}
