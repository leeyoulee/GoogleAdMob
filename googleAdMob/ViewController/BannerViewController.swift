//
//  BannerViewController.swift
//  googleAdMob
//
//  Created by 이유리 on 17/10/2019.
//  Copyright © 2019 이유리. All rights reserved.
//

import UIKit
import GoogleMobileAds

class BannerViewController: UIViewController, GADBannerViewDelegate {

    @IBOutlet weak var bannerView1: UIView!
    @IBOutlet weak var bannerView2: UIView!
    @IBOutlet weak var bannerView3: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Banner load & add View
        AdService.sharedWithoutInit().bannerAdInit(containerView: bannerView1, rootVC: self, viewWidth: 320, viewHeight: 100)
        AdService.sharedWithoutInit().bannerAdInit(containerView: bannerView2, rootVC: self, viewWidth: 320, viewHeight: 300)
        AdService.sharedWithoutInit().bannerAdInit(containerView: bannerView3, rootVC: self, viewWidth: 320, viewHeight: 50)
        
    }
}

