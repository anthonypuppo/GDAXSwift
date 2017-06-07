//
//  GDAXPublicClient.swift
//  GDAXSwift
//
//  Created by Anthony on 6/4/17.
//  Copyright © 2017 Anthony Puppo. All rights reserved.
//

public class GDAXPublicClient {
	
	public let gdaxClient: GDAXClient
	
	private let httpClient: HTTPClient
	
	private static let productsRootURLString = "/products"
	private static let statsRootURLString = "/stats"
	private static let currenciesRootURLString = "/currencies"
	private static let timeRootURLString = "/time"
	
	internal init(gdaxClient: GDAXClient) {
		self.gdaxClient = gdaxClient
		self.httpClient = HTTPClient()
			.baseURL(baseURLString: gdaxClient.baseURLString)
			.requestMiddleware(middleware: GDAXRequestMiddleware(gdaxClient: gdaxClient, authenticateRequests: false))
			.responseMiddleware(middleware: GDAXResponseMiddleware())
	}
	
	public func getProducts(_ completionHandler: @escaping ([GDAXProduct]?, HTTPURLResponse?, Error?) -> Void) {
		httpClient.requestJSON(urlString: GDAXPublicClient.productsRootURLString, method: .get, completionHandler: completionHandler)
	}
	
	public func getProductOrderBook(productID: String, level: Int? = nil, completionHandler: @escaping (GDAXProductOrderBook?, HTTPURLResponse?, Error?) -> Void) {
		var query = [URLQueryItem]()
		
		if let level = level {
			guard 1...3 ~= level else {
				completionHandler(nil, nil, GDAXError.invalidRequestValue("level", "Must be between 1 and 3 or omitted"))
				
				return
			}
			
			query.append(URLQueryItem(name: "level", value: String(level)))
		}
		
		httpClient.requestJSON(urlString: "\(GDAXPublicClient.productsRootURLString)/\(productID)/book", method: .get, query: query, completionHandler: completionHandler)
	}
	
	public func getProductTicker(productID: String, completionHandler: @escaping (GDAXProductTicker?, HTTPURLResponse?, Error?) -> Void) {
		httpClient.requestJSON(urlString: "\(GDAXPublicClient.productsRootURLString)/\(productID)/ticker", method: .get, completionHandler: completionHandler)
	}
	
	public func getProductTrades(productID: String, pagination: GDAXPagination? = nil, completionHandler: @escaping ([GDAXProductTrade]?, GDAXPagination?, HTTPURLResponse?, Error?) -> Void) {
		var query = [URLQueryItem]()
		
		if let pagination = pagination {
			query.append(contentsOf: pagination.urlQueryItems)
		}
		
		httpClient.requestJSON(urlString: "\(GDAXPublicClient.productsRootURLString)/\(productID)/trades", method: .get, query: query, completionHandler: { (trades: [GDAXProductTrade]?, response: HTTPURLResponse?, error: Error?) in
			guard error == nil else {
				completionHandler(nil, nil, nil, error)
				
				return
			}
			
			completionHandler(trades, GDAXPagination(response: response!), response, nil)
		})
	}
	
	public func getProductHistoricRates(productID: String, start: Date? = nil, end: Date? = nil, granularity: Int? = nil, completionHandler: @escaping ([GDAXHistoricRate]?, HTTPURLResponse?, Error?) -> Void) {
		var query = [URLQueryItem]()
		
		if let start = start {
			query.append(URLQueryItem(name: "start", value: start.iso8601))
		}
		
		if let end = end {
			query.append(URLQueryItem(name: "end", value: end.iso8601))
		}
		
		if let granularity = granularity {
			query.append(URLQueryItem(name: "granularity", value: String(granularity)))
		}
		
		httpClient.request(urlString: "\(GDAXPublicClient.productsRootURLString)/\(productID)/candles", method: .get, query: query, completionHandler: { (data, response, error) in
			guard error == nil else {
				completionHandler(nil, nil, error)
				
				return
			}
			
			do {
				guard let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [[Any]] else {
					completionHandler(nil, nil, GDAXError.responseParsingFailure("historic_rates"))
					
					return
				}
				
				var rates = [GDAXHistoricRate]()
				
				for rate in json {
					guard rate.count == 6 else {
						completionHandler(nil, nil, GDAXError.responseParsingFailure("One or more rates did not have an array length of 6"))
						
						return
					}
					
					guard let time = rate[0] as? Int else {
						completionHandler(nil, nil, GDAXError.responseParsingFailure("time"))
						
						return
					}
					
					guard let low = rate[0] as? Double else {
						completionHandler(nil, nil, GDAXError.responseParsingFailure("low"))
						
						return
					}
					
					guard let high = rate[0] as? Double else {
						completionHandler(nil, nil, GDAXError.responseParsingFailure("high"))
						
						return
					}
					
					guard let open = rate[0] as? Double else {
						completionHandler(nil, nil, GDAXError.responseParsingFailure("open"))
						
						return
					}
					
					guard let close = rate[0] as? Double else {
						completionHandler(nil, nil, GDAXError.responseParsingFailure("close"))
						
						return
					}
					
					guard let volume = rate[0] as? Double else {
						completionHandler(nil, nil, GDAXError.responseParsingFailure("volume"))
						
						return
					}
					
					rates.append(GDAXHistoricRate(time: time, low: low, high: high, open: open, close: close, volume: volume))
				}
				
				completionHandler(rates, response, nil)
			} catch {
				completionHandler(nil, nil, error)
			}
		})
	}
	
	public func get24HRStats(productID: String, completionHandler: @escaping (GDAX24HRStats?, HTTPURLResponse?, Error?) -> Void) {
		httpClient.requestJSON(urlString: "\(GDAXPublicClient.productsRootURLString)/\(productID)\(GDAXPublicClient.statsRootURLString)", method: .get, completionHandler: completionHandler)
	}
	
	public func getCurrencies(_ completionHandler: @escaping ([GDAXCurrency]?, HTTPURLResponse?, Error?) -> Void) {
		httpClient.requestJSON(urlString: GDAXPublicClient.currenciesRootURLString, method: .get, completionHandler: completionHandler)
	}
	
	public func getTime(_ completionHandler: @escaping (GDAXTime?, HTTPURLResponse?, Error?) -> Void) {
		httpClient.requestJSON(urlString: GDAXPublicClient.timeRootURLString, method: .get, completionHandler: completionHandler)
	}
	
}
