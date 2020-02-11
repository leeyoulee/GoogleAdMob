//
//  NativeViewController.swift
//  googleAdMob
//
//  Created by 이유리 on 17/10/2019.
//  Copyright © 2019 이유리. All rights reserved.
//

import UIKit
import GoogleMobileAds

class NativeViewController: UIViewController {

    @IBOutlet weak var nativeAdView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let nibObjects = Bundle.main.loadNibNamed("NativeAd", owner: nil, options: nil),
            let adView = nibObjects.first as? GADUnifiedNativeAdView else {
                assert(false, "Could not load nib file for adView")
        }
        
        AdService.sharedWithoutInit().nativeAdInit(containerView : nativeAdView, setAdView: adView, rootVC: self)
    }
    
}
