//
//  BaseModalViewController.swift
//  bottomSheet
//
//  Created by Bahar on 9/6/1402 AP.
//

import UIKit

class CustomBottomSheetViewController: UIViewController, UIScrollViewDelegate {

    // MARK: - Enums and Variables

    public enum SheetTopDistance {
        case max, intrinsicContentSize
    }
    
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
         scrollView.keyboardDismissMode = .interactive
         scrollView.alwaysBounceVertical = true
         scrollView.contentInsetAdjustmentBehavior = .never
         scrollView.showsVerticalScrollIndicator = true
         return scrollView
     }()
    
    lazy var footerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    public lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = cornerRadius
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        return view
    }()
    
    // MARK: - Computed Properties: This properties can be override

    open var shouldIncludeFooterView: Bool {
        return false
    }



    var topDistance: SheetTopDistance {
        .intrinsicContentSize
    }

    ///can override it an d set new value 
    public var cornerRadius: CGFloat {
        0
    }
    
    /// Subclasses override this to return their content view
    func contentView() -> UIView? {
         return nil
     }
    
    /// Height constraint for the header view. its a default value if not override it
    public var headerViewHeightConstraint: CGFloat {
         58
    }
    private var originalModalYPosition: CGFloat = 0

    
    // Constants
    var maxDimmedAlpha              : CGFloat = 0.5
    var defaultContainerHeight      : CGFloat = 500 //for default state with no containerViewHeightConstraint is setted.
    var lastUpdatedHeight           : CGFloat = 0
    var dismissibleHeight           : CGFloat = 200
    var maximumContainerHeight      : CGFloat = UIScreen.main.bounds.height - 64
    var keyboardHeight              : CGFloat = 0


    var containerViewHeightConstraint: NSLayoutConstraint?
    var containerViewBottomConstraint: NSLayoutConstraint?
    var scrollViewTopConstraint: NSLayoutConstraint?

    
    var prefersGrabberVisible: Bool {
        return false
    }
    


    // MARK: - View Lifecycle
    
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
        view.addGestureRecognizer(tapGesture)
        containerViewBottomConstraint?.constant = defaultContainerHeight
    
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Setup Functions
    
    private func setupScrollView() {
        containerView.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: containerView.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
    
    func adjustScrollViewContentSize() {
        let contentView = scrollView.subviews.first
        let height = contentView?.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height ?? 0
        if height > maximumContainerHeight {
            scrollView.contentSize = CGSize(width: containerView.frame.width, height: height)
        } else {
            scrollView.contentSize = .zero
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
  
    //MARK: - Keyboard Handling
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }

        keyboardHeight = keyboardFrame.height
        let newHeight = UIScreen.main.bounds.height - keyboardHeight - 64

        // Adjust the height only if it's going to be less than the maximumContainerHeight
        if newHeight < maximumContainerHeight {
            containerViewHeightConstraint?.constant = newHeight
        }

        containerViewBottomConstraint?.constant = -keyboardHeight

        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    func adjustScrollViewForActiveTextField(_ textField: UITextField) {
        let textFieldFrame = textField.convert(textField.bounds, to: view)
        let visibleAreaHeight = maximumContainerHeight - keyboardHeight

        if textFieldFrame.maxY > visibleAreaHeight {
            let offset = textFieldFrame.maxY - visibleAreaHeight
            scrollView.contentOffset = CGPoint(x: 0, y: offset)
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        containerViewHeightConstraint?.constant = min(defaultContainerHeight, maximumContainerHeight)
        containerViewBottomConstraint?.constant = 0

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
          
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }

//MARK: - Pan Gesture Handling
    


    func setupPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(gesture:)))
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        view.addGestureRecognizer(panGesture)
    }
  
    
    @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let velocity = gesture.velocity(in: view)

        switch gesture.state {
        case .began:
            originalModalYPosition = containerView.frame.origin.y
        case .changed:
            let newY = originalModalYPosition + translation.y
            let isDraggingDown = newY > originalModalYPosition

            if isDraggingDown {
                // Allow unrestricted downward movement
                containerView.frame.origin.y = newY
            } else {
                // Apply resistance to upward movement
                let upwardMovement = max(newY, originalModalYPosition - 100)
                containerView.frame.origin.y = upwardMovement
            }
            
        case .ended:
            let shouldDismiss = containerView.frame.origin.y > dismissibleHeight && velocity.y > 0

            if shouldDismiss {
                animateDismissView()
            } else {
                // Animate back to original position with a bounce effect
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                    self.containerView.frame.origin.y = self.originalModalYPosition

                }, completion: nil)
            }
        default:
            break
        }
    }

    
    //MARK: - Animation
    func animateContainerHeight(_ height: CGFloat) {
        UIView.animate(withDuration: 0.4) {
            self.containerViewHeightConstraint?.constant = height
            self.view.layoutIfNeeded()
        }
    }
    
    func animatePresentContainer() {
        containerViewBottomConstraint?.constant = defaultContainerHeight
         self.view.layoutIfNeeded()

        UIView.animate(withDuration: 0.4) {
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
        self.view.endEditing(true)

        UIView.animate(withDuration: 0.4, animations: {
            self.containerView.frame.origin.y = self.view.frame.size.height
            self.overlayView.alpha = 0
        }) { _ in
            self.dismiss(animated: false)

        }
    }

 
    
    //MARK: - Adjust Modal Height
    func adjustModalHeightBasedOnContent() {
          guard let contentView = contentView() else { return }
          let totalContentHeight = contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
          let cappedHeight = min(totalContentHeight, maximumContainerHeight)

        containerViewHeightConstraint?.constant = cappedHeight
        scrollView.contentSize = CGSize(width: view.frame.width, height: totalContentHeight)
        scrollView.isScrollEnabled = true

          view.layoutIfNeeded()
      }

}


