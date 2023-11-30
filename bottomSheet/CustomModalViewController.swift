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
        label.text = "Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of  (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, comes from a line in section 1.10.32Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old."
        label.font = .systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.numberOfLines = 0
        return label
    }()
    
    
    lazy var notesLabel2: UILabel = {
        let label = UILabel()
        label.text = "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.numberOfLines = 0
        return label
    }()
    
    lazy var notesLabel3: UILabel = {
        let label = UILabel()
        label.text = "Fill Above Text Fields!"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.numberOfLines = 0
        return label
    }()
    
    lazy var contentStackView: UIStackView = {
        let spacer = UIView()
        let stackView = UIStackView(arrangedSubviews: [ titleLabel, textField, textField2, textField3, notesLabel3, notesLabel, spacer, notesLabel2])
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
//    lazy var scrollView: UIScrollView = {
//        let scrollView = UIScrollView()
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        return scrollView
//    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        return view
    }()
    

    override func contentView() -> UIView? {
           return containerView
       }
    
    override var cornerRadius: CGFloat {
        return 12
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Dismiss the keyboard when the user taps the return key
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.setActiveTextField(textField)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        self.setActiveTextField(nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addContentToScrollView(content: containerView)
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
    }

    
    func setupConstraints() {
        view.addSubview(headerViewSheet)
        headerViewSheet.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(contentStackView)
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        // Activate constraints
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
            contentStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            contentStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            contentStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
        ])
//        addContentToScrollView(content: containerView)
        
        view.layoutIfNeeded()
        
        defaultContainerHeight = containerView.frame.height
        
        containerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: defaultContainerHeight)
        containerViewBottomConstraint = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: defaultContainerHeight)
        
        containerViewHeightConstraint?.isActive = true
        containerViewBottomConstraint?.isActive = true
    }
    

}
