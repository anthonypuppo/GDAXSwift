//
//  DataExtensions.swift
//  GDAXSwift
//
//  Created by Anthony on 6/4/17.
//  Copyright © 2017 Anthony Puppo. All rights reserved.
//

internal extension Data {
	
	internal var json: [String: Any]? {
		do {
			return try JSONSerialization.jsonObject(with: self, options: []) as? [String: Any]
		} catch _ { }
		
		return nil
	}
	
	internal var jsonArray: [Any]? {
		do {
			return try JSONSerialization.jsonObject(with: self, options: []) as? [Any]
		} catch _ { }
		
		return nil
	}
	
}
