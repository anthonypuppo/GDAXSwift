//
//  GDAXProduct.swift
//  GDAXSwift
//
//  Created by Anthony on 6/4/17.
//  Copyright © 2017 Anthony Puppo. All rights reserved.
//

public struct GDAXProduct: JSONInitializable {
	
	public let id: String
	public let baseCurrency: String
	public let quoteCurrency: String
	public let baseMinSize: Double
	public let baseMaxSize: Double
	public let quoteIncrement: Double
	
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
		
		guard let baseCurrency = json["base_currency"] as? String else {
			throw GDAXError.responseParsingFailure("base_currency")
		}
		
		guard let quoteCurrency = json["quote_currency"] as? String else {
			throw GDAXError.responseParsingFailure("quote_currency")
		}
		
		guard let baseMinSize = Double(json["base_min_size"] as? String ?? "") else {
			throw GDAXError.responseParsingFailure("base_min_size")
		}
		
		guard let baseMaxSize = Double(json["base_max_size"] as? String ?? "") else {
			throw GDAXError.responseParsingFailure("base_max_size")
		}
		
		guard let quoteIncrement = Double(json["quote_increment"] as? String ?? "") else {
			throw GDAXError.responseParsingFailure("quote_increment")
		}
		
		self.id = id
		self.baseCurrency = baseCurrency
		self.quoteCurrency = quoteCurrency
		self.baseMinSize = baseMinSize
		self.baseMaxSize = baseMaxSize
		self.quoteIncrement = quoteIncrement
	}
	
}
