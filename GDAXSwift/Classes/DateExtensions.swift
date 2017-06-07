//
//  DateExtensions.swift
//  GDAXSwift
//
//  Created by Anthony on 6/4/17.
//  Copyright © 2017 Anthony Puppo. All rights reserved.
//

public extension Date {
	
	public var iso8601: String {
		return Formatter.iso8601.string(from: self)
	}
	
}
