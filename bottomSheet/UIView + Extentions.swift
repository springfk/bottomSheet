//
//  UIView + Extentions.swift
//  bottomSheet
//
//  Created by Bahar on 9/1/1402 AP.
//

import Foundation
import UIKit

extension UIView {
    
    public struct EdgePriorities {
        var top: UILayoutPriority?
        var leading: UILayoutPriority?
        var bottom: UILayoutPriority?
        var trailing: UILayoutPriority?
        
        static let required: EdgePriorities = .init(top: .required, leading: .required, bottom: .required, trailing: .required)
        static let defaultHigh: EdgePriorities = .init(top: .defaultHigh, leading: .defaultHigh, bottom: .defaultHigh, trailing: .defaultHigh)
        
        init(top: UILayoutPriority? = nil, leading: UILayoutPriority? = nil,
             bottom: UILayoutPriority? = nil, trailing: UILayoutPriority? = nil) {
            self.top = top
            self.leading = leading
            self.bottom = bottom
            self.trailing = trailing
        }
    }
    
    
    func embed(view: UIView, inset: UIEdgeInsets = .zero, edges: UIRectEdge = .all,
               guide: UILayoutGuide? = nil, priorities: EdgePriorities = .init()) {
        view.translatesAutoresizingMaskIntoConstraints = false
        if view.superview != self { addSubview(view) }
        var constraints: [NSLayoutConstraint] = []
        
        if edges.contains(.top) {
            let top: NSLayoutConstraint
            if let guide = guide {
                top = view.topAnchor.constraint(equalTo: guide.topAnchor, constant: inset.top)
            } else {
                top = view.topAnchor.constraint(equalTo: topAnchor, constant: inset.top)
            }
            top.priority = priorities.top ?? (subviews.isEmpty ? .defaultHigh : .fittingSizeLevel)
            constraints.append(top)
        }
        if edges.contains(.bottom) {
            let btm: NSLayoutConstraint
            if let guide = guide {
                btm = guide.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: inset.bottom)
            } else {
                btm = bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: inset.bottom)
            }
            btm.priority = priorities.bottom ?? .fittingSizeLevel
            constraints.append(btm)
        }
        if edges.contains(.left) {
            let leading: NSLayoutConstraint
            if let guide = guide {
                leading = view.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: inset.left)
            } else {
                leading = view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset.left)
            }
            leading.priority = priorities.leading ?? .required
            constraints.append(leading)
        }
        if edges.contains(.right) {
            let trailing: NSLayoutConstraint
            if let guide = guide {
                trailing = guide.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: inset.right)
            } else {
                trailing = trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: inset.right)
            }
            trailing.priority = priorities.trailing ?? .required
            constraints.append(trailing)
        }
        
        NSLayoutConstraint.activate(constraints)
    }
}


extension UIView {
  func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
      let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners,
                              cornerRadii: CGSize(width: radius, height: radius))
      let mask = CAShapeLayer()
      mask.path = path.cgPath
      layer.mask = mask
  }
}



protocol PresentingViewControllerFinder {
    func findPresentingViewController() -> UIViewController?
}

extension UIViewController: PresentingViewControllerFinder {
    func findPresentingViewController() -> UIViewController? {
        if let parent = self.parent {
            return parent.findPresentingViewController()
        } else {
            return UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController
        }
    }
}
