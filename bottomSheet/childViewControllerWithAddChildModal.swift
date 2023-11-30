//
//  childViewViewController.swift
//  bottomSheet
//
//  Created by Bahar on 8/30/1402 AP.
//

import UIKit

class childViewControllerWithAddChildModal:  MobilletBottomSheetViewController {
    
    var topView     : HeaderView!
    var containerView : UIView!
    var actionBtn   : UIButton!
    
    var onDismiss: (() -> Void)?

    
    override var customHeight: CGFloat {
        let totalStackViewHeight = stackView.frame.height
        let headerHeight = headerView.frame.height
        let footerHeight = footerView.frame.height

        return totalStackViewHeight + headerHeight + footerHeight
    }

    
    
    override var cornerRadius: CGFloat {
        return 12
    }
    

        lazy var label1: UILabel = {
            let label = UILabel()
            label.text = "test1"
            label.backgroundColor = .red
            label.textAlignment = .center
            label.frame = CGRect(x: 0, y: 0, width: 300, height: 35)
            return label
        }()

        lazy var label2: UILabel = {
            let label = UILabel()
            label.text = "test2"
            label.backgroundColor = .green
            label.textAlignment = .center
            label.frame = CGRect(x: 0, y: 0, width: 300, height: 35)
            return label
        }()

        lazy var label3: UILabel = {
            let label = UILabel()
            label.text = "test3"
            label.backgroundColor = .blue
            label.textAlignment = .center
            label.frame = CGRect(x: 0, y: 0, width: 300, height: 35)
            return label
        }()

        lazy var stackView: UIStackView = {
            let stack = UIStackView(arrangedSubviews: [label1, label2, label3])
            stack.axis = .vertical
            stack.distribution = .fillEqually
            stack.alignment = .center
            stack.spacing = 10
            return stack
        }()
        
   

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupHeaderView()
        actionBtn = setupButtonInFooterView(in: footerView)
        setupConetntView(in: contentView)
//        addStackViewToContentView()
//        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
//            self.view.addGestureRecognizer(panGesture)
        addStackView()
        view.layoutIfNeeded()
    }
 
    
   /* @objc func handlePanGesture(gesture:UIPanGestureRecognizer) {

                if gesture.state == .began {
                    print("Began")
                }else if gesture.state == .changed {
                    let translation = gesture.translation(in: self.view)
                    if((self.view.frame.height - self.view.center.y > 150 && translation.y < 0)
                    || (self.view.frame.height - self.view.center.y < 0 && translation.y > 0)){
                    
                        print("Block")
                    }else{
                        gesture.view!.center = CGPoint(x: gesture.view!.center.x,
                        y: gesture.view!.center.y + translation.y)
                        
                        gesture.setTranslation(CGPoint.zero, in: self.view)
                    }
                    if(self.view.frame.height - self.view.center.y > 150){
                        self.view.center.y = self.view.frame.height - 150
                    }
                    if(self.view.frame.height - self.view.center.y < 0){
                        self.view.center.y = self.view.frame.height
                    }
                }else if gesture.state == .ended {
                    gesture.view?.center = CGPoint(x: self.view.center.x,
                    y: self.view.center.y)
                    
                    print("ended")
                    UIView.animate(withDuration: 0.15, animations: {
                        if(self.view.frame.height -  self.view.center.y < 60){
                            self.view.center.y = self.view.frame.height
                        }else{
                            self.view.center.y = self.view.frame.height - 150
                        }
                    })
                    print("Ended")
                }
            }*/
    
    func animateViewToRestingPosition() {
        // Determine the resting position (top, middle, or bottom)
        // For example, if the view is over halfway up the screen, animate it to the top, otherwise animate it back to the bottom

        UIView.animate(withDuration: 0.3) {
            // Update view.frame to the new position
        }
    }

    
    private func addStackView() {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(scrollView)
        
        // Constrain scroll view to content view
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: contentView.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        scrollView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        // Constraint stack view to scroll view
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            stackView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    

    
    private func setupHeaderView()  {
        if topView == nil {
         let sheetHeader = HeaderView()
            sheetHeader.closeButtonDidTap {
                self.defaultDismissViewController()
            }
            topView = sheetHeader
            self.topView?.title = "تست هدر"
            topView?.backColor = .lightGray
            headerView.embed(view: topView)
            
        }
    }

    
    
    private func defaultDismissViewController() {
        UIView.animate(withDuration: 0.3, animations: {
            // This line moves the view off the screen from top to bottom
            self.view.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: self.view.bounds.width, height: self.view.bounds.height)
        }, completion: { _ in
            self.willMove(toParent: nil)
            self.view.removeFromSuperview()
            self.removeFromParent()
            self.onDismiss?()
        })
    }
    



    private func setupConetntView(in view: UIView? = nil) {

        let contentView = UIView()
        contentView.backgroundColor = .white
        if let view = view {
            view.addSubview(contentView)
            contentView.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                contentView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
                contentView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
                contentView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
                contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10)
            ])
        }

    }

    private func addStackViewToContentView() {
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false


            NSLayoutConstraint.activate([
                stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 17),
                stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
                stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
                stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
            ])
    }


    
    private func setupButtonInFooterView(in view: UIView? = nil) -> UIButton? {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.setTitle("تایید", for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonDidTapped), for: .touchUpInside)
        if let view = view {
            view.addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                button.topAnchor.constraint(equalTo: view.topAnchor, constant: 17),
                button.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
                button.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
                button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
            ])
        }
        return button
    }
    
    
    private func embedIntoHeaderView(view: UIView, in superView: UIView) {
        superView.addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: superView.leadingAnchor),
            view.topAnchor.constraint(equalTo: superView.topAnchor),
            view.trailingAnchor.constraint(equalTo: superView.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: superView.topAnchor, constant: -58),
            view.heightAnchor.constraint(equalToConstant: 58)
        ])
    }
    
    @objc func buttonDidTapped() {
        print("buttonDidTapped")
    }
    
}

