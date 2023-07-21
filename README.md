# GDAXSwift

[![Version](https://img.shields.io/cocoapods/v/GDAXSwift.svg?style=flat)](http://cocoapods.org/pods/GDAXSwift)
[![License](https://img.shields.io/cocoapods/l/GDAXSwift.svg?style=flat)](http://cocoapods.org/pods/GDAXSwift)
[![Platform](https://img.shields.io/cocoapods/p/GDAXSwift.svg?style=flat)](http://cocoapods.org/pods/GDAXSwift)

## Features

* Lightweight, minimal codebase
* Sandbox support
* Automatic request signing when calling any of the private endpoints
* All networking and JSON parsing handled internally
* Request/response object models
* Easy to handle, callback based response handling

While this library does the majority of the heavy lifting for you it is still recommended to read over the [official GDAX documentation](https://docs.gdax.com/).

## Requirements

* iOS 8.0+ / macOS 10.10+ / tvOS 9.0+ / watchOS 2.0+
* Xcode 8.1+
* Swift 3.0+

## Installation

GDAXSwift is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "GDAXSwift"
```

## Usage

Create an instance of `GDAXClient` using any of the available initializers. You may then use the `public` and `private` instance properties to access the public and private endpoints, respectivly.

Note that an error will be thrown if you attempt to access any of the private endpoints without supplying an API key, base64 encoded secret and passphrase.

```swift
let gdaxClient = GDAXClient(apiKey: "API key", secret64: "base64 encoded secret", passphrase: "passphrase", isSandbox: false)

// Multiple convenience initializers exist
// For example, if only querying public data on the live exchange, a new client may be constructed as GDAXClient()

// public (no authentication required)
gdaxClient.public.getProducts({ (products, response, error) in
	print("Response: \(products as Any)")
	print("Error: \(error as Any)")
})

// private (authentication required)
gdaxClient.private.getAccounts({ (accounts, response, error) in
	print("Response: \(accounts as Any)")
	print("Error: \(error as Any)")
})
```

## TODO

* Finish implementing all private endpoints
* Support for the Websocket Feed
* Documentation

## Changelog

See the [CHANGELOG](./CHANGELOG) file.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## License

GDAXSwift is available under the MIT license. See the [LICENSE](./LICENSE) file for more info.
