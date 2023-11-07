//
//  File.swift
//  
//
//  Created by Wing Seng Chew on 20/09/2023.
//

public struct OTPDataModel: Codable {
    public let id: String?
    public let email: String?
    public let mobileNo: String?
    public let message: String?
    public let otpAttemptCount: Int

    enum CodingKeys: String, CodingKey {
        case id
        case email
        case mobileNo
        case message
        case otpAttemptCount
    }
}

public struct OTPResponse: Codable {
    public let resultCode: Int16
    public let resultMessage: String
    public let data: OTPDataModel
}

public extension OTPResponse {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        resultCode = try container.decode(Int16.self, forKey: .resultCode) ?? 0
        resultMessage = try container.decode(String.self, forKey: .resultMessage) ?? ""
        data = try container.decode(OTPDataModel.self, forKey: .data)
    }
}
