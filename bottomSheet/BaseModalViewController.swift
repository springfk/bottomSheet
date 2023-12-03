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
        scrollView.delegate = self
        scrollView.keyboardDismissMode = .interactive
        scrollView.alwaysBounceVertical = true
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.backgroundColor = .clear
        scrollView.showsVerticalScrollIndicator = true
        return scrollView
    }()
    
    lazy var footerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    

    // Computed property to determine if the footer view should be included
    open var shouldIncludeFooterView: Bool {
        return false
    }


    private var scrollViewTopConstraint: NSLayoutConstraint?

    
    // This property can be override
    public var cornerRadius: CGFloat {
        0
    }
    
    public var headerViewHeightConstraint: CGFloat {
         58
    }
    
    // Constants
    var maxDimmedAlpha              : CGFloat = 0.5
    var defaultContainerHeight      : CGFloat = 500 //for default state with no containerViewHeightConstraint is setted.
    var lastUpdatedHeight           : CGFloat = 0
    var dismissibleHeight           : CGFloat = 400
    var maximumContainerHeight      : CGFloat = UIScreen.main.bounds.height - 150
    var keyboardHeight              : CGFloat = 0


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
        
        if shouldIncludeFooterView {
//            setupFooterView()
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleCloseAction))
        scrollView.addGestureRecognizer(tapGesture)
        containerViewBottomConstraint?.constant = defaultContainerHeight

        
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
            let visibleAreaHeight = maximumContainerHeight - keyboardHeight

            // Calculate the offset needed to make the active text field visible.
            let offset = visibleAreaHeight - textFieldFrame.maxY// - visibleAreaHeight

            // Only move the view if the text field is actually obscured by the keyboard.
            if offset > 0 {
                // Calculate new bottom constraint value considering the maximum container height.
                let adjustedHeight = min(maximumContainerHeight, containerViewHeightConstraint?.constant ?? 0 + offset)

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
//        keyboardHeight = 0

        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    
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
//        let isDraggingDown = translation.y > 0
        
        
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
        containerViewBottomConstraint?.constant = defaultContainerHeight
         self.view.layoutIfNeeded()

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
            self.containerViewBottomConstraint?.constant = self.defaultContainerHeight
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
          let cappedHeight = min(totalContentHeight, maximumContainerHeight)

        containerViewHeightConstraint?.constant = cappedHeight
        scrollView.contentSize = CGSize(width: view.frame.width, height: totalContentHeight)
        scrollView.isScrollEnabled = true
//          if totalContentHeight > cappedHeight {
//              scrollView.contentSize = CGSize(width: view.frame.width, height: totalContentHeight)
//              scrollView.isScrollEnabled = true
//          } else {
//              scrollView.contentSize = CGSize(width: view.frame.width, height: cappedHeight)
//              scrollView.isScrollEnabled = false
//          }
          view.layoutIfNeeded()
      }
//    func adjustModalHeightBasedOnContent() {
//          guard let contentView = contentView() else { return }
//          let totalContentHeight = contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
//          let cappedHeight = min(totalContentHeight, maximumContainerHeight)
//
//          containerViewHeightConstraint?.constant = cappedHeight
//          if totalContentHeight > cappedHeight {
//              scrollView.contentSize = CGSize(width: view.frame.width, height: totalContentHeight)
//              scrollView.isScrollEnabled = true
//          } else {
//              scrollView.contentSize = CGSize(width: view.frame.width, height: cappedHeight)
//              scrollView.isScrollEnabled = false
//          }
//          view.layoutIfNeeded()
//      }
//    func adjustModalHeightBasedOnContent() {
//        // This is a basic implementation and can be overridden in subclasses
//        // For instance, you might want to set a default height or handle other generic cases here
//        let contentHeight = contentView()?.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height ?? 0
//        let totalHeight = headerViewHeightConstraint + contentHeight + (footerView.frame.size.height)
//        adjustContainerHeight(totalHeight)
//    }
//    
//    func adjustContainerHeight(_ totalHeight: CGFloat) {
//        let adjustedHeight = min(totalHeight, maximumContainerHeight)
//        containerViewHeightConstraint?.constant = adjustedHeight
//        containerViewBottomConstraint?.constant = -adjustedHeight
//
//        view.layoutIfNeeded()
//    }

    }

