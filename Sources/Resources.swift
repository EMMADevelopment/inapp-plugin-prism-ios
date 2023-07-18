//
//  Resources.swift
//  EMMAInAppPlugin-Prism
//
//  Created by Adrián Carrera on 18/7/23.
//

import Foundation


public var overrideResourceBundle: Bundle?

private class BundleFinder {}

/// UI resources bundle.
var resourcesBundle: Bundle? = {
  // Use overriden resource bundle
  if let overrideResourceBundle = overrideResourceBundle {
    return overrideResourceBundle
  }

  let bundleNames = [
    // SwiftPM source target resources
    "EMMAInAppPlugin-Prism_EMMAInAppPlugin-Prism",
    // Cocoapods or prebuilt resources
    "EMMAInAppPlugin-Prism",
  ]

  let candidates = [
    // Bundle should be present here when the package is linked into an App.
    Bundle.main.resourceURL,
    // Bundle should be present here when the package is linked into a framework.
    Bundle(for: BundleFinder.self).resourceURL,
    // For command-line tools.
    Bundle.main.bundleURL,
  ]

  for bundleName in bundleNames {
    for candidate in candidates {
      let bundlePath = candidate?.appendingPathComponent(bundleName + ".bundle")
      if let bundle = bundlePath.flatMap(Bundle.init(url:)) {
        return bundle
      }
    }
  }

  print(
    "Error: Unable to find  resources bundle."
  )
  return nil
}()
