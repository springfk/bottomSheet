//
//  ViewController.swift
//  bottomSheet
//
//  Created by Bahar on 8/29/1402 AP.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var listModalBtn: UIButton!
    @IBOutlet weak var listWithoutButton: UIStackView!
    @IBOutlet weak var scrollableModalView: UIButton!

    var overlayView: UIView?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    func removeOverlay() {
        overlayView?.removeFromSuperview()
    }
    
    
    @IBAction func showListModalView(_ sender: Any) {
        let vc = ListModalTableViewController()
        vc.modalPresentationStyle = .custom
        self.present(vc, animated: false)
    }
    
    
    @IBAction func showChildViewControllerWithPresentModal(_ sender: Any) {
        let vc = CustomModalViewController()
        vc.modalPresentationStyle = .custom
        self.present(vc, animated: false)
    }

}

