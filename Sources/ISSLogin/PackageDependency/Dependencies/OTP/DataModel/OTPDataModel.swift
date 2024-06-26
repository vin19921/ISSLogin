//
//  OTPDataModel.swift
//
//
//  Copyright by iSoftStone 2024.
//

public struct OTPDataModel: Codable {
    public let id: String?
    public let email: String?
    public let mobileNo: String?
    public let message: String?
    public let otpAttemptCount: Int16?

    enum CodingKeys: String, CodingKey {
        case id
        case email
        case mobileNo
        case message
        case otpAttemptCount
    }
}

public extension OTPDataModel {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id) ?? ""
        email = try container.decodeIfPresent(String.self, forKey: .email) ?? ""
        mobileNo = try container.decodeIfPresent(String.self, forKey: .mobileNo) ?? ""
        message = try container.decodeIfPresent(String.self, forKey: .message) ?? ""
        otpAttemptCount = try container.decodeIfPresent(Int16.self, forKey: .otpAttemptCount) ?? 0
    }
}

public struct OTPResponse: Codable {
    public let resultCode: Int16?
    public let resultMessage: String?
    public let data: OTPDataModel
}

public extension OTPResponse {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        resultCode = try container.decode(Int16.self, forKey: .resultCode)
        resultMessage = try container.decode(String.self, forKey: .resultMessage)
        data = try container.decode(OTPDataModel.self, forKey: .data)
    }
}
