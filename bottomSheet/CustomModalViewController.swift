//
//  CustomModalViewController.swift
//  bottomSheet
//
//  Created by Bahar on 9/6/1402 AP.
//


import UIKit

class CustomModalViewController: BaseModalViewController, UITextFieldDelegate {
   
    
    lazy var headerViewSheet: UIView = {
        let view = HeaderView()
        view.title = "Header Title"
        view.tintColor = .darkGray
        view.backColor = .white
        view.layer.cornerRadius = self.cornerRadius
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        view.closeButtonDidTap { [weak self] in
            self?.animateDismissView()
        }
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Subject"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    lazy var textField: UITextField = {
         let textField = UITextField()
         textField.placeholder = "Enter text1"
         textField.borderStyle = .roundedRect
         textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.heightAnchor.constraint(equalToConstant: 40).isActive = true
         return textField
     }()
    
    lazy var textField2: UITextField = {
         let textField = UITextField()
         textField.placeholder = "Enter text2"
         textField.borderStyle = .roundedRect
         textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.heightAnchor.constraint(equalToConstant: 40).isActive = true
         return textField
     }()
    
    lazy var textField3: UITextField = {
         let textField = UITextField()
         textField.placeholder = "Enter text3"
         textField.borderStyle = .roundedRect
         textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.heightAnchor.constraint(equalToConstant: 40).isActive = true
         return textField
     }()
    
    lazy var notesLabel: UILabel = {
        let label = UILabel()
        label.text = "Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words"
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .justified
        label.textColor = .darkGray
        label.numberOfLines = 0
        return label
    }()
    
    
    lazy var notesLabel2: UILabel = {
        let label = UILabel()
        label.text = "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of lettersf  It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of lettersf  It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of lettersf"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.textAlignment = .justified
        label.numberOfLines = 0
        return label
    }()
    
    lazy var notesLabel3: UILabel = {
        let label = UILabel()
        label.text = "Fill Above Text Fields!"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.heightAnchor.constraint(equalToConstant: 30).isActive = true
        label.numberOfLines = 0
        return label
    }()
    
    lazy var contentStackView: UIStackView = {
        let spacer = UIView()
        let stackView = UIStackView(arrangedSubviews: [ titleLabel, textField,notesLabel3, notesLabel])
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Confirm", for: .normal)
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.addTarget(self, action: #selector(actionButtonHandler), for: .touchUpInside)
        return button
    }()

    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        return view
    }()
    

    override func contentView() -> UIView? {
           return containerView
//        return scrollView
       }
    
    override var cornerRadius: CGFloat {
        return 12
    }
    
    override var headerViewHeightConstraint: CGFloat {
        return 58
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Dismiss the keyboard when the user taps the return key
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.setActiveTextField(textField)
        var frame = textField.frame
        frame = scrollView.convert(frame, from: textField.superview)
        frame.size.height += 20 // Add some padding below the text field
        scrollView.scrollRectToVisible(frame, animated: true)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        self.setActiveTextField(nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentInset = UIEdgeInsets(top: headerViewHeightConstraint, left: 0, bottom: 0, right: 0)
//        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: footerView.frame.height, right: 0)
        scrollView.scrollIndicatorInsets = scrollView.contentInset

        setupConstraints()
        
        textField.delegate = self
        textField2.delegate = self
        textField3.delegate = self
        activeTextField?.delegate =  self

    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let containerHeight = containerView.frame.height
        // Now containerHeight should have the correct value
        
//        var contentRect = CGRect.zero
//        for view in scrollView.subviews {
//            contentRect = contentRect.union(view.frame)
//        }
//        scrollView.contentSize = contentRect.size
    }
    


    
    func setupConstraints() {
        view.addSubview(headerViewSheet)
        headerViewSheet.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(contentStackView)
        contentStackView.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(footerView)
        footerView.translatesAutoresizingMaskIntoConstraints = false
        
        footerView.addSubview(actionButton)
        actionButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
  
            containerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            containerView.rightAnchor.constraint(equalTo: view.rightAnchor),
            containerView.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor),
            containerView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor),
            
            headerViewSheet.heightAnchor.constraint(equalToConstant: 58),
            headerViewSheet.leftAnchor.constraint(equalTo: view.leftAnchor),
            headerViewSheet.rightAnchor.constraint(equalTo: view.rightAnchor),
            headerViewSheet.bottomAnchor.constraint(equalTo: containerView.topAnchor),

            contentStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 32),
            contentStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            contentStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            contentStackView.bottomAnchor.constraint(equalTo: footerView.topAnchor, constant: -10),
            
            footerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            footerView.topAnchor.constraint(equalTo: contentStackView.bottomAnchor, constant: 10),
            footerView.heightAnchor.constraint(equalToConstant: 81),
            
            actionButton.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 16),
            actionButton.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 16),
            actionButton.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -16),
            actionButton.bottomAnchor.constraint(equalTo: footerView.bottomAnchor, constant: -16),
        ])
//        addContentToScrollView(content: containerView)
        view.layoutIfNeeded()
        
        defaultContainerHeight = containerView.frame.height
        
        containerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: defaultContainerHeight)
        containerViewBottomConstraint = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: defaultContainerHeight)
        
        containerViewHeightConstraint?.isActive = true
        containerViewBottomConstraint?.isActive = true
    }
    
   /*func setupConstraints() { //fixed scrolling but transition have problem
        view.addSubview(headerViewSheet)
        headerViewSheet.translatesAutoresizingMaskIntoConstraints = false
    
        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
    
        containerView.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
    
        scrollView.addSubview(contentStackView)
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
    
        view.addSubview(footerView)
        footerView.translatesAutoresizingMaskIntoConstraints = false
    
        footerView.addSubview(actionButton)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
    
        NSLayoutConstraint.activate([
            // Header view constraints
            headerViewSheet.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerViewSheet.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerViewSheet.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerViewSheet.heightAnchor.constraint(equalToConstant: headerViewHeightConstraint),
    
            // Container view constraints
              containerView.topAnchor.constraint(equalTo: headerViewSheet.bottomAnchor),
              containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
              containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
              containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    
            // Scroll view constraints
            scrollView.topAnchor.constraint(equalTo: containerView.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
    
            // Content stack view constraints
            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: headerViewHeightConstraint),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40),
    
            // Footer view constraints
            footerView.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 10),
            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            footerView.heightAnchor.constraint(equalToConstant: 81),
    
            // Action button constraints
            actionButton.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 16),
            actionButton.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 16),
            actionButton.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -16),
            actionButton.bottomAnchor.constraint(equalTo: footerView.bottomAnchor, constant: -16),
        ])
    
        view.layoutIfNeeded()
    
        defaultContainerHeight = containerView.frame.height
    
        containerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: defaultContainerHeight)
        containerViewBottomConstraint = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: defaultContainerHeight)
    
        containerViewHeightConstraint?.isActive = true
        containerViewBottomConstraint?.isActive = true
    }*/
    

    
//
//     override func adjustModalHeightBasedOnContent() {
//        let headerHeight = headerViewSheet.frame.size.height
//        let contentHeight = contentStackView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
//        let footerHeight = footerView.frame.size.height
//
//        let totalHeight = headerHeight + contentHeight + footerHeight
//
//        // Adjust the height in the base class
//        (self as? BaseModalViewController)?.adjustContainerHeight(totalHeight)
//    }
    
    
    @objc func actionButtonHandler() {
        
    }
}
