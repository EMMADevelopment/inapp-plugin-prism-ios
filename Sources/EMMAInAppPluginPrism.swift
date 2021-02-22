import EMMA_iOS

@objcMembers
public class EMMAInAppPluginPrism: EMMAInAppPlugin {
    public func getType() -> String {
        return "emma_plugin_prism"
    }
    
    public func show(_ nativeAd: EMMANativeAd) {
        DispatchQueue.main.async {
            if let rootViewController = EMMAViewUtils.getRootViewController() {
                if #available(iOS 13.0, *) {
                    rootViewController.isModalInPresentation = true
                }

                rootViewController.modalPresentationStyle = .overFullScreen
                
                let prismViewController = EMMAPrismViewController()
                rootViewController.present(prismViewController, animated: true, completion: nil)
            }
            
        }
    }
    
    public func dismiss() {
        
    }
}
