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
	
	private static let accountsRootURLString = "/accounts"
	private static let ordersRootURLString = "/orders"
	
	internal init(gdaxClient: GDAXClient) {
		self.gdaxClient = gdaxClient
		self.httpClient = HTTPClient()
			.baseURL(baseURLString: gdaxClient.baseURLString)
			.requestMiddleware(middleware: GDAXRequestMiddleware(gdaxClient: gdaxClient, authenticateRequests: true))
			.responseMiddleware(middleware: GDAXResponseMiddleware())
	}
	
	public func getAccounts(_ completionHandler: @escaping ([GDAXAccount]?, HTTPURLResponse?, Error?) -> Void) {
		httpClient.requestJSON(urlString: GDAXPrivateClient.accountsRootURLString, method: .get, completionHandler: completionHandler)
	}
	
	public func getAccount(accountID: String, completionHandler: @escaping (GDAXAccount?, HTTPURLResponse?, Error?) -> Void) {
		httpClient.requestJSON(urlString: "\(GDAXPrivateClient.accountsRootURLString)/\(accountID)", method: .get, completionHandler: completionHandler)
	}
	
	public func getAccountHistory(accountID: String, pagination: GDAXPagination? = nil, completionHandler: @escaping ([GDAXAccountHistory]?, GDAXPagination?, HTTPURLResponse?, Error?) -> Void) {
		var query = [URLQueryItem]()
		
		if let pagination = pagination {
			query.append(contentsOf: pagination.urlQueryItems)
		}
		
		httpClient.requestJSON(urlString: "\(GDAXPrivateClient.accountsRootURLString)/\(accountID)/ledger", method: .get, query: query, completionHandler: { (history: [GDAXAccountHistory]?, response: HTTPURLResponse?, error: Error?) in
			guard error == nil else {
				completionHandler(nil, nil, nil, error)
				
				return
			}
			
			completionHandler(history, GDAXPagination(response: response!), response, nil)
		})
	}
	
	public func getAccountHolds(accountID: String, pagination: GDAXPagination? = nil, completionHandler: @escaping ([GDAXAccountHold]?, GDAXPagination?, HTTPURLResponse?, Error?) -> Void) {
		var query = [URLQueryItem]()
		
		if let pagination = pagination {
			query.append(contentsOf: pagination.urlQueryItems)
		}
		
		httpClient.requestJSON(urlString: "\(GDAXPrivateClient.accountsRootURLString)/\(accountID)/holds", method: .get, query: query, completionHandler: { (history: [GDAXAccountHold]?, response: HTTPURLResponse?, error: Error?) in
			guard error == nil else {
				completionHandler(nil, nil, nil, error)
				
				return
			}
			
			completionHandler(history, GDAXPagination(response: response!), response, nil)
		})
	}
	
}
