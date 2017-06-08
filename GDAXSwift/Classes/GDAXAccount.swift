//
//  GDAX24HRStats.swift
//  GDAXSwift
//
//  Created by Anthony on 6/6/17.
//  Copyright © 2017 Anthony Puppo. All rights reserved.
//

public struct GDAXAccount: JSONInitializable {
	
	public let id: String
	public let currency: String
	public let balance: Double
	public let available: Double
	public let hold: Double
	public let profileID: String
	
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
		
		guard let id = json["id"] as? String else {
			throw GDAXError.responseParsingFailure("id")
		}
		
		guard let currency = json["currency"] as? String else {
			throw GDAXError.responseParsingFailure("currency")
		}
		
		guard let balance = Double(json["balance"] as? String ?? "") else {
			throw GDAXError.responseParsingFailure("balance")
		}
		
		guard let available = Double(json["available"] as? String ?? "") else {
			throw GDAXError.responseParsingFailure("available")
		}
		
		guard let hold = Double(json["hold"] as? String ?? "") else {
			throw GDAXError.responseParsingFailure("hold")
		}
		
		guard let profileID = json["profile_id"] as? String else {
			throw GDAXError.responseParsingFailure("profile_id")
		}
		
		self.id = id
		self.currency = currency
		self.balance = balance
		self.available = available
		self.hold = hold
		self.profileID = profileID
	}
	
}
