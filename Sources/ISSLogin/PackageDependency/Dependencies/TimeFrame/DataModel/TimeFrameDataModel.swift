//
//  TimeFrameDataModel.swift
//
//
//  Copyright by iSoftStone 2024.
//

public struct TimeFrameListResponse: Codable {
    public let resultMessage: String
    public let data: TimeFrameListDataModel
}

public extension TimeFrameListResponse {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        resultMessage = try container.decode(String.self, forKey: .resultMessage) ?? ""
        data = try container.decode(TimeFrameListDataModel.self, forKey: .data)
    }
}

public struct TimeFrameListDataModel: Codable {
    public let timeFrame: [TimeFrameDataModel]

    enum CodingKeys: String, CodingKey {
        case timeFrame
    }
}

public extension TimeFrameListDataModel {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        timeFrame = try container.decode([TimeFrameDataModel].self, forKey: .timeFrame) ?? []
    }
}

public struct TimeFrameDataModel: Codable, Identifiable {
    public let id: String
    public let startTime: String
    public let endTime: String
    public let name: String
    public let status: Bool

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case startTime
        case endTime
        case name
        case status
    }

    public static func == (lhs: TimeFrameDataModel, rhs: TimeFrameDataModel) -> Bool {
        lhs.id == rhs.id
    }
}

public extension TimeFrameDataModel {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id) ?? ""
        startTime = try container.decode(String.self, forKey: .startTime) ?? ""
        endTime = try container.decode(String.self, forKey: .endTime) ?? ""
        name = try container.decode(String.self, forKey: .name) ?? ""
        status = try container.decode(Bool.self, forKey: .status) ?? false
    }
}
