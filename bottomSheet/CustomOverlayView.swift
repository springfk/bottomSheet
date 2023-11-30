//
//  CustomOverlayView.swift
//  bottomSheet
//
//  Created by Bahar on 9/9/1402 AP.
//
import UIKit

class CustomOverlayView: UIView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let hitView = super.hitTest(point, with: event), hitView != self {
            // If the touch is on a subview of the overlay, pass the touch to that view
            return hitView
        }
        // Otherwise, the touch is on the overlay itself
        return nil
    }
}
