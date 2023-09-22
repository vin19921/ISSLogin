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

    enum CodingKeys: String, CodingKey {
        case id
        case email
        case mobileNo
        case message
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
        resultCode = try container.decode(Int16.self, forKey: .resultCode)
        resultMessage = try container.decode(String.self, forKey: .resultMessage)
        data = try container.decode(OTPDataModel.self, forKey: .data)
    }
}
