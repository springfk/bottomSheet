//
//  ViewController.swift
//  bottomSheet
//
//  Created by Bahar on 8/29/1402 AP.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var listWithoutButton: UIStackView!
    @IBOutlet weak var scrollableModalView: UIButton!
    @IBOutlet weak var viewWithOneTextField: UIButton!
    @IBOutlet weak var viewWithMultipleTextFieled: UIButton!
    @IBOutlet weak var viewWithScrolling: UIButton!
    var overlayView: UIView?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    func removeOverlay() {
        overlayView?.removeFromSuperview()
    }
    
    @IBAction func showChildViewControllerWithPresentModal(_ sender: Any) {
        let vc = CustomModalViewController()
//        vc.modalTransitionStyle = .crossDis/solve
        vc.modalPresentationStyle = .custom
        self.present(vc, animated: false)
    }

}

