//
//  EMMAPrismViewController.swift
//  EMMAInAppPlugin-Prism
//
//  Created by Adrián Carrera on 22/02/2021.
//

import Foundation
import UIKit

class EMMAPrismViewController: UIViewController {
    
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
    
    func preparePrismSideView1() -> UIView {
        let sideView = UIView()
        sideView.backgroundColor = .black
        let imageUrl = "https://loremflickr.com/cache/resized/65535_50548788002_44d63fb407_b_320_700_nofilter.jpg"
        downloadImageContent(view: sideView, url: imageUrl)
        return sideView
    }
    
    func preparePrismSideView2() -> UIView {
        let sideView = UIView()
        sideView.backgroundColor = .white
        let imageUrl = "https://loremflickr.com/cache/resized/65535_50488056162_04ebb8bd48_b_320_700_nofilter.jpg"
        downloadImageContent(view: sideView, url: imageUrl)
        return sideView
    }
    
    func preparePrismView() {
        let prismView = EMMAPrismView()
        //let prismView = UIView()
        let sides = [preparePrismSideView1(), preparePrismSideView2()]
        prismView.addPrismSides(sides)
        view.addSubview(prismView)
        prismView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            prismView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            prismView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            prismView.widthAnchor.constraint(equalToConstant: 250.0),
            prismView.heightAnchor.constraint(equalToConstant: 400.0),
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        /*NSLayoutConstraint(item: prismView, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: prismView, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: prismView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 250).isActive = true
        NSLayoutConstraint(item: prismView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 400).isActive = true*/

    }
    
}
