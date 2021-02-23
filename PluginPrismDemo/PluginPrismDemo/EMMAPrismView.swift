//
//  EMMAPrismView.swift
//  
//
//  Created by Adrián Carrera on 22/02/2021.
//

import UIKit

/*@available(iOS 9.0, *)
@objc protocol EMMAPrismViewDelegate: class {
    
    @objc optional func cubeViewDidScroll(_ cubeView: EMMAPrismView)
}*/

@available(iOS 9.0, *)
class EMMAPrismView: UIScrollView, UIScrollViewDelegate {
    
    //weak var cubeDelegate: EMMAPrismViewDelegate?
    
    fileprivate let maxAngle: CGFloat = 60.0
    
    fileprivate var prismSideViews = [UIView]()
    
    fileprivate lazy var stackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = NSLayoutConstraint.Axis.horizontal
        return sv
    }()
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        configureScrollView()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configureScrollView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    open func addPrismSides(_ views: [UIView]) {
        for view in views {
            view.layer.masksToBounds = true
            stackView.addArrangedSubview(view)
            
            addConstraint(view.widthAnchor.constraint(equalTo: widthAnchor))
            
            prismSideViews.append(view)
        }
    }
    
    open func addPrismSide(_ view: UIView) {
        addPrismSides([view])
    }
    
    open func scrollToViewAtIndex(_ index: Int, animated: Bool) {
        if index > -1 && index < prismSideViews.count {
            
            let width = self.frame.size.width
            let height = self.frame.size.height
            
            let frame = CGRect(x: CGFloat(index)*width, y: 0, width: width, height: height)
            scrollRectToVisible(frame, animated: animated)
        }
    }
    
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        transformViewsInScrollView(scrollView)
        //cubeDelegate?.cubeViewDidScroll?(self)
    }
    
    fileprivate func configureScrollView() {
        backgroundColor = UIColor.white
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        isPagingEnabled = true
        bounces = false
        delegate = self
        
        addSubview(stackView)
        
        let constraints = [
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.heightAnchor.constraint(equalTo: heightAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    fileprivate func transformViewsInScrollView(_ scrollView: UIScrollView) {
        
        let xOffset = scrollView.contentOffset.x
        let svWidth = scrollView.frame.width
        var deg = maxAngle / bounds.size.width * xOffset
        
        for index in 0 ..< prismSideViews.count {
            
            let view = prismSideViews[index]
            
            deg = index == 0 ? deg : deg - maxAngle
            let rad = deg * CGFloat(Double.pi / 180)
            
            var transform = CATransform3DIdentity
            transform.m34 = 1 / 500
            transform = CATransform3DRotate(transform, rad, 0, 1, 0)
            
            view.layer.transform = transform
            
            let x = xOffset / svWidth > CGFloat(index) ? 1.0 : 0.0
            setAnchorPoint(CGPoint(x: x, y: 0.5), forView: view)
        }
    }
    
    fileprivate func setAnchorPoint(_ anchorPoint: CGPoint, forView view: UIView) {
        
        var newPoint = CGPoint(x: view.bounds.size.width * anchorPoint.x, y: view.bounds.size.height * anchorPoint.y)
        var oldPoint = CGPoint(x: view.bounds.size.width * view.layer.anchorPoint.x, y: view.bounds.size.height * view.layer.anchorPoint.y)
        
        newPoint = newPoint.applying(view.transform)
        oldPoint = oldPoint.applying(view.transform)
        
        var position = view.layer.position
        position.x -= oldPoint.x
        position.x += newPoint.x
        
        position.y -= oldPoint.y
        position.y += newPoint.y
        
        view.layer.position = position
        view.layer.anchorPoint = anchorPoint
    }
    
    fileprivate func frameFor(origin: CGPoint, size: CGSize) -> CGRect {
        return CGRect(x: origin.x, y: origin.y, width: size.width, height: size.height)
    }
}
