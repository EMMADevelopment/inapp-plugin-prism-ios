//
//  PrismViewController.swift
//  EMMAInAppPlugin-Prism
//
//  Created by Adrián Carrera on 22/02/2021.
//

import Foundation
import UIKit
import EMMA_iOS

class PrismViewController: UIViewController {
    var prism: Prism? = nil
    var prismView: PrismView!
    var nativeAd: EMMANativeAd!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.isOpaque = false
        view.backgroundColor = UIColor.clear
        
        prismView = PrismView()
        preparePrismView()
    }
    
    func viewHeight () -> CGFloat {
        return view.bounds.height * 0.6
    }
    
    func viewWidth () -> CGFloat {
        return view.bounds.width * 0.7
    }
    
    @objc func closeButtonAction() {
        dismiss(animated: false, completion: nil)
    }
    
    @objc func ctaButtonAction(sender: UIButton) {
        EMMAInAppPluginPrism.sendClick(campaign: nativeAd)
        if let url = URL(string: prism!.sides[sender.tag].cta) {
            let webViewController = EMMAWebViewController()
            if #available(iOS 13.0, *) {
                webViewController.isModalInPresentation = true;
            }
            webViewController.url = url
            webViewController.modalPresentationStyle = .overFullScreen
            self.present(webViewController, animated: true, completion: nil)
        }
    }
    
    @objc func nextSideAction(sender: UIButton) {
        prismView?.scrollToView(sender.tag, direction: .right)
    }
    
    @objc func previousSideAction(sender: UIButton) {
        prismView?.scrollToView(sender.tag, direction: .left)
    }
    
    func createControlButtonToView(name: String, action: Selector, size: CGFloat, pos: Int) -> UIButton {
        
        let img = UIImage(named: name,
                                  in: Bundle.init(for: self.classForCoder), compatibleWith: nil)
        
        let controlButton = UIButton(type: .custom)
        controlButton.addTarget(self, action:action, for: .touchUpInside)
        controlButton.tag = pos
        controlButton.setImage(img, for: .normal)
        controlButton.translatesAutoresizingMaskIntoConstraints = false
        
        return controlButton
    }
    
    func addButtons(toView: UIView, atPos: Int) {
        let buttonSize: CGFloat = 30
        
        let closeButton = UIButton(frame: CGRect(x: viewWidth() - buttonSize  , y:0 , width:buttonSize , height: buttonSize))
        closeButton.tintColor = .white
        closeButton.setTitle("x", for: .normal)
        closeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22.0)
        closeButton.addTarget(self, action: #selector(closeButtonAction), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false

        let closeButtonConstraints = [
            closeButton.heightAnchor.constraint(equalToConstant: buttonSize),
            closeButton.widthAnchor.constraint(equalToConstant: buttonSize),
            closeButton.trailingAnchor.constraint(equalTo: toView.trailingAnchor)
        ]

        toView.addSubview(closeButton)
        NSLayoutConstraint.activate(closeButtonConstraints)

        if (!prism!.sides[atPos].cta.isEmpty) {
            let ctaButton = createControlButtonToView(name:"prism_cta_btn" , action: #selector(ctaButtonAction),
                                                      size: buttonSize, pos:atPos)

            toView.addSubview(ctaButton)

            let ctaButtonConstraints = [
                ctaButton.heightAnchor.constraint(equalToConstant: buttonSize),
                ctaButton.widthAnchor.constraint(equalToConstant: buttonSize),
                ctaButton.centerXAnchor.constraint(equalTo: toView.centerXAnchor),
                ctaButton.bottomAnchor.constraint(equalTo: toView.bottomAnchor),
            ]

            NSLayoutConstraint.activate(ctaButtonConstraints)
        }
        
        if (prism!.sides.count > 1) {
            let rightButton = createControlButtonToView(name:"prism_right_btn" , action: #selector(nextSideAction),
                                      size: buttonSize, pos:atPos)
            
            let leftButton = createControlButtonToView(name:"prism_left_btn" , action: #selector(previousSideAction),
                                      size: buttonSize, pos:atPos)
            
            
            toView.addSubview(rightButton)
            toView.addSubview(leftButton)
            
            let constraints = [
                rightButton.heightAnchor.constraint(equalToConstant: buttonSize),
                leftButton.heightAnchor.constraint(equalToConstant: buttonSize),
                rightButton.widthAnchor.constraint(equalToConstant: buttonSize),
                leftButton.widthAnchor.constraint(equalToConstant: buttonSize),
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
            imageView.contentMode = UIView.ContentMode.scaleToFill
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
                    return
                }
                self.addImage(data: data, toView: view)
            }).resume()
        }
    }
    
    func preparePrismSideView(side: PrismSide, position: Int) -> UIView {
        let sideView = UIView()
        downloadImageContent(view: sideView, url: side.image)
        addButtons(toView: sideView, atPos: position)
        return sideView
    }
    
    func preparePrismView() {
        if let prism = prism{
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

            EMMAInAppPluginPrism.sendImpression(campaign: nativeAd)
        }
    }
}
