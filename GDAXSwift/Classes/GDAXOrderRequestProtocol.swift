//
//  GDAXOrderRequest.swift
//  GDAXSwift
//
//  Created by Anthony on 6/9/17.
//  Copyright © 2017 Anthony Puppo. All rights reserved.
//

public protocol GDAXOrderRequestProtocol: JSONConvertible {
	
	var type: GDAXOrderType { get }
	
	var clientOID: String? { get set }
	var side: GDAXSide { get set }
	var productID: String { get set }
	var stp: GDAXSelfTradePrevention? { get set }
	
}
