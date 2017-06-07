//
//  HTTPClient.swift
//  GDAXSwift
//
//  Created by Anthony on 6/4/17.
//  Copyright © 2017 Anthony Puppo. All rights reserved.
//

internal class HTTPClient {
	
	public private(set) var baseURL: URL?
	public private(set) var requestMiddleware: [RequestMiddleware]
	public private(set) var responseMiddleware: [ResponseMiddleware]
	
	public init() {
		self.requestMiddleware = [RequestMiddleware]()
		self.responseMiddleware = [ResponseMiddleware]()
	}
	
	public func baseURL(baseURL: URL?) -> Self {
		self.baseURL = baseURL
		
		return self
	}
	
	public func baseURL(baseURLString: String?) -> Self {
		self.baseURL = (baseURLString != nil) ? URL(string: baseURLString!) : nil
		
		return self
	}
	
	public func requestMiddleware(middleware: RequestMiddleware) -> Self {
		requestMiddleware.append(middleware)
		
		return self
	}
	
	public func responseMiddleware(middleware: ResponseMiddleware) -> Self {
		responseMiddleware.append(middleware)
		
		return self
	}
	
	public func request(urlString: String, method: HTTPMethod, query: [URLQueryItem]? = nil, body: Data? = nil, completionHandler: @escaping (Data?, HTTPURLResponse?, Error?) -> Void) {
		request(request: buildURLRequest(urlString: urlString, method: method, query: query, body: body), completionHandler: completionHandler)
	}
	
	public func request(request: URLRequest, completionHandler: @escaping (Data?, HTTPURLResponse?, Error?) -> Void) {
		var request = request
		
		do {
			for middleware in requestMiddleware {
				try middleware.run(request: &request)
			}
		} catch {
			completionHandler(nil, nil, error)
			
			return
		}
		
		URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
			guard error == nil else {
				completionHandler(nil, nil, error)
					
				return
			}
			
			var httpResponse = response as! HTTPURLResponse
			var data = data
				
			do {
				for middleware in self.responseMiddleware {
					try middleware.run(response: &httpResponse, data: &data)
				}
			} catch {
				completionHandler(nil, nil, error)
				
				return
			}
				
			completionHandler(data, httpResponse, nil)
		}).resume()
	}
	
	public func requestJSON<T: JSONInitializable>(urlString: String, method: HTTPMethod, query: [URLQueryItem]? = nil, body: Data? = nil, completionHandler: @escaping (T?, HTTPURLResponse?, Error?) -> Void) {
		requestJSON(request: buildURLRequest(urlString: urlString, method: method, query: query, body: body), completionHandler: completionHandler)
	}
	
	public func requestJSON<T: JSONInitializable>(request urlRequest: URLRequest, completionHandler: @escaping (T?, HTTPURLResponse?, Error?) -> Void) {
		request(request: urlRequest, completionHandler: { (data, response, error) in
			guard error == nil else {
				completionHandler(nil, nil, error)
				
				return
			}
			
			do {
				completionHandler(try T(json: data as Any), response, nil)
			} catch {
				completionHandler(nil, response, error)
			}
		})
	}
	
	public func requestJSON<T: JSONInitializable>(urlString: String, method: HTTPMethod, query: [URLQueryItem]? = nil, body: Data? = nil, completionHandler: @escaping ([T]?, HTTPURLResponse?, Error?) -> Void) {
		requestJSON(request: buildURLRequest(urlString: urlString, method: method, query: query, body: body), completionHandler: completionHandler)
	}
	
	public func requestJSON<T: JSONInitializable>(request urlRequest: URLRequest, completionHandler: @escaping ([T]?, HTTPURLResponse?, Error?) -> Void) {
		request(request: urlRequest, completionHandler: { (data, response, error) in
			guard error == nil else {
				completionHandler(nil, nil, error)
				
				return
			}
			
			do {
				var objects = [T]()
				
				guard let data = data else {
					completionHandler(objects, response, nil)
					
					return
				}
				
				guard let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [Any] else {
					completionHandler(objects, response, nil)
					
					return
				}
				
				for json in jsonArray {
					objects.append(try T(json: json as Any))
				}
				
				completionHandler(objects, response, nil)
			} catch {
				completionHandler(nil, response, error)
			}
		})
	}
	
	public func buildURLRequest(urlString: String, method: HTTPMethod, query: [URLQueryItem]? = nil, body: Data? = nil) -> URLRequest {
		var components = URLComponents(string: urlWithBase(passedURLString: urlString)?.absoluteString ?? "")!
		
		if let query = query, query.count > 0 {
			components.queryItems = query
		}
		
		var urlRequest = URLRequest(url: components.url!)
		
		urlRequest.httpMethod = method.rawValue.uppercased()
		urlRequest.httpBody = body
		
		return urlRequest
	}
	
	public func urlWithBase(passedURLString: String) -> URL? {
		return (baseURL != nil) ? URL(string: passedURLString, relativeTo: baseURL) : URL(string: passedURLString)
	}
	
}
