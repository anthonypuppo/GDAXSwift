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
	private static let fillsRootURLString = "/fills"
	
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
	
	public func placeOrder<T: GDAXOrderRequestProtocol>(order: T, completionHandler: @escaping (GDAXOrder?, HTTPURLResponse?, Error?) -> Void) {
		httpClient.requestJSON(urlString: GDAXPrivateClient.ordersRootURLString, method: .post, body: order.asJSON().jsonData, completionHandler: completionHandler)
	}
	
	public func cancelOrder(orderID: String, completionHandler: @escaping (String?, HTTPURLResponse?, Error?) -> Void) {
		httpClient.request(urlString: "\(GDAXPrivateClient.ordersRootURLString)/\(orderID)", method: .delete, completionHandler: { (data, response, error) in
			guard error == nil else {
				completionHandler(nil, nil, error)
				
				return
			}
			
			do {
				guard let id = (try JSONSerialization.jsonObject(with: data!, options: []) as? [String])?.first else {
					completionHandler(nil, nil, GDAXError.responseParsingFailure("id"))
					
					return
				}
				
				completionHandler(id, response, nil)
			} catch {
				completionHandler(nil, nil, error)
			}
		})
	}
	
	public func cancelAllOrders(productID: String? = nil, completionHandler: @escaping ([String]?, HTTPURLResponse?, Error?) -> Void) {
		var query = [URLQueryItem]()
		
		if let productID = productID {
			query.append(URLQueryItem(name: "product_id", value: productID))
		}
		
		httpClient.request(urlString: GDAXPrivateClient.ordersRootURLString, method: .delete, query: query, completionHandler: { (data, response, error) in
			guard error == nil else {
				completionHandler(nil, nil, error)
				
				return
			}
			
			do {
				var ids = [String]()
				
				for id in try JSONSerialization.jsonObject(with: data!, options: []) as? [String] ?? [String]() {
					ids.append(id)
				}
				
				completionHandler(ids, response, error)
			} catch {
				completionHandler(nil, nil, error)
			}
		})
	}
	
	public func getOrders(productID: String? = nil, statuses: [GDAXOrderStatus]? = nil, pagination: GDAXPagination? = nil, completionHandler: @escaping ([GDAXOrder]?, GDAXPagination?, HTTPURLResponse?, Error?) -> Void) {
		var query = [URLQueryItem]()
		
		if let productID = productID {
			query.append(URLQueryItem(name: "product_id", value: productID))
		}
		
		if let statuses = statuses {
			for status in statuses {
				query.append(URLQueryItem(name: "status", value: status.rawValue))
			}
		}
		
		if let pagination = pagination {
			query.append(contentsOf: pagination.urlQueryItems)
		}
		
		httpClient.requestJSON(urlString: GDAXPrivateClient.ordersRootURLString, method: .get, query: query, completionHandler: { (orders: [GDAXOrder]?, response: HTTPURLResponse?, error: Error?) in
			guard error == nil else {
				completionHandler(nil, nil, nil, error)
				
				return
			}
			
			completionHandler(orders, GDAXPagination(response: response!), response, nil)
		})
	}
	
	public func getOrder(orderID: String, completionHandler: @escaping (GDAXOrder?, HTTPURLResponse?, Error?) -> Void) {
		httpClient.requestJSON(urlString: "\(GDAXPrivateClient.ordersRootURLString)/\(orderID)", method: .get, completionHandler: completionHandler)
	}
	
	public func getFills(orderID: String? = nil, productID: String? = nil, pagination: GDAXPagination? = nil, completionHandler: @escaping ([GDAXFill]?, GDAXPagination?, HTTPURLResponse?, Error?) -> Void) {
		var query = [URLQueryItem]()
		
		if let orderID = orderID {
			query.append(URLQueryItem(name: "order_id", value: orderID))
		}
		
		if let productID = productID {
			query.append(URLQueryItem(name: "product_id", value: productID))
		}
		
		if let pagination = pagination {
			query.append(contentsOf: pagination.urlQueryItems)
		}
		
		httpClient.requestJSON(urlString: GDAXPrivateClient.fillsRootURLString, method: .get, query: query, completionHandler: { (fills: [GDAXFill]?, response: HTTPURLResponse?, error: Error?) in
			guard error == nil else {
				completionHandler(nil, nil, nil, error)
				
				return
			}
			
			completionHandler(fills, GDAXPagination(response: response!), response, nil)
		})
	}
	
}
