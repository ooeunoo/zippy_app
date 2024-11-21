import Flutter
import google_mobile_ads

class CardAdFactory: NSObject, FLTNativeAdFactory {
    func createNativeAd(_ nativeAd: GADNativeAd,
                       customOptions: [AnyHashable : Any]? = nil) -> GADNativeAdView? {
        let nibView = Bundle.main.loadNibNamed("CardAdView", owner: nil, options: nil)!.first
        let nativeAdView = nibView as! GADNativeAdView

        // MediaView 설정
        if let mediaView = nativeAdView.mediaView {
            mediaView.contentMode = .scaleToFill  // 이미지가 컨테이너를 꽉 채우도록 설정
            mediaView.clipsToBounds = true
        }

        // 광고주 정보
        (nativeAdView.advertiserView as? UILabel)?.text = nativeAd.advertiser
        nativeAdView.advertiserView?.isHidden = nativeAd.advertiser == nil

        // 아이콘
        (nativeAdView.iconView as? UIImageView)?.image = nativeAd.icon?.image
        nativeAdView.iconView?.isHidden = nativeAd.icon == nil

        // 헤드라인
        (nativeAdView.headlineView as? UILabel)?.text = nativeAd.headline

        // 본문
        (nativeAdView.bodyView as? UILabel)?.text = nativeAd.body
        nativeAdView.bodyView?.isHidden = nativeAd.body == nil

        nativeAdView.nativeAd = nativeAd

        return nativeAdView
    }
}
