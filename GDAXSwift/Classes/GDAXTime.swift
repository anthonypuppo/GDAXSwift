//
//  GDAXTime.swift
//  GDAXSwift
//
//  Created by Anthony on 6/4/17.
//  Copyright © 2017 Anthony Puppo. All rights reserved.
//

public struct GDAXTime: JSONInitializable {
	
	let iso: Date
	let epoch: Double

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
		
		guard let iso = (json["iso"] as? String)?.dateFromISO8601 else {
			throw GDAXError.responseParsingFailure("iso")
		}
		
		guard let epoch = json["epoch"] as? Double else {
			throw GDAXError.responseParsingFailure("epoch")
		}
		
		self.iso = iso
		self.epoch = epoch
	}
	
}
