//
//  GDAXPagination.swift
//  GDAXSwift
//
//  Created by Anthony on 6/4/17.
//  Copyright © 2017 Anthony Puppo. All rights reserved.
//

public struct GDAXPagination {
	
	public var before: Int?
	public var after: Int?
	public var limit: Int?
	
	public var urlQueryItems: [URLQueryItem] {
		var items = [URLQueryItem]()
		
		if before != nil {
			items.append(URLQueryItem(name: "before", value: String(before!)))
		}
		
		if after != nil {
			items.append(URLQueryItem(name: "after", value: String(after!)))
		}
		
		if limit != nil {
			items.append(URLQueryItem(name: "limit", value: String(limit!)))
		}
		
		return items
	}
	
	public init(before: Int? = nil, after: Int? = nil, limit: Int? = nil) {
		self.before = before
		self.after = after
		self.limit = limit
	}
	
	public init(response: HTTPURLResponse) {
		let headers = response.allHeaderFields
		let beforeHeader = headers["cb-before"] as? String
		let afterHeader = headers["cb-after"] as? String
		let before = (beforeHeader != nil) ? Int(beforeHeader!) : nil
		let after = (afterHeader != nil) ? Int(afterHeader!) : nil
		
		self.init(before: before, after: after, limit: nil)
	}
	
}
