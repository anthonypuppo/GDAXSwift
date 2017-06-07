//
//  GDAXPrivateClient.swift
//  GDAXSwift
//
//  Created by Anthony on 6/4/17.
//  Copyright © 2017 Anthony Puppo. All rights reserved.
//

public class GDAXPrivateClient {
	
	public let gdaxClient: GDAXClient
	
	private let httpClient: HTTPClient
	
	private static let accountsRootURL = "/accounts"
	private static let ordersRootURL = "/orders"
	
	internal init(gdaxClient: GDAXClient) {
		self.gdaxClient = gdaxClient
		self.httpClient = HTTPClient()
			.baseURL(baseURLString: gdaxClient.baseURLString)
			.requestMiddleware(middleware: GDAXRequestMiddleware(gdaxClient: gdaxClient, authenticateRequests: true))
			.responseMiddleware(middleware: GDAXResponseMiddleware())
	}
	
}
