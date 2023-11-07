//
//  File.swift
//  
//
//  Created by Wing Seng Chew on 07/11/2023.
//

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
