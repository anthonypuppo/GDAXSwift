//
//  GDAXAccountHistoryDetails.swift
//  GDAXSwift
//
//  Created by Anthony on 6/7/17.
//  Copyright © 2017 Anthony Puppo. All rights reserved.
//

public struct GDAXAccountHistoryDetails: JSONInitializable {
	
	public let orderID: String
	public let tradeID: Int
	public let productID: String
	
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
		
		guard let orderID = json["order_id"] as? String else {
			throw GDAXError.responseParsingFailure("order_id")
		}
		
		guard let tradeID = Int(json["trade_id"] as? String ?? "") else {
			throw GDAXError.responseParsingFailure("trade_id")
		}
		
		guard let productID = json["product_id"] as? String else {
			throw GDAXError.responseParsingFailure("product_id")
		}
		
		self.orderID = orderID
		self.tradeID = tradeID
		self.productID = productID
	}
	
}
