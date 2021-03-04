import EMMA_iOS

@objcMembers
public class EMMAInAppPluginPrism: EMMAInAppPlugin {
    
    public override init() {
        super.init()
    }
    
    public func getId() -> String {
        return "emma-plugin-prism"
    }
    
    public func show(_ nativeAd: EMMANativeAd) {
        if (EMMA.getSDKBuildVersion() < 108) {
            Utils.log(msg: "This plugin requires EMMA SDK >= 4.9.0")
            return
        }
            
        DispatchQueue.main.async {
            if let rootViewController = EMMA.rootViewController() {
                let prism = self.convertNativeAdToPrism(nativeAd)
                let prismViewController = PrismViewController()
                
                if #available(iOS 13.0, *) {
                    prismViewController.isModalInPresentation = true
                }
                
                prismViewController.prism = prism
                prismViewController.modalPresentationStyle = .overFullScreen
                prismViewController.view.bounds = rootViewController.view.bounds
                rootViewController.present(prismViewController, animated: true, completion: nil)
            }
        }
    }
    
    private func createPrismSide(fields: [String: String]) -> PrismSide? {
        guard let image = fields["Main picture"], !image.isEmpty, let cta = fields["CTA"] else {
            return nil
        }
        return PrismSide(image: image, cta: cta)
    }

    private func convertNativeAdToPrism(_ nativeAd: EMMANativeAd) -> Prism {
        var sides = [PrismSide]()
        let openInApp = !nativeAd.openInSafari
        let content = nativeAd.nativeAdContent
        
        if let container = content?["Container"] as? Array<[String: String]> {
            container.forEach { (containerFields: [String : String]) in
                if let prismSide = createPrismSide(fields: containerFields) {
                    sides.append(prismSide)
                }
            }
        }
        
        return Prism(campaign: nativeAd,
                         openInApp: openInApp, canClose: true, sides: sides)
    }
    
    public func dismiss() {
    }
}
