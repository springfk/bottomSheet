//
//  BaseModalViewController.swift
//  bottomSheet
//
//  Created by Bahar on 9/6/1402 AP.
//

import UIKit

class BaseModalViewController: UIViewController, UIScrollViewDelegate {

    lazy var overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.5
        return view
    }()
    
    var activeTextField: UITextField?

    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

//    public private(set) var scrollView: UIScrollView!
    public private(set) var contentViewForData: UIView!
    public private(set) var footerView: UIView!
    public private(set) var headerView: UIView!
    private var scrollViewTopConstraint: NSLayoutConstraint?

    
    // This property can be override
    public var cornerRadius: CGFloat {
        0
    }
    
    // Constants
    let maxDimmedAlpha: CGFloat = 0.5
    
    var defaultContainerHeight: CGFloat = 500 //for default state with no containerViewHeightConstraint is setted.
    
    var lastUpdatedHeight: CGFloat = 0
    let dismissibleHeight: CGFloat = 400
    
    let maximumContainerHeight  : CGFloat = UIScreen.main.bounds.height - 130
    
    private var keyboardHeight: CGFloat = 0


    var containerViewHeightConstraint: NSLayoutConstraint?
    var containerViewBottomConstraint: NSLayoutConstraint?
    
    var prefersGrabberVisible: Bool {
        return false
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        adjustForKeyboardAppearance()
        setupPanGesture()
        setupOverlayView()
        setupScrollView()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleCloseAction))
        scrollView.addGestureRecognizer(tapGesture)
        
        lastUpdatedHeight = defaultContainerHeight
    
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func addContentToScrollView(content: UIView) {
        scrollView.delegate = self
        scrollView.keyboardDismissMode = .interactive
        scrollView.alwaysBounceVertical = true
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.backgroundColor = .clear
        scrollView.showsVerticalScrollIndicator = false
        
        scrollView.addSubview(content)
        content.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            content.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            content.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            content.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            content.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])
    }
    
    private var headerViewHeightConstraint: CGFloat {
        return 58
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        animateShowOverlayView()
        adjustModalHeightBasedOnContent()
        animatePresentContainer()

    }
    
    func adjustForKeyboardAppearance() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    

    
    func setActiveTextField(_ textField: UITextField?) {
          activeTextField = textField
      }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }

        keyboardHeight = keyboardFrame.height

        // Adjust the bottom constraint of the container view.
        containerViewBottomConstraint?.constant = -keyboardHeight

        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }

        // Optional: If you want to ensure the active text field is visible.
        if let activeTextField = activeTextField {
            // Calculate the frame of the active text field in the view's coordinate system.
            let textFieldFrame = activeTextField.convert(activeTextField.bounds, to: view)

            // Calculate the visible area height above the keyboard.
            let visibleAreaHeight = UIScreen.main.bounds.height - 130 - keyboardHeight

            // Calculate the offset needed to make the active text field visible.
            let offset = visibleAreaHeight - textFieldFrame.maxY// - visibleAreaHeight

            // Only move the view if the text field is actually obscured by the keyboard.
            if offset > 0 {
                // Calculate new bottom constraint value considering the maximum container height.
                let adjustedHeight = min(maximumContainerHeight, containerViewHeightConstraint?.constant ?? 0)// + //offset)

                containerViewHeightConstraint?.constant = adjustedHeight

                UIView.animate(withDuration: 0.3) {
                    self.scrollView.contentOffset = CGPoint(x: 0, y: self.scrollView.contentOffset.y + offset)
                    self.view.layoutIfNeeded()
                }
            }
        }

        // Enable scrolling regardless of the active text field's position.
        scrollView.isScrollEnabled = true
    }


    

    
    @objc func keyboardWillHide(_ notification: Notification) {
        containerViewHeightConstraint?.constant = defaultContainerHeight
        containerViewBottomConstraint?.constant = 0 // Reset to default

        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }



//    func adjustViewForKeyboard(activeTextField: UITextField?, keyboardHeight: CGFloat) {
//        guard let activeTextField = activeTextField else { return }
//        
//        let textFieldFrame = activeTextField.convert(activeTextField.bounds, to: view)
//        let viewFrame = view.frame.inset(by: view.safeAreaInsets)
//        let keyboardTop = viewFrame.height - keyboardHeight
//        
//        if textFieldFrame.maxY > keyboardTop {
//            containerViewBottomConstraint?.constant = -(textFieldFrame.maxY - keyboardTop)
//            UIView.animate(withDuration: 0.3) {
//                self.view.layoutIfNeeded()
//            }
//        }
//    }
    
    func adjustViewForKeyboard(activeTextField: UITextField?, keyboardHeight: CGFloat) {
        guard let activeTextField = activeTextField else { return }
        
        let textFieldFrame = activeTextField.convert(activeTextField.bounds, to: view)
        let viewFrame = view.frame.inset(by: view.safeAreaInsets)
        let keyboardTop = viewFrame.height - keyboardHeight
        
        if textFieldFrame.maxY > keyboardTop {
            // Adjust containerViewBottomConstraint or scrollView's contentOffset as needed
            // ...
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }




    @objc func handleCloseAction() {
        animateDismissView()
    }

    func setupOverlayView() {
        view.backgroundColor = .clear
        view.addSubview(overlayView)
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        setupOverlayViewConstraints()
    }

    private func setupOverlayViewConstraints() {
        NSLayoutConstraint.activate([
            overlayView.topAnchor.constraint(equalTo: view.topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    


    func setupPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(gesture:)))
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        view.addGestureRecognizer(panGesture)
    }


    @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
        // Check if a text field is active
        if activeTextField != nil {
             activeTextField?.resignFirstResponder()
            return
        }
        let translation = gesture.translation(in: view)
        let velocity = gesture.velocity(in: view)
        let isDraggingDown = translation.y > 0
        
        
        // New height is based on value of dragging plus current container height
        var newHeight = defaultContainerHeight - translation.y
        
        // Ensure newHeight does not exceed defaultContainerHeight
        newHeight = min(newHeight, defaultContainerHeight)
        
        // Introduce a threshold to limit updates
        let heightUpdateThreshold: CGFloat = 10.0
        if abs(lastUpdatedHeight - newHeight) > heightUpdateThreshold || gesture.state == .ended {
            lastUpdatedHeight = newHeight
            containerViewHeightConstraint?.constant = newHeight
        }
        
        switch gesture.state {
        case .changed:
            // Update the layout only if the height crosses the threshold
            if newHeight < maximumContainerHeight && abs(lastUpdatedHeight - newHeight) > heightUpdateThreshold {
                view.layoutIfNeeded()
            }
        case .ended:
            lastUpdatedHeight = defaultContainerHeight
            
            let shouldDismiss = newHeight < dismissibleHeight || velocity.y > 1500 // Example velocity threshold for dismissal
            if shouldDismiss {
                self.animateDismissView()
            } else {
                // Determine the final height based on velocity and direction
                let finalHeight = defaultContainerHeight//isDraggingDown ? dismissibleHeight : maximumContainerHeight//maximumContainerHeight
                animateContainerHeight(finalHeight)
            }
        default:
            break
        }
    }



    func animateContainerHeight(_ height: CGFloat) {
        UIView.animate(withDuration: 0.4) {
            self.containerViewHeightConstraint?.constant = height
            self.view.layoutIfNeeded()
        }
        defaultContainerHeight = height
    }
    
    func animatePresentContainer() {
        UIView.animate(withDuration: 0.3) {
            self.containerViewBottomConstraint?.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    
    func animateShowOverlayView() {
        overlayView.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.overlayView.alpha = self.maxDimmedAlpha
        }
    }
    


    func animateDismissView() {
        overlayView.alpha = maxDimmedAlpha
        UIView.animate(withDuration: 0.4) {
            self.overlayView.alpha = 0
        } completion: { _ in
            // once done, dismiss without animation
            self.dismiss(animated: false)
        }
        // hide main view by updating bottom constraint in animation block
        UIView.animate(withDuration: 0.3) {
            self.containerViewBottomConstraint?.constant = self.defaultContainerHeight//self.defaultHeight
            // call this to trigger refresh constraint
            self.view.layoutIfNeeded()
        }
    }
    
    func contentView() -> UIView? {
         // Subclasses override this to return their content view
         return nil
     }
    
    //MARK: - Adjust Modal Height
    func adjustModalHeightBasedOnContent() {
          guard let contentView = contentView() else { return }
          let totalContentHeight = contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
          let cappedHeight = min(totalContentHeight, UIScreen.main.bounds.height - 130)

          containerViewHeightConstraint?.constant = cappedHeight
          if totalContentHeight > cappedHeight {
              scrollView.contentSize = CGSize(width: view.frame.width, height: totalContentHeight)
              scrollView.isScrollEnabled = true
          } else {
              scrollView.contentSize = CGSize(width: view.frame.width, height: cappedHeight)
              scrollView.isScrollEnabled = false
          }
          view.layoutIfNeeded()
      }

    }

