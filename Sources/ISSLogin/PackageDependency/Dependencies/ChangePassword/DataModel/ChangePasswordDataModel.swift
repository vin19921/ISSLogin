//
//  ChangePasswordDataModel.swift
//
//
//  Copyright by iSoftStone 2024.
//

public struct ChangePasswordDataModel: Codable {
    public let message: String?

    enum CodingKeys: String, CodingKey {
        case message
    }
}

public struct ChangePasswordResponse: Codable {
    public let resultCode: Int16?
    public let resultMessage: String?
    public let status: Int16?
}

public extension ChangePasswordResponse {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        resultCode = try? container.decode(Int16.self, forKey: .resultCode)
        resultMessage = try? container.decode(String.self, forKey: .resultMessage)
        status = try? container.decodeIfPresent(Int16.self, forKey: .status) ?? 0
    }
}
