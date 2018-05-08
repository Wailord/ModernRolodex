import Foundation
import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    //Example: let color = UIColor(0xFF00FF)
    convenience init(hex:Int) {
        self.init(red:(hex >> 16) & 0xff, green:(hex >> 8) & 0xff, blue:hex & 0xff)
    }
}

extension UIView {
    enum AnchorType {
        case top(anchor: NSLayoutYAxisAnchor, constant: CGFloat)
        case bottom(anchor: NSLayoutYAxisAnchor, constant: CGFloat)
        case left(anchor: NSLayoutXAxisAnchor, constant: CGFloat)
        case right(anchor: NSLayoutXAxisAnchor, constant: CGFloat)
        case leading(anchor: NSLayoutXAxisAnchor, constant: CGFloat)
        case trailing(anchor: NSLayoutXAxisAnchor, constant: CGFloat)
    }
    
    // MARK: LayoutGuide
    func constraints(to guide: UILayoutGuide) -> [NSLayoutConstraint] {
        return constraints(to: guide, inset: .zero)
    }
    
    func constraints(to guide: UILayoutGuide, inset: UIEdgeInsets) -> [NSLayoutConstraint] {
        let anchors: [AnchorType] = [
            .top(anchor: guide.topAnchor, constant: inset.top),
            .bottom(anchor: guide.bottomAnchor, constant: -inset.bottom),
            .left(anchor: guide.leftAnchor, constant: inset.left),
            .right(anchor: guide.rightAnchor, constant: -inset.right)
        ]
        return constraints(to: anchors)
    }
    
    // MARK: UIView
    func constraints(to view: UIView) -> [NSLayoutConstraint] {
        return constraints(to: view, inset: .zero)
    }
    
    func constraints(to view: UIView, inset: UIEdgeInsets) -> [NSLayoutConstraint] {
        let anchors: [AnchorType] = [
            .top(anchor: view.topAnchor, constant: inset.top),
            .bottom(anchor: view.bottomAnchor, constant: -inset.bottom),
            .left(anchor: view.leftAnchor, constant: inset.left),
            .right(anchor: view.rightAnchor, constant: -inset.right)
        ]
        return constraints(to: anchors)
    }
    
    // MARK:
    func constraints(to anchors: [AnchorType]) -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        for anchor in anchors {
            switch anchor {
            case let .top(anchor, constant):
                constraints.append(self.topAnchor.constraint(equalTo: anchor, constant: constant))
            case let .bottom(anchor, constant):
                constraints.append(self.bottomAnchor.constraint(equalTo: anchor, constant: constant))
            case let .left(anchor, constant):
                constraints.append(self.leftAnchor.constraint(equalTo: anchor, constant: constant))
            case let .right(anchor, constant):
                constraints.append(self.rightAnchor.constraint(equalTo: anchor, constant: constant))
            case let .leading(anchor, constant):
                constraints.append(self.leadingAnchor.constraint(equalTo: anchor, constant: constant))
            case let .trailing(anchor, constant):
                constraints.append(self.trailingAnchor.constraint(equalTo: anchor, constant: constant))
            }
        }
        return constraints
    }
}

extension UIView {
    public func addConstrainedSubview(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
    }
}
