//
//  PrismView.swift
//  
//
//  Created by Adrián Carrera on 22/02/2021.
//

import UIKit


enum PrismDirection {
    case right, left
}

@available(iOS 9.0, *)
class PrismView: UIScrollView {
    private let maxAngle: CGFloat = 60.0
    private var prismSideViews = [UIView]()
   
    private lazy var stackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = NSLayoutConstraint.Axis.horizontal
        return sv
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureScrollView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureScrollView()
    }
    
    func reset() {
        for view in stackView.subviews {
            view.layer.anchorPoint = CGPoint(x:0.5, y:0.5)
            view.layer.transform.m34 = 0.0
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }

    func addPrismSides(_ views: [UIView]) {
        for view in views {
            view.layer.masksToBounds = true
            stackView.addArrangedSubview(view)
            
            addConstraint(view.widthAnchor.constraint(equalTo: widthAnchor))

            prismSideViews.append(view)
        }
    }
    
    func addPrismSide(_ view: UIView) {
        addPrismSides([view])
    }
    
    func scrollToView(_ currentIndex: Int, direction: PrismDirection) {
        let width = self.frame.size.width
        let height = self.frame.size.height
        
        if (currentIndex == 0 && direction == .left) {
            contentOffset = CGPoint(x: width * CGFloat(prismSideViews.count - 2), y: contentOffset.y)
            let frame = CGRect(x: width * CGFloat(prismSideViews.count - 3), y: 0, width: width, height: height)
            scrollRectToVisible(frame ,animated: true)
        } else if (currentIndex == prismSideViews.count - 1 && direction == .right) {
            contentOffset = CGPoint(x: width, y: contentOffset.y)
            let frame = CGRect(x: width*2, y: 0, width: width, height: height)
            scrollRectToVisible(frame ,animated: true)
        } else if (direction == .left) {
            contentOffset = CGPoint(x: width * CGFloat(currentIndex), y: contentOffset.y)
            let frame = CGRect(x: (width * CGFloat(currentIndex)) - width, y: 0, width: width, height: height)
            scrollRectToVisible(frame ,animated: true)
        } else {
            contentOffset = CGPoint(x: width * CGFloat(currentIndex), y: contentOffset.y)
            let frame = CGRect(x: (width * CGFloat(currentIndex)) + width, y: 0, width: width, height: height)
            scrollRectToVisible(frame ,animated: true)
        }
    }

    private func resetScrollViewOffsetIfNeeded(_ scrollView: UIScrollView) {
        let currentPage = currentScrollViewIndex(scrollView)
        if currentPage == 0 {
            contentOffset = CGPoint(x: scrollView.frame.size.width * CGFloat(prismSideViews.count - 2), y: scrollView.contentOffset.y)
        } else if currentPage == prismSideViews.count - 1 {
            contentOffset = CGPoint(x: scrollView.frame.size.width, y: 0)
        }
    }

    private func currentScrollViewIndex(_ scrollView: UIScrollView) -> Int {
        return Int((scrollView.contentOffset.x / scrollView.frame.size.width).rounded())
    }
        
    private func configureScrollView() {
        isHidden = true
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
    
    private func transformViewsInScrollView(_ scrollView: UIScrollView) {
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
    
    private func setAnchorPoint(_ anchorPoint: CGPoint, forView view: UIView) {
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
}

extension PrismView: UIScrollViewDelegate {
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        resetScrollViewOffsetIfNeeded(scrollView)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        resetScrollViewOffsetIfNeeded(scrollView)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isHidden) {
            transformViewsInScrollView(scrollView)
        }
    }
}
