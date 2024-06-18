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
    @Published var selectedDates = [String]()

    enum State {
        case isLoading
        case failure(FailureType)
        case success(TimeFrame.Model.ViewModel)
    }

    enum FailureType {
        case connectivity
        case internet
        case noData
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
            if let timeFrameListViewModel = timeFrameListViewModel {
                state = .success(timeFrameListViewModel)
            } else {
                state = .failure(.noData)
            }
        }
    }

    func createTimeFrame(request: TimeFrame.Model.CreateRequest, completionHandler: (() -> Void)? = nil) {
        interactor.createTimeFrame(request: request)
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
                    self.handleCreateTimeFrameResponse(response: response)
                }
            })
            .store(in: &cancellables)
    }

    private func handleCreateTimeFrameResponse(response: TimeFrame.Model.CreateResponse) {
//        if let data = response.data {
//            timeFrameListViewModel = TimeFrame.Model.ViewModel(message: "Select time",
//                                                               timeFrameList: data.timeFrame)
//            if let timeFrameListViewModel = timeFrameListViewModel {
//                state = .success(timeFrameListViewModel)
//            } else {
//                state = .failure(.noData)
//            }
//        }
    }
}

extension TimeFramePresenter {
    func convertMultipleDatesToISO8601(selectedTimeFrameId: String, targetHour: Int = 0, targetMinute: Int = 0, targetSecond: Int = 0) -> [TimeFrame.Model.TimeFrame] {
        var isoDateStrings: [TimeFrame.Model.TimeFrame] = []
        
        for dateString in selectedDates {
            if let isoDateString = convertToISO8601(dateString: dateString, targetHour: targetHour, targetMinute: targetMinute, targetSecond: targetSecond) {
                isoDateStrings.append(TimeFrame.Model.TimeFrame(date: isoDateString, timeFrameId: selectedTimeFrameId))
            }
        }

        return isoDateStrings
    }

    func convertToISO8601(dateString: String, targetHour: Int = 0, targetMinute: Int = 0, targetSecond: Int = 0) -> String? {
        // DateFormatter to parse the initial date string
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        // Convert the input string to a Date object
        guard let date = dateFormatter.date(from: dateString) else {
            print("Invalid date string: \(dateString)")
            return nil
        }
        
        // Get the calendar and create a DateComponents object
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(secondsFromGMT: 0)! // Ensure the time zone is UTC
        var dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        dateComponents.hour = targetHour
        dateComponents.minute = targetMinute
        dateComponents.second = targetSecond
        
        // Create a new Date object with the target time
        guard let targetDate = calendar.date(from: dateComponents) else {
            print("Could not create target date for: \(dateString)")
            return nil
        }
        
        // ISO8601DateFormatter to convert the Date object to an ISO 8601 string
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        // Convert the Date object to an ISO 8601 string
        let isoDateString = isoFormatter.string(from: targetDate)
        return isoDateString
    }
}
