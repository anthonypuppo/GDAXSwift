//
//  GDAXStopOrderRequest.swift
//  GDAXSwift
//
//  Created by Anthony on 6/9/17.
//  Copyright © 2017 Anthony Puppo. All rights reserved.
//

public struct GDAXStopOrderRequest: GDAXOrderRequestProtocol {
	
	public let type: GDAXOrderType = .stop
	
	public var clientOID: String?
	public var side: GDAXSide
	public var productID: String
	public var stp: GDAXSelfTradePrevention?
	
	public var price: Double
	public var size: Double?
	public var funds: Double?
	
	public init(
		clientOID: String? = nil,
		side: GDAXSide,
		productID: String,
		stp: GDAXSelfTradePrevention? = nil,
		price: Double,
		size: Double? = nil,
		funds: Double?) {
		self.clientOID = clientOID
		self.side = side
		self.productID = productID
		self.stp = stp
		self.price = price
		self.size = size
		self.funds = funds
	}
	
	public func asJSON() -> [String : Any] {
		var json: [String: Any] = [
			"type": type.rawValue,
			"side": side.rawValue,
			"product_id": productID,
			"price": price
		]
		
		if let clientOID = clientOID {
			json["client_oid"] = clientOID
		}
		
		if let stp = stp {
			json["stp"] = stp.rawValue
		}
		
		if let size = size {
			json["size"] = size
		}
		
		if let funds = funds {
			json["funds"] = funds
		}
		
		return json
	}
	
}
