//
//  AdService.swift
//  googleAdMob
//
//  Created by 이유리 on 17/10/2019.
//  Copyright © 2019 이유리. All rights reserved.
//

import Foundation
import GoogleMobileAds

class AdService: NSObject {
    
    private static var sharedService : AdService = {
        let service = AdService()
        return service
    }()
    
    class func shared() -> AdService{
        sharedService.serviceInit()
        return sharedService
    }
    
    
    func serviceInit(){
    }
    
    class func sharedWithoutInit() -> AdService{
        return sharedService
    }
    
    static let bannerAdId       = "ca-app-pub-3940256099942544/2934735716"
    static let interstitialAdId = "ca-app-pub-3940256099942544/5135589807"
    static let nativeAdId       = "ca-app-pub-3940256099942544/3986624511"
    
    let dispatchGroupArr = [DispatchGroup(), DispatchGroup(), DispatchGroup()]

    // 전면 광고
    var interstitialView: GADInterstitial!
    
    // 네이티브 광고
    var adLoader: GADAdLoader!
    var nativeAdView: GADUnifiedNativeAdView!
    var heightConstraint : NSLayoutConstraint?
}

// 배너 광고
extension AdService : GADBannerViewDelegate {
    
    func bannerAdInit(containerView : UIView, rootVC: UIViewController, viewWidth: Int, viewHeight: Int) {
        
        let bannerView: GADBannerView = GADBannerView()
        
        bannerView.adSize = GADAdSizeFromCGSize(CGSize(width: viewWidth, height: viewHeight))
        bannerView.rootViewController = rootVC
        bannerView.adUnitID = AdService.bannerAdId
        bannerView.load(GADRequest())
        bannerView.delegate = self
        
        containerView.addSubview(bannerView)
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("adViewDidReceiveAd")
    }
    
}

// 전면 광고
extension AdService : GADInterstitialDelegate {
    
    func interstitialAdInit() {        
        interstitialView = GADInterstitial(adUnitID: AdService.interstitialAdId)
        interstitialView.delegate = self
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID] as? [String]
        interstitialView.load(request)
    }
    
    func presentInterstitialAd(rootVC: UIViewController) {
        
        if interstitialView.isReady {
            interstitialView.present(fromRootViewController: rootVC)
        } else {
            print("Ad wasn't ready")
        }
        
    }
    
    // 전면 광고를 닫은 후, 다시 클릭했을때 광고 뜨게 하기 위함
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        print("interstitialDidDismissScreen")
        interstitialAdInit()
    }
    
}

// 네이티브 광고
extension AdService : GADUnifiedNativeAdLoaderDelegate, GADAdLoaderDelegate, GADUnifiedNativeAdDelegate, GADVideoControllerDelegate {
    
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADUnifiedNativeAd) {
        
        nativeAdView.nativeAd = nativeAd
        nativeAd.delegate = self
        heightConstraint?.isActive = false
        nativeAd.mediaContent.videoController.delegate = self
        
        if let controller = nativeAd.videoController, controller.hasVideoContent() {
            controller.delegate = self
        }
        else {
        }

        if let mediaView = nativeAdView.mediaView, nativeAd.mediaContent.aspectRatio > 0 {
            heightConstraint = NSLayoutConstraint(item: mediaView,
                                                  attribute: .height,
                                                  relatedBy: .equal,
                                                  toItem: mediaView,
                                                  attribute: .width,
                                                  multiplier: CGFloat(1 / nativeAd.mediaContent.aspectRatio),
                                                  constant: 0)
            heightConstraint?.isActive = true
        }

        (nativeAdView.headlineView as? UILabel)?.text = nativeAd.headline
        
        nativeAdView.mediaView?.mediaContent = nativeAd.mediaContent
        nativeAdView.mediaView?.accessibilityContainerType

        (nativeAdView.bodyView as? UILabel)?.text = nativeAd.body
        nativeAdView.bodyView?.isHidden = nativeAd.body == nil
        
        (nativeAdView.callToActionView as? UIButton)?.setTitle(nativeAd.callToAction, for: .normal)
        nativeAdView.callToActionView?.isHidden = nativeAd.callToAction == nil
        
        (nativeAdView.iconView as? UIImageView)?.image = nativeAd.icon?.image
        nativeAdView.iconView?.isHidden = nativeAd.icon == nil
        
        nativeAdView.callToActionView?.isUserInteractionEnabled = false
    }
    
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: GADRequestError) {
        
    }
    
    func nativeAdInit(containerView : UIView, setAdView: GADUnifiedNativeAdView, rootVC: UIViewController) {
        
        adLoader = GADAdLoader(adUnitID: AdService.nativeAdId, rootViewController: rootVC,
                               adTypes: [ .unifiedNative ], options: nil)
        adLoader.delegate = self
        adLoader.load(GADRequest())
        
        nativeAdView = setAdView
        containerView.addSubview(nativeAdView)
        
        nativeAdView.translatesAutoresizingMaskIntoConstraints = false

        let viewDictionary = ["_nativeAdView": nativeAdView!]
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[_nativeAdView]|",
                                                                     options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewDictionary))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[_nativeAdView]|",
                                                                    options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewDictionary))
        
    }
    
}
