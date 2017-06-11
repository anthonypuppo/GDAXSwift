//
//  GDAXLimitOrder.swift
//  GDAXSwift
//
//  Created by Anthony on 6/9/17.
//  Copyright © 2017 Anthony Puppo. All rights reserved.
//

public struct GDAXLimitOrderRequest: GDAXOrderRequestProtocol {
	
	public let type: GDAXOrderType = .limit
	
	public var clientOID: String?
	public var side: GDAXSide
	public var productID: String
	public var stp: GDAXSelfTradePrevention?
	
	public var price: Double
	public var size: Double
	public var timeInForce: GDAXTimeInForce?
	public var cancelAfter: GDAXCancelAfterTimeUnit?
	public var postOnly: Bool?
	
	public init(
		clientOID: String? = nil,
		side: GDAXSide,
		productID: String,
		stp: GDAXSelfTradePrevention? = nil,
		price: Double,
		size: Double,
		timeInForce: GDAXTimeInForce? = nil,
		cancelAfter: GDAXCancelAfterTimeUnit? = nil,
		postOnly: Bool? = nil) {
		self.clientOID = clientOID
		self.side = side
		self.productID = productID
		self.stp = stp
		self.price = price
		self.size = size
		self.timeInForce = timeInForce
		self.cancelAfter = cancelAfter
		self.postOnly = postOnly
	}
	
	public func asJSON() -> [String: Any] {
		var json: [String: Any] = [
			"type": type.rawValue,
			"side": side.rawValue,
			"product_id": productID,
			"price": price,
			"size": size
		]
		
		if let clientOID = clientOID {
			json["client_oid"] = clientOID
		}
		
		if let stp = stp {
			json["stp"] = stp.rawValue
		}
		
		if let timeInForce = timeInForce {
			json["time_in_force"] = timeInForce.rawValue
		}
		
		if let cancelAfter = cancelAfter {
			json["cancel_after"] = cancelAfter.rawValue
		}
		
		if let postOnly = postOnly {
			json["post_only"] = postOnly
		}
		
		return json
	}
	
}
