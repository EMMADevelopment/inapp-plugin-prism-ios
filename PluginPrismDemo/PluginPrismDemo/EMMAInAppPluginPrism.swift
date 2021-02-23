import EMMA_iOS

@objcMembers
public class EMMAInAppPluginPrism: EMMAInAppPlugin {
    
    public override init() {
        super.init()
    }
    
    public func getType() -> String {
        return "emma_plugin_prism"
    }
    
    public func show(_ nativeAd: EMMANativeAd) {
        DispatchQueue.main.async {
            if let rootViewController = EMMAViewUtils.getRootViewController() {
                let prismViewController = EMMAPrismViewController()
                prismViewController.modalPresentationStyle = .overCurrentContext
                prismViewController.view.bounds = rootViewController.view.bounds
                rootViewController.present(prismViewController, animated: true, completion: nil)
            }
            
        }
    }
    
    public func dismiss() {
        
    }
}
