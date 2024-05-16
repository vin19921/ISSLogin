//
//  File.swift
//  
//
//  Created by Wing Seng Chew on 07/05/2024.
//

import Combine
import Foundation

final class TimeFramePresenter: ObservableObject {
    private var interactor: TimeFrameBusinessLogic
    private var cancellables = Set<AnyCancellable>()
    @Published var state = State.isLoading
    @Published var timeFrameListViewModel: TimeFrame.Model.ViewModel?

    enum State {
        case isLoading
        case failure(FailureType)
        case success(TimeFrame.Model.ViewModel)
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

                switch completion {
                case let .failure(error):
                    DispatchQueue.main.async {
                        switch error.localizedDescription {
                        case CommonServiceError.internetFailure.localizedDescription:
                            self.state = .failure(.internet)
                            print("CommonServiceError ::: internet")
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
                    self.handleRegistrationResponse(response: response)
                }
            })
            .store(in: &cancellables)
    }

    private func handleRegistrationResponse(response: TimeFrame.Model.Response) {
        if let data = response.data {
            timeFrameListViewModel = TimeFrame.Model.ViewModel(message: "Select time",
                                                               timeFrameList: data.timeFrame)
            if timeFrameListViewModel != nil {
                state = .success(timeFrameListViewModel)
            }
        }
    }
}
