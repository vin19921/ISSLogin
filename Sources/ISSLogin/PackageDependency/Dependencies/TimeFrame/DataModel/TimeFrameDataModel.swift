//
//  File.swift
//  
//
//  Created by Wing Seng Chew on 07/05/2024.
//

public protocol TimeFrameListResponseDataModel {
    var resultCode: Int16 { get }
    var resultMessage: String { get }
    var status: Int16 { get }
}

public struct TimeFrameListResponseDataModel: Codable {
    public let resultCode: Int16
    public let resultMessage: String
    public let status: Int16

    enum CodingKeys: String, CodingKey {
        case resultCode
        case resultMessage
        case status
    }
}

public extension TimeFrameListResponseDataModel {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        resultCode = try container.decodeIfPresent(Int16.self, forKey: .resultCode) ?? 0
        resultMessage = try container.decodeIfPresent(String.self, forKey: .resultMessage) ?? ""
        status = try container.decodeIfPresent(Int16.self, forKey: .status) ?? 0
    }
}

public struct TimeFrameListResponse: Codable {
    public let resultCode: Int16?
    public let resultMessage: String?
    public let status: Int16?
}

public extension TimeFrameListResponse {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        resultCode = try container.decode(Int16.self, forKey: .resultCode)
        resultMessage = try container.decode(String.self, forKey: .resultMessage)
        status = try container.decode(Int16.self, forKey: .status)
    }
}
