//
//  GDAX24HRStats.swift
//  GDAXSwift
//
//  Created by Anthony on 6/6/17.
//  Copyright © 2017 Anthony Puppo. All rights reserved.
//

public struct GDAXAccountHistory: JSONInitializable {
	
	public let id: Int
	public let createdAt: Date
	public let amount: Double
	public let balance: Double
	public let type: GDAXAccountHistoryType
	public let details: GDAXAccountHistoryDetails?
	
	internal init(json: Any) throws {
		var jsonData: Data?
		
		if let json = json as? Data {
			jsonData = json
		} else {
			jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
		}
		
		guard let json = jsonData?.json else {
			throw GDAXError.invalidResponseData
		}
		
		guard let id = json["id"] as? Int else {
			throw GDAXError.responseParsingFailure("id")
		}
		
		guard let createdAt = (json["created_at"] as? String)?.dateFromISO8601 else {
			throw GDAXError.responseParsingFailure("created_at")
		}
		
		guard let amount = Double(json["amount"] as? String ?? "") else {
			throw GDAXError.responseParsingFailure("amount")
		}
		
		guard let balance = Double(json["balance"] as? String ?? "") else {
			throw GDAXError.responseParsingFailure("balance")
		}
		
		guard let type = GDAXAccountHistoryType(rawValue: json["type"] as? String ?? "") else {
			throw GDAXError.responseParsingFailure("type")
		}
		
		self.id = id
		self.createdAt = createdAt
		self.amount = amount
		self.balance = balance
		self.type = type
		
		switch type {
		case .match, .fee: // result of a trade
			details = try GDAXAccountHistoryDetails(json: json["details"] as Any)
			
			break
		default:
			details = nil
		}
	}
	
}
