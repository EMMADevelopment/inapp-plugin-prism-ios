//
//  EMMAPrismViewController.swift
//  EMMAInAppPlugin-Prism
//
//  Created by Adrián Carrera on 22/02/2021.
//

import Foundation
import UIKit

class EMMAPrismViewController: UIViewController {
    var prism: EMMAPrism? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.isOpaque = false
        view.backgroundColor = UIColor.clear
        
        preparePrismView()
    }
    
    func addImage(data: Data, toView: UIView) {
        DispatchQueue.main.async() {
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
    
    func preparePrismSideView(side: EMMAPrismSide) -> UIView {
        let sideView = UIView()
        downloadImageContent(view: sideView, url: side.image)
        return sideView
    }
    
    func preparePrismView() {
        if let prism = prism {
            let prismView = EMMAPrismView()
            
            var sidesViews = [UIView]()
            prism.sides.forEach { (side: EMMAPrismSide) in
                sidesViews.append(preparePrismSideView(side: side))
            }
            
            prismView.addPrismSides(sidesViews)
            view.addSubview(prismView)
            prismView.translatesAutoresizingMaskIntoConstraints = false
            
            let constraints = [
                prismView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                prismView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                prismView.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.7),
                prismView.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.6),
            ]
        
            NSLayoutConstraint.activate(constraints)
            
            prismView.layoutIfNeeded()
            
            prismView.contentOffset = CGPoint(x:prismView.bounds.width, y:0)
            prismView.isHidden = false
        }
    }
}
