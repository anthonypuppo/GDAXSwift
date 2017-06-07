//
//  GDAXResponseMiddleware.swift
//  GDAXSwift
//
//  Created by Anthony on 6/4/17.
//  Copyright © 2017 Anthony Puppo. All rights reserved.
//

internal class GDAXResponseMiddleware: ResponseMiddleware {
	
	public func run(response: inout HTTPURLResponse, data: inout Data?) throws {
		guard 200...299 ~= response.statusCode else {
			throw GDAXError.invalidStatusCode(response.statusCode, data?.json?["message"] as? String ?? "")
		}

		guard data != nil else {
			throw GDAXError.invalidResponseData
		}
	}
	
}
