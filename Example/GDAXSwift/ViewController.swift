//
//  ViewController.swift
//  GDAXSwift
//
//  Created by Anthony Puppo on 06/04/2017.
//  Copyright (c) 2017 Anthony Puppo. All rights reserved.
//

import UIKit
import GDAXSwift

class ViewController: UIViewController {

	private var gdaxClient: GDAXClient!
	
    override func viewDidLoad() {
        super.viewDidLoad()
        gdaxClient = GDAXClient(apiKey: nil, secret64: nil, passphrase: nil, isSandbox: false)
    }
	
	@IBAction func btnPublicTest_Tap(_ sender: Any) {
		gdaxClient.public.getProducts({ (products, response, error) in
			print("Response: \(products as Any)")
			print("Error: \(error as Any)")
		})
		
		gdaxClient.public.getCurrencies({ (currencies, _, error) in
			print(currencies)
		})
	}
	
	@IBAction func btnPrivateTest_Tap(_ sender: Any) {
		gdaxClient.private.getAccounts({ (accounts, response, error) in
			print("Response: \(accounts as Any)")
			print("Error: \(error as Any)")
		})
	}
	
}
