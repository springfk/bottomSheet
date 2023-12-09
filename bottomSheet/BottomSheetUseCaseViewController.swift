//
//  CustomModalViewController.swift
//  bottomSheet
//
//  Created by Bahar on 9/6/1402 AP.
//


import UIKit

class BottomSheetUseCaseViewController: CustomBottomSheetViewController, UITextFieldDelegate {
   
    
    lazy var headerViewSheet: UIView = {
        let view = HeaderView()
        view.title = "Header Title"
        view.tintColor = .darkGray
        view.backColor = .white
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
        textField.placeholder = "Enter text"
        textField.borderStyle = .roundedRect
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        textField.setContentHuggingPriority(.required, for: .vertical)

         return textField
     }()
    
 

    lazy var notesLabel: UILabel = {
        let label = UILabel()
        label.text = "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution ofIt is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution ofIt It is a long established fact   "
        label.font = .systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.textAlignment = .justified
        label.heightAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true
        label.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    

    lazy var contentStackView: UIStackView = {
        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultLow, for: .vertical)

        let stackView = UIStackView(arrangedSubviews: [titleLabel, notesLabel,textField, spacer])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fill
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


    override func contentView() -> UIView? {
           return containerView
       }
    
    override var cornerRadius: CGFloat {
        return 12
    }
    
    override var headerViewHeightConstraint: CGFloat {
        return 58
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
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
        scrollView.scrollIndicatorInsets = scrollView.contentInset

        setupConstraints()
        textField.delegate = self
        activeTextField?.delegate =  self

    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        adjustScrollViewContentSize()
    }
    


    func setupConstraints() {
        containerView.addSubview(headerViewSheet)
        headerViewSheet.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(contentStackView)
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
            
            headerViewSheet.topAnchor.constraint(equalTo: containerView.topAnchor),
            headerViewSheet.heightAnchor.constraint(equalToConstant: 58),
            headerViewSheet.leftAnchor.constraint(equalTo: view.leftAnchor),
            headerViewSheet.rightAnchor.constraint(equalTo: view.rightAnchor),
            headerViewSheet.bottomAnchor.constraint(equalTo: contentStackView.topAnchor),

            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 32),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -10),
            contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40),


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
        view.layoutIfNeeded()
        
        defaultContainerHeight = containerView.frame.height
        
        containerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: defaultContainerHeight)
        containerViewBottomConstraint = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: defaultContainerHeight)
        
        containerViewHeightConstraint?.isActive = true
        containerViewBottomConstraint?.isActive = true
    }
    

    
    @objc func actionButtonHandler() {
        print("actionButton is pressed")
    }
}
