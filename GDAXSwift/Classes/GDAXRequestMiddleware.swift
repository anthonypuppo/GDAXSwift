//
//  GDAXRequestMiddleware.swift
//  GDAXSwift
//
//  Created by Anthony on 6/4/17.
//  Copyright © 2017 Anthony Puppo. All rights reserved.
//

internal class GDAXRequestMiddleware: RequestMiddleware {
	
	public private(set) var requestAuthenticator: GDAXRequestAuthenticator?
	
	public init(gdaxClient: GDAXClient, authenticateRequests: Bool) {
		if authenticateRequests {
			requestAuthenticator = GDAXRequestAuthenticator(gdaxClient: gdaxClient)
		}
	}
	
	public func run(request: inout URLRequest) throws {
		try requestAuthenticator?.authenticate(request: &request)
		request.addValue("application/json", forHTTPHeaderField: "Accept")
		
		if request.httpBody != nil {
			request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		}
	}
	
}
