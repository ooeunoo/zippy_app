import Flutter
import google_mobile_ads

class BottomBannerAdFactory: NSObject, FLTNativeAdFactory, GADNativeAdDelegate {
    func createNativeAd(_ nativeAd: GADNativeAd,
                       customOptions: [AnyHashable : Any]? = nil) -> GADNativeAdView? {
        let nibView = Bundle.main.loadNibNamed("BottomBannerAdView", owner: nil, options: nil)?.first
        guard let nativeAdView = nibView as? GADNativeAdView else {
            return nil
        }

        // Set ourselves as the native ad delegate to be notified of native ad events.
        nativeAd.delegate = self
       
        // Populate the native ad view with the native ad assets.
        // The headline is guaranteed to be present in every native ad.
        (nativeAdView.headlineView as! UILabel).text = nativeAd.headline

        // Native Ad 할당
        nativeAdView.nativeAd = nativeAd
        
        return nativeAdView
    }
}
