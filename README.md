# inapp-plugin-prism-ios

## INTRODUCTION

Plugin for EMMA in-app communication. This plugin shows a prism with 10 sides as maximum. 

You can create your own plugin through native ad engine.

## INSTALLATION

**Version 4.9.0+ of EMMA SDK and Xcode 12+ is required**

For integrate this plugin you can download with Swift Package Manager:

1. Open Xcode and select File > Swift Packages > Add Package Dependency
2. Add the repo url and select version 4.9.0+ as minimum or master branch

## INTEGRATION

Import the library in AppDelegate and add plugin class to SDK.

``` swift
 import EMMAInAppPlugin_Prism
 
 func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      ....
      EMMA.startSession(with: configuration)
      EMMA.addInAppPlugin([EMMAInAppPluginPrism()])
      return true
  }
```

In a ViewController request the available prism (If there are many prism avaiable only is showed the latest created).

``` swift
import UIKit

class HomeViewController: UIViewController {
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
	 let nativeAdRequest = EMMANativeAdRequest()
	 nativeAdRequest.templateId = "emma-plugin-prisma"
	 EMMA.inAppMessage(request: nativeAdRequest)
   }
}

```
