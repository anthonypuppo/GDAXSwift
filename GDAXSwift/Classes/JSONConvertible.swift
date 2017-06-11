//
//  JSONConvertible.swift
//  GDAXSwift
//
//  Created by Anthony on 6/10/17.
//  Copyright © 2017 Anthony Puppo. All rights reserved.
//

public protocol JSONConvertible {
	
	func asJSON() -> [String: Any]
	
}
