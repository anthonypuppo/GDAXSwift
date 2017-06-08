//
//  GDAXCurrency.swift
//  GDAXSwift
//
//  Created by Anthony on 6/4/17.
//  Copyright © 2017 Anthony Puppo. All rights reserved.
//

public struct GDAXCurrency: JSONInitializable {
	
	public let id: String
	public let name: String
	public let minSize: Double
	
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
		
		guard let name = json["name"] as? String else {
			throw GDAXError.responseParsingFailure("name")
		}
		
		guard let minSize = Double(json["min_size"] as? String ?? "") else {
			throw GDAXError.responseParsingFailure("min_size")
		}
		
		self.id = id
		self.name = name
		self.minSize = minSize
	}
	
}
