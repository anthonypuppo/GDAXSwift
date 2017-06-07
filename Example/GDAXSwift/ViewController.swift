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
	
	@IBAction func btnRunTests_Tap(_ sender: Any) {
		gdaxClient.public.getProductHistoricRates(productID: "BTC-USD", completionHandler: { (rates, response, error) in
			print(rates)
			print(error)
		})
	}

}
