//
//  File.swift
//  
//
//  Created by Wing Seng Chew on 07/05/2024.
//

import Foundation

final class TimeFramePresenter: ObservableObject {
    private var interactor: TimeFrameBusinessLogic
    private var cancellables = Set<AnyCancellable>()
    @Published var state = State.isLoading

    enum State {
        case isLoading
        case failure(FailureType)
        case success
    }

    enum FailureType {
        case connectivity
        case internet
    }

    // MARK: Injection

    init(interactor: TimeFrameBusinessLogic) {
        self.interactor = interactor
    }

    func fetchTimeFrameList(request: TimeFrame.Model.Request, completionHandler: (() -> Void)? = nil) {
        interactor.fetchTimeFrameList(request: request)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }

                isLoading.toggle()

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
                    print(response)
                }
            })
            .store(in: &cancellables)
    }
}

// MARK: - Routing

extension TimeFramePresenter {
    func routeToOTP(mobileNo: String) {
        router?.navigate(to: .otpScreen(mobileNo: mobileNo))
    }
}
