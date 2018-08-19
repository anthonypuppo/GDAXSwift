//
//  GDAXClient.swift
//  GDAXSwift
//
//  Created by Anthony on 6/4/17.
//  Copyright © 2017 Anthony Puppo. All rights reserved.
//

public class GDAXClient {
	
    public static let baseAPIURLString = "https://api.pro.coinbase.com"
    public static let baseSandboxAPIURLString = "https://api-public.sandbox.pro.coinbase.com"
	
	public let apiKey: String?
	public let secret64: String?
	public let passphrase: String?
	public let isSandbox: Bool
	public let baseURLString: String
	
	public var `public`: GDAXPublicClient {
		return _public
	}
	
	public var `private`: GDAXPrivateClient {
		return _private
	}
	
	private var _public: GDAXPublicClient!
	private var _private: GDAXPrivateClient!
	
	public init(apiKey: String?, secret64: String?, passphrase: String?, isSandbox: Bool = false) {
		self.apiKey = apiKey
		self.secret64 = secret64
		self.passphrase = passphrase
		self.isSandbox = isSandbox
		self.baseURLString = (!isSandbox) ? GDAXClient.baseAPIURLString : GDAXClient.baseSandboxAPIURLString
		self._public = GDAXPublicClient(gdaxClient: self)
		self._private = GDAXPrivateClient(gdaxClient: self)
	}
	
	public convenience init(isSandbox: Bool = false) {
		self.init(apiKey: nil, secret64: nil, passphrase: nil, isSandbox: isSandbox)
	}
	
}
