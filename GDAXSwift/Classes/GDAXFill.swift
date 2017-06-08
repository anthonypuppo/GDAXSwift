//
//  GDAXFill.swift
//  GDAXSwift
//
//  Created by Anthony on 6/7/17.
//  Copyright © 2017 Anthony Puppo. All rights reserved.
//

public struct GDAXFill: JSONInitializable {
	
	public let tradeID: Int
	public let productID: String
	public let price: Double
	public let size: Double
	public let orderID: String
	public let createdAt: Date
	public let liquidity: GDAXLiquidity
	public let fee: Double
	public let settled: Bool
	public let side: GDAXSide
	
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
		
		guard let productID = json["product_id"] as? String else {
			throw GDAXError.responseParsingFailure("product_id")
		}
		
		guard let price = Double(json["price"] as? String ?? "") else {
			throw GDAXError.responseParsingFailure("price")
		}
		
		guard let size = Double(json["size"] as? String ?? "") else {
			throw GDAXError.responseParsingFailure("size")
		}
		
		guard let orderID = json["order_id"] as? String else {
			throw GDAXError.responseParsingFailure("order_id")
		}
		
		guard let createdAt = (json["created_at"] as? String)?.dateFromISO8601 else {
			throw GDAXError.responseParsingFailure("created_at")
		}
		
		guard let liquidity = GDAXLiquidity(rawValue: json["liquidity"] as? String ?? "") else {
			throw GDAXError.responseParsingFailure("liquidity")
		}
		
		guard let fee = Double(json["fee"] as? String ?? "") else {
			throw GDAXError.responseParsingFailure("fee")
		}
		
		guard let settled = json["settled"] as? Bool else {
			throw GDAXError.responseParsingFailure("settled")
		}
		
		guard let side = GDAXSide(rawValue: json["side"] as? String ?? "") else {
			throw GDAXError.responseParsingFailure("side")
		}
		
		self.tradeID = tradeID
		self.productID = productID
		self.price = price
		self.size = size
		self.orderID = orderID
		self.createdAt = createdAt
		self.liquidity = liquidity
		self.fee = fee
		self.settled = settled
		self.side = side
	}
	
}
