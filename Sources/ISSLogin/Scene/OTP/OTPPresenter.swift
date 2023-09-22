//
//  File.swift
//  
//
//  Created by Wing Seng Chew on 12/09/2023.
//

import Foundation

final class OTPPresenter: ObservableObject {

    private var router: OTPRouter?
    private var mobileNo: String = ""

    @Published var remainingTimeInSeconds: Int = 10 // 180

    // MARK: Injection

    func setRouter(_ router: OTPRouter) {
        self.router = router
    }

    func getFormattedRemainingTime() -> String {
        let minutes = remainingTimeInSeconds / 60
        let seconds = remainingTimeInSeconds % 60

        return String(format: "%02i:%02i", minutes, seconds)
    }

    func fetchOTP(request: OTP.Model.Request, completionHandler: (() -> Void)? = nil) {
        interactor.fetchRegister(request: request)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }

                completionHandler?()

                switch completion {
                case let .failure(error):
                    DispatchQueue.main.async {
                        switch error.localizedDescription {
                        case CommonServiceError.internetFailure.localizedDescription:
                            self.presenterState = .failure(.internet)
                        default:
                            self.presenterState = .failure(.connectivity)
                        }
                    }
                case .finished:
                    break
                }
            }, receiveValue: { response in
                DispatchQueue.main.async {
                    self.handleRegistrationResponse(response: response)
                }
            })
            .store(in: &cancellables)
    }

    private func handleRegistrationResponse(response: Registration.Model.Response) {
        let resultCode = response.resultCode
        let resultMessage = response.resultMessage
        let data = response.data
        
//        if resultCode > 0 {
//            print("resultCode ::: \(resultCode), resultMessage ::: \(resultMessage)")
//            showingAlert = true
//            self.presenterState = .success(Registration.Model.ViewModel(message: response.resultMessage,
//                                                                        registrationData: response.data))
//        } else {
            print("Registration Successful ::: \(data)")
//            routeToOTP(mobileNo: data.mobileNo)
//        }
    }
}

// MARK: - Routing

extension OTPPresenter {
    func routeToRegSuccess() {
        router?.navigate(to: .regSuccessScreen)
    }
}

extension OTPPresenter {
    func setMobileNo(_ mobileNo: String) {
        self.mobileNo = mobileNo
    }

    func getMobileNo() -> String {
        return mobileNo
    }
}
