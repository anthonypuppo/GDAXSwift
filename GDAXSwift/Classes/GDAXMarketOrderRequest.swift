//
//  GDAXMarketOrderRequest.swift
//  GDAXSwift
//
//  Created by Anthony on 6/9/17.
//  Copyright © 2017 Anthony Puppo. All rights reserved.
//

public struct GDAXMarketOrderRequest: GDAXOrderRequestProtocol {
	
	public let type: GDAXOrderType = .market
	
	public var clientOID: String?
	public var side: GDAXSide
	public var productID: String
	public var stp: GDAXSelfTradePrevention?
	
	public var size: Double?
	public var funds: Double?
	
	public init(
		clientOID: String? = nil,
		side: GDAXSide,
		productID: String,
		stp: GDAXSelfTradePrevention? = nil,
		size: Double? = nil,
		funds: Double? = nil) {
		self.clientOID = clientOID
		self.side = side
		self.productID = productID
		self.stp = stp
		self.size = size
		self.funds = funds
	}
	
	public func asJSON() -> [String : Any] {
		var json: [String: Any] = [
			"type": type.rawValue,
			"side": side.rawValue,
			"product_id": productID
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
