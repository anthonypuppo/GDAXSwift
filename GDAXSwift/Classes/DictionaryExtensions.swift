//
//  DictionaryExtensions.swift
//  GDAXSwift
//
//  Created by Anthony on 6/9/17.
//  Copyright © 2017 Anthony Puppo. All rights reserved.
//

internal extension Dictionary {
	
	internal var jsonData: Data? {
		do {
			return try JSONSerialization.data(withJSONObject: self, options: [])
		} catch _ { }
		
		return nil
	}
	
}
