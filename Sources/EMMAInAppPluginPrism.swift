import EMMA_iOS

@objcMembers
public class EMMAInAppPluginPrism: EMMAInAppPlugin {
    let fakeData = true
    
    public override init() {
        super.init()
    }
    
    public func getType() -> String {
        return "emma_plugin_prism"
    }
    
    public func show(_ nativeAd: EMMANativeAd) {
        DispatchQueue.main.async {
            if let rootViewController = EMMA.rootViewController() {
                let prism = self.convertNativeAdToPrism(nativeAd)
                let prismViewController = EMMAPrismViewController()
                prismViewController.prism = prism
                prismViewController.modalPresentationStyle = .overFullScreen
                prismViewController.view.bounds = rootViewController.view.bounds
                rootViewController.present(prismViewController, animated: true, completion: nil)
            }
        }
    }
    
    func getFakeData() -> EMMAPrism {
        let prismSide1 = EMMAPrismSide(image: "https://i.picsum.photos/id/586/300/700.jpg?hmac=TKBELClTbUvaXq5NHUpCVnnhssZ3tYTSLTYBi6rPo5Q",
                                       cta: "https://google.es")
        
        let prismSide2 = EMMAPrismSide(image: "https://i.picsum.photos/id/666/300/700.jpg?hmac=mXEaSU1_1gEAtK3z-beAT7GyWGt8oYsa34QOXLBx-qY",
                                       cta: "https://emma.io")
        
        return EMMAPrism(campaignId: 123456, openInApp: true, canClose: true, sides:[prismSide1, prismSide2])
    }
    
    func createPrismSide(fields: [String: String]) -> EMMAPrismSide? {
        guard let image = fields["Main Picture"], !image.isEmpty, let cta = fields["CTA"], !cta.isEmpty else {
            return nil
        }
        
        return EMMAPrismSide(image: image, cta: cta)
    }

    func convertNativeAdToPrism(_ nativeAd: EMMANativeAd) -> EMMAPrism{
        if(fakeData) {
            return getFakeData()
        }
        
        var sides = [EMMAPrismSide]()
        let campaignId = nativeAd.idPromo
        let openInApp = !nativeAd.openInSafari
        let content = nativeAd.nativeAdContent
        
        if let container = content?["Container"] as? Array<[String: String]> {
            container.forEach { (containerFields: [String : String]) in
                if let prismSide = createPrismSide(fields: containerFields) {
                    sides.append(prismSide)
                }
            }
        }
        
        return EMMAPrism(campaignId: campaignId,
                         openInApp: openInApp, canClose: true, sides: sides)
    }
    
    public func dismiss() {
        
    }
}