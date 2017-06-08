//
//  GDAXProductTicker.swift
//  GDAXSwift
//
//  Created by Anthony on 6/4/17.
//  Copyright © 2017 Anthony Puppo. All rights reserved.
//

public struct GDAXProductTicker: JSONInitializable {
	
	public let tradeID: Int
	public let price: Double
	public let size: Double
	public let bid: Double
	public let ask: Double
	public let volume: Double
	public let time: Date
	
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
		
		guard let tradeID = json["trade_id"] as? Int else {
			throw GDAXError.responseParsingFailure("trade_id")
		}
		
		guard let price = Double(json["price"] as? String ?? "") else {
			throw GDAXError.responseParsingFailure("price")
		}
		
		guard let size = Double(json["size"] as? String ?? "") else {
			throw GDAXError.responseParsingFailure("size")
		}
		
		guard let bid = Double(json["bid"] as? String ?? "") else {
			throw GDAXError.responseParsingFailure("bid")
		}
		
		guard let ask = Double(json["ask"] as? String ?? "") else {
			throw GDAXError.responseParsingFailure("ask")
		}
		
		guard let volume = Double(json["volume"] as? String ?? "") else {
			throw GDAXError.responseParsingFailure("volume")
		}
		
		guard let time = (json["time"] as? String)?.dateFromISO8601 else {
			throw GDAXError.responseParsingFailure("time")
		}
		
		self.tradeID = tradeID
		self.price = price
		self.size = size
		self.bid = bid
		self.ask = ask
		self.volume = volume
		self.time = time
	}
	
}
