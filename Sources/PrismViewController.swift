//
//  PrismViewController.swift
//  EMMAInAppPlugin-Prism
//
//  Created by Adrián Carrera on 22/02/2021.
//

import Foundation
import UIKit
import EMMA_iOS

class PrismViewController: UIViewController, WebViewProtocol {
    var prism: Prism? = nil
    var prismView: PrismView!
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.isOpaque = false
        view.backgroundColor = UIColor.clear
        
        NotificationCenter.default.addObserver(self,selector: #selector(willEnterInForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        prismView = PrismView()
        preparePrismView()
    }
    
    @objc func willEnterInForeground() {
        prismView?.reset()
    }
    
    func viewHeight () -> CGFloat {
        return view.bounds.height * 0.6
    }
    
    func viewWidth () -> CGFloat {
        return view.bounds.width * 0.7
    }
    
    @objc func closeAction() {
        EMMAInAppPluginPrism.invokeCloseDelegates(campaign: prism!.campaign)
        dismiss(animated: false, completion: nil)
    }
    
    func onDeepLinkOpened() {
        closeAction()
    }
    
    private func openInApp(url: URL) {
        if DeepLinkManager.isDeeplink(url: url) {
            DeepLinkManager.open(url: url)
            onDeepLinkOpened()
            return
        }
        
        let webViewController = EMMAWebViewController()
        if #available(iOS 13.0, *) {
            webViewController.isModalInPresentation = true;
        }
        webViewController.url = url
        webViewController.modalPresentationStyle = .overFullScreen
        self.present(webViewController, animated: true, completion: nil)
    }
    
    private func openOutApp(url: URL) {
        if DeepLinkManager.isDeeplink(url: url) {
            DeepLinkManager.open(url: url)
            onDeepLinkOpened()
            return
        }
        
        Utils.openUrl(url: url)
    }
    
    @objc func ctaButtonAction(sender: UIButton) {
        EMMAInAppPluginPrism.sendClick(campaign: prism!.campaign)
        let prismSide = prism!.sides[sender.tag]
        if let url = URL(string: prismSide.cta) {
            if (prism!.openInApp) {
                openInApp(url: url)
            } else {
                openOutApp(url: url)
            }
        }
    }
    
    @objc func nextSideAction(sender: UIButton) {
        prismView?.scrollToView(sender.tag, direction: .right)
    }
    
    @objc func previousSideAction(sender: UIButton) {
        prismView?.scrollToView(sender.tag, direction: .left)
    }
    
    func createControlButtonToView(name: String, action: Selector, pos: Int) -> UIButton {
        let img = UIImage(named: name,
                                  in: resourcesBundle, compatibleWith: nil)
        
        let controlButton = UIButton(type: .custom)
        controlButton.addTarget(self, action:action, for: .touchUpInside)
        controlButton.tag = pos
        controlButton.setImage(img, for: .normal)
        controlButton.translatesAutoresizingMaskIntoConstraints = false
        
        return controlButton
    }
    
    @objc func closeButton() {
        EMMAInAppPluginPrism.sendDismissedClick(campaign: prism!.campaign)
        closeAction()
    }
    
    func addButtons(toView: UIView, atPos: Int) {
        let closeButton = createControlButtonToView(name:"prism_close_btn",
                                                    action: #selector(closeButton), pos:atPos)

        let closeButtonConstraints = [
            closeButton.topAnchor.constraint(equalTo: toView.topAnchor, constant: 5.0),
            closeButton.trailingAnchor.constraint(equalTo: toView.trailingAnchor, constant: -5.0)
        ]

        toView.addSubview(closeButton)
        NSLayoutConstraint.activate(closeButtonConstraints)

        if (!prism!.sides[atPos].cta.isEmpty) {
            let ctaButton = createControlButtonToView(name:"prism_cta_btn" ,
                                                      action: #selector(ctaButtonAction), pos:atPos)

            toView.addSubview(ctaButton)

            let ctaButtonConstraints = [
                ctaButton.centerXAnchor.constraint(equalTo: toView.centerXAnchor),
                ctaButton.bottomAnchor.constraint(equalTo: toView.bottomAnchor, constant: -5.0),
            ]

            NSLayoutConstraint.activate(ctaButtonConstraints)
        }
        
        if (prism!.sides.count > 1) {
            let rightButton = createControlButtonToView(name:"prism_right_btn",
                                                        action: #selector(nextSideAction), pos:atPos)
            
            let leftButton = createControlButtonToView(name:"prism_left_btn" ,
                                                       action: #selector(previousSideAction), pos:atPos)
            
            
            toView.addSubview(rightButton)
            toView.addSubview(leftButton)
            
            let constraints = [
                rightButton.centerYAnchor.constraint(equalTo: toView.centerYAnchor),
                leftButton.centerYAnchor.constraint(equalTo: toView.centerYAnchor),
                rightButton.trailingAnchor.constraint(equalTo: toView.trailingAnchor),
                leftButton.leadingAnchor.constraint(equalTo: toView.leadingAnchor),
            ]
            
            NSLayoutConstraint.activate(constraints)
        }
    }
    
    func addImage(data: Data, toView: UIView) {
        DispatchQueue.main.async() {
            toView.backgroundColor = UIColor.green
            let image = UIImage(data: data as Data)
            
            let imageView = UIImageView(frame: toView.frame)
            imageView.center = toView.center
            imageView.image = image
            imageView.contentMode = UIView.ContentMode.scaleAspectFill
            toView.addSubview(imageView)
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
           
            let constraints = [
                imageView.topAnchor.constraint(equalTo: toView.topAnchor),
                imageView.bottomAnchor.constraint(equalTo: toView.bottomAnchor),
                imageView.leadingAnchor.constraint(equalTo: toView.leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: toView.trailingAnchor)
            ]
            
            NSLayoutConstraint.activate(constraints)
            
            toView.sendSubviewToBack(imageView)
        }
    }
    
    func downloadImageContent(view: UIView, url: String) {
        if let imageUrl = URL(string: url) {
            URLSession.shared.dataTask(with: imageUrl, completionHandler: { data, response, error in
                guard let data = data, error == nil else {
                    Utils.log(msg: "Cannot download image \(url)")
                    return
                }
                self.addImage(data: data, toView: view)
            }).resume()
        }
    }
    
    func preparePrismSideView(side: PrismSide, position: Int) -> UIView {
        let sideView = UIView()
        sideView.backgroundColor = UIColor.white
        downloadImageContent(view: sideView, url: side.image)
        addButtons(toView: sideView, atPos: position)
        return sideView
    }
    
    func preparePrismView() {
        if let prism = prism {
            var sidesViews = [UIView]()
            
            for (index, side) in prism.sides.enumerated() {
                sidesViews.append(preparePrismSideView(side: side, position: index))
            }

            prismView.addPrismSides(sidesViews)
            view.addSubview(prismView)
            prismView.translatesAutoresizingMaskIntoConstraints = false

            var viewCenterXAnchor = view.centerXAnchor
            var viewCenterYAnchor = view.centerYAnchor
            if #available(iOS 11.0, *) {
                viewCenterXAnchor = view.safeAreaLayoutGuide.centerXAnchor
                viewCenterYAnchor = view.safeAreaLayoutGuide.centerYAnchor
            }
            
            let constraints = [
                prismView.centerXAnchor.constraint(equalTo: viewCenterXAnchor),
                prismView.centerYAnchor.constraint(equalTo: viewCenterYAnchor),
                prismView.widthAnchor.constraint(equalToConstant: viewWidth()),
                prismView.heightAnchor.constraint(equalToConstant: viewHeight()),
            ]
        
            NSLayoutConstraint.activate(constraints)
            
            prismView.layoutIfNeeded()
            
            prismView.contentOffset = CGPoint(x:prismView.bounds.width, y:0)
            prismView.isHidden = false

            EMMAInAppPluginPrism.invokeShownDelegates(campaign: prism.campaign)
            EMMAInAppPluginPrism.sendImpression(campaign: prism.campaign)
        }
    }
}
