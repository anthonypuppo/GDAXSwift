//
//  GDAXRequestAuthenticator.swift
//  GDAXSwift
//
//  Created by Anthony on 6/4/17.
//  Copyright © 2017 Anthony Puppo. All rights reserved.
//

import CryptoSwift

public class GDAXRequestAuthenticator {
	
	public let gdaxClient: GDAXClient
	
	public init(gdaxClient: GDAXClient) {
		self.gdaxClient = gdaxClient
	}
	
	public func authenticate(request: inout URLRequest) throws {
		let baseURLString = gdaxClient.baseURLString
		
		guard let urlString = request.url?.absoluteString, urlString.hasPrefix(baseURLString) else {
			throw GDAXError.authenticationBuilderError("Attempted to authenticate a non GDAX endpoint request")
		}
		
		guard let apiKey = gdaxClient.apiKey, let secret64 = gdaxClient.secret64, let passphrase = gdaxClient.passphrase else {
			throw GDAXError.authenticationBuilderError("A GDAX API key, secret and passphrase must be defined")
		}
		
		guard let method = request.httpMethod else {
			throw GDAXError.authenticationBuilderError("Attempted to authenticate a request with no HTTP method")
		}
		
		let timestamp = Int64(Date().timeIntervalSince1970)
		let relativeURL = "\(urlString.replacingOccurrences(of: baseURLString, with: ""))"
		let hmac = try generateSignature(secret64: secret64, timestamp: timestamp, method: method, relativeURL: relativeURL, body: request.httpBody)
		
		request.setValue(apiKey, forHTTPHeaderField: "CB-ACCESS-KEY")
		request.setValue(hmac, forHTTPHeaderField: "CB-ACCESS-SIGN")
		request.setValue(String(timestamp), forHTTPHeaderField: "CB-ACCESS-TIMESTAMP")
		request.setValue(passphrase, forHTTPHeaderField: "CB-ACCESS-PASSPHRASE")
	}
	
	private func generateSignature(secret64: String, timestamp: Int64, method: String, relativeURL: String, body: Data? = nil) throws -> String {
		var preHash = "\(timestamp)\(method.uppercased())\(relativeURL)"
		
		if let body = body {
			guard let bodyString = String(data: body, encoding: .utf8) else {
				throw GDAXError.authenticationBuilderError("Failed to UTF8 encode the request body")
			}
			
			preHash += bodyString
		}
		
		guard let secret = Data(base64Encoded: secret64) else {
			throw GDAXError.authenticationBuilderError("Failed to base64 decode secret")
		}
		
		guard let preHashData = preHash.data(using: .utf8) else {
			throw GDAXError.authenticationBuilderError("Failed to convert preHash into data")
		}
		
		guard let hmac = try HMAC(key: secret.bytes, variant: .sha256).authenticate(preHashData.bytes).toBase64() else {
			throw GDAXError.authenticationBuilderError("Failed to generate HMAC from preHash")
		}
		
		return hmac
	}
	
}
