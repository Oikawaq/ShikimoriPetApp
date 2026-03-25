
import UIKit

extension UIView {
    func showSkeleton() {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.cornerRadius = layer.cornerRadius
        gradient.colors = [
            UIColor.systemGray5.cgColor,
            UIColor.systemGray4.cgColor,
            UIColor.systemGray5.cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.locations = [0, 0.5, 1]
        gradient.name = "skeletonLayer"
        layer.addSublayer(gradient)
        
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-1.0, -0.5, 0.0]
        animation.toValue = [1.0, 1.5, 2.0]
        animation.duration = 1.2
        animation.repeatCount = .infinity
        gradient.add(animation, forKey: "shimmer")
    }
    
    func hideSkeleton() {
        layer.sublayers?
            .filter { $0.name == "skeletonLayer" }
            .forEach { $0.removeFromSuperlayer() }
    }
}
