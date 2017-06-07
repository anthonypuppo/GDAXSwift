//
//  GDAXProductOrderBook.swift
//  GDAXSwift
//
//  Created by Anthony on 6/4/17.
//  Copyright © 2017 Anthony Puppo. All rights reserved.
//

public struct GDAXProductOrderBook: JSONInitializable {
	
	let sequence: Int
	let bids: [GDAXBid]
	let asks: [GDAXAsk]
	
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
		
		guard let sequence = json["sequence"] as? Int else {
			throw GDAXError.responseParsingFailure("sequence")
		}
		
		guard let bidArray = json["bids"] as? [[Any]] else {
			throw GDAXError.responseParsingFailure("bids")
		}
		
		guard let askArray = json["asks"] as? [[Any]] else {
			throw GDAXError.responseParsingFailure("asks")
		}
		
		self.sequence = sequence
		
		var bids = [GDAXBid]()
		var asks = [GDAXAsk]()
		
		for bid in bidArray {
			guard bid.count == 3 else {
				throw GDAXError.responseParsingFailure("One or more bids did not have an array length of 3")
			}
			
			guard let price = Double(bid[0] as? String ?? "") else {
				throw GDAXError.responseParsingFailure("price")
			}
			
			guard let size = Double(bid[1] as? String ?? "") else {
				throw GDAXError.responseParsingFailure("size")
			}
			
			bids.append(GDAXBid(price: price, size: size, numOrders: bid[2] as? Int, orderID: bid[2] as? String))
		}
		
		for ask in askArray {
			guard ask.count == 3 else {
				throw GDAXError.responseParsingFailure("One or more asks did not have an array length of 3")
			}
			
			guard let price = Double(ask[0] as? String ?? "") else {
				throw GDAXError.responseParsingFailure("price")
			}
			
			guard let size = Double(ask[1] as? String ?? "") else {
				throw GDAXError.responseParsingFailure("size")
			}
			
			asks.append(GDAXAsk(price: price, size: size, numOrders: ask[2] as? Int, orderID: ask[2] as? String))
		}
		
		self.bids = bids
		self.asks = asks
	}
	
}
