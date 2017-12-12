//
//  GDAXOrder.swift
//  GDAXSwift
//
//  Created by Anthony on 6/7/17.
//  Copyright © 2017 Anthony Puppo. All rights reserved.
//

public struct GDAXOrder: JSONInitializable {
	
	/* Some fields are optional. E.g. pending market orders might not 
	   have price and size or funds. timeInForce is also not always set. */
	public let id: String
	public let price: Double?
	public let size: Double?
	public let funds: Double?
	public let productID: String
	public let side: GDAXSide
	public let stp: GDAXSelfTradePrevention
	public let type: GDAXOrderType
	public let timeInForce: GDAXTimeInForce?
	public let postOnly: Bool
	public let createdAt: Date
	public let fillFees: Double
	public let filledSize: Double
	public let executedValue: Double
	public let status: GDAXOrderStatus
	public let settled: Bool
	public let doneReason: GDAXDoneReason?
	public let rejectReason: String?
	
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
		
		let price = Double(json["price"] as? String ?? "")
		let size = Double(json["size"] as? String ?? "")
		let funds = Double(json["funds"] as? String ?? "")

		guard let productID = json["product_id"] as? String else {
			throw GDAXError.responseParsingFailure("product_id")
		}
		
		guard let side = GDAXSide(rawValue: json["side"] as? String ?? "") else {
			throw GDAXError.responseParsingFailure("side")
		}
		
		guard let stp = GDAXSelfTradePrevention(rawValue: json["stp"] as? String ?? "") else {
			throw GDAXError.responseParsingFailure("stp")
		}
		
		guard let type = GDAXOrderType(rawValue: json["type"] as? String ?? "") else {
			throw GDAXError.responseParsingFailure("type")
		}
		
		let timeInForce = GDAXTimeInForce(rawValue: json["time_in_force"] as? String ?? "")
		
		guard let postOnly = json["post_only"] as? Bool else {
			throw GDAXError.responseParsingFailure("post_only")
		}
		
		guard let createdAt = (json["created_at"] as? String)?.dateFromISO8601 else {
			throw GDAXError.responseParsingFailure("created_at")
		}
		
		guard let fillFees = Double(json["fill_fees"] as? String ?? "") else {
			throw GDAXError.responseParsingFailure("fill_fees")
		}
		
		guard let filledSize = Double(json["filled_size"] as? String ?? "") else {
			throw GDAXError.responseParsingFailure("filled_size")
		}
		
		guard let executedValue = Double(json["executed_value"] as? String ?? "") else {
			throw GDAXError.responseParsingFailure("executed_value")
		}
		
		guard let status = GDAXOrderStatus(rawValue: json["status"] as? String ?? "") else {
			throw GDAXError.responseParsingFailure("status")
		}
		
		guard let settled = json["settled"] as? Bool else {
			throw GDAXError.responseParsingFailure("settled")
		}

		let doneReason = GDAXDoneReason(rawValue: json["done_reason"] as? String ?? "")

		let rejectReason = json["reject_reason"] as? String

		self.id = id
		self.price = price
		self.size = size
		self.productID = productID
		self.side = side
		self.stp = stp
		self.type = type
		self.timeInForce = timeInForce
		self.postOnly = postOnly
		self.createdAt = createdAt
		self.fillFees = fillFees
		self.filledSize = filledSize
		self.funds = funds
		self.executedValue = executedValue
		self.status = status
		self.settled = settled
		self.doneReason = doneReason
		self.rejectReason = rejectReason
	}
	
}
