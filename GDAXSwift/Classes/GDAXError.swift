//
//  GDAXError.swift
//  GDAXSwift
//
//  Created by Anthony on 6/4/17.
//  Copyright © 2017 Anthony Puppo. All rights reserved.
//

public enum GDAXError: Error, LocalizedError {
	
	case invalidRequestValue(String, Any)
	case invalidStatusCode(Int, String)
	case authenticationBuilderError(String)
	case invalidResponseData
	case responseParsingFailure(String)
	
	public var errorDescription: String? {
		switch self {
		case .invalidRequestValue(let fieldName, let value):
			return NSLocalizedString("(\(fieldName)) \(value)", comment: "error")
		case .invalidStatusCode(let statusCode, let message):
			return NSLocalizedString("(\(statusCode) - \(message))", comment: "error")
		case .authenticationBuilderError(let message):
			return NSLocalizedString(message, comment: "error")
		case .invalidResponseData:
			return NSLocalizedString("Could not read response data", comment: "error")
		case .responseParsingFailure(let message):
			return NSLocalizedString(message, comment: "error")
		}
	}
	
}
