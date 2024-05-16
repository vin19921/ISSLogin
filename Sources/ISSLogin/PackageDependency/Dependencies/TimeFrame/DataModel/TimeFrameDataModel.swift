//
//  File.swift
//  
//
//  Created by Wing Seng Chew on 07/05/2024.
//

//public struct TimeFrameListResponseDataModel: Codable {
//    public let resultCode: Int16
//    public let resultMessage: String
//    public let status: Int16
//
//    enum CodingKeys: String, CodingKey {
//        case resultCode
//        case resultMessage
//        case status
//    }
//}

//public extension TimeFrameListResponseDataModel {
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        resultCode = try container.decodeIfPresent(Int16.self, forKey: .resultCode) ?? 0
//        resultMessage = try container.decodeIfPresent(String.self, forKey: .resultMessage) ?? ""
//        status = try container.decodeIfPresent(Int16.self, forKey: .status) ?? 0
//    }
//}

public struct TimeFrameListResponse: Codable {
//    public let resultCode: Int16
    public let resultMessage: String
//    public let status: Int16
    public let data: TimeFrameListDataModel
}

public extension TimeFrameListResponse {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
//        resultCode = try container.decode(Int16.self, forKey: .resultCode) ?? 0
        resultMessage = try container.decode(String.self, forKey: .resultMessage) ?? ""
//        status = try container.decode(Int16.self, forKey: .status) ?? 0
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

public struct TimeFrameDataModel: Codable {
    public let id: String?
    public let startTime: String?
    public let endTime: String?
    public let name: String?
    public let status: Bool?

    enum CodingKeys: String, CodingKey {
        case id
        case startTime
        case endTime
        case name
        case status
    }
}

public extension TimeFrameDataModel {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        startTime = try container.decode(String.self, forKey: .startTime)
        endTime = try container.decode(String.self, forKey: .endTime)
        name = try container.decode(String.self, forKey: .name)
        status = try container.decode(Bool.self, forKey: .status)
    }
}
