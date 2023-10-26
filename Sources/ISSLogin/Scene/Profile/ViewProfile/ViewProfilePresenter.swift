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

    @Published var showingAlert = false
    @Published var errorMessage = ""

    // MARK: Injection

    init(interactor: ViewProfileBusinessLogic) {
        self.interactor = interactor
    }

    func fetchViewProfile(request: ViewProfile.Model.Request, completionHandler: (() -> Void)? = nil) {
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
