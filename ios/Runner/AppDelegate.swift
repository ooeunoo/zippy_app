// AppDelegate.swift
import UIKit
import Flutter
import google_mobile_ads

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)

        let cardFactory = CardAdFactory()
        FLTGoogleMobileAdsPlugin.registerNativeAdFactory(
            self, factoryId: "cardAd", nativeAdFactory: cardFactory)

        // 새로운 bottomBannerAdFactory 등록
       let bottomBannerFactory = BottomBannerAdFactory()
        FLTGoogleMobileAdsPlugin.registerNativeAdFactory(
            self,
            factoryId: "bottomBannerAd",  
            nativeAdFactory: bottomBannerFactory)

        // Replace with your actual test device ID
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = ["YOUR_TEST_DEVICE_ID"]

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
