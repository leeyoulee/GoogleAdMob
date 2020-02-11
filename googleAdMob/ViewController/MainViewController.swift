//
//  ViewController.swift
//  googleAdMob
//
//  Created by 이유리 on 17/10/2019.
//  Copyright © 2019 이유리. All rights reserved.
//

import UIKit
import GoogleMobileAds

class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // interstitial load
        AdService.sharedWithoutInit().interstitialAdInit()
    }
    
    // interstitial click event
    @IBAction func interstitialButtonAction(_ sender: UIButton) {
        AdService.sharedWithoutInit().presentInterstitialAd(rootVC: self)
    }
    
}

