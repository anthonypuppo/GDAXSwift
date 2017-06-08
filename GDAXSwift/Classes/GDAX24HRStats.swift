//
//  GDAX24HRStats.swift
//  GDAXSwift
//
//  Created by Anthony on 6/4/17.
//  Copyright © 2017 Anthony Puppo. All rights reserved.
//

public struct GDAX24HRStats: JSONInitializable {
	
	public let open: Double
	public let high: Double
	public let low: Double
	public let volume: Double
	
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
		
		guard let open = Double(json["open"] as? String ?? "") else {
			throw GDAXError.responseParsingFailure("open")
		}
		
		guard let high = Double(json["high"] as? String ?? "") else {
			throw GDAXError.responseParsingFailure("high")
		}
		
		guard let low = Double(json["low"] as? String ?? "") else {
			throw GDAXError.responseParsingFailure("low")
		}
		
		guard let volume = Double(json["volume"] as? String ?? "") else {
			throw GDAXError.responseParsingFailure("volume")
		}
		
		self.open = open
		self.high = high
		self.low = low
		self.volume = volume
	}
	
}
