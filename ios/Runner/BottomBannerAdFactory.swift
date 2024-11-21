import Flutter
import google_mobile_ads

class BottomBannerAdFactory: NSObject, FLTNativeAdFactory {
    func createNativeAd(_ nativeAd: GADNativeAd,
                       customOptions: [AnyHashable : Any]? = nil) -> GADNativeAdView? {
        let nibView = Bundle.main.loadNibNamed("BottomBannerAdView", owner: nil, options: nil)?.first
        guard let nativeAdView = nibView as? GADNativeAdView else { return nil }
        
        // 헤드라인 설정
        (nativeAdView.headlineView as? UILabel)?.text = nativeAd.headline
        
        // Native Ad 할당
        nativeAdView.nativeAd = nativeAd
        
        return nativeAdView
    }
}
