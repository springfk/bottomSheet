//
//  HeaderView.swift
//  bottomSheet
//
//  Created by Bahar on 8/30/1402 AP.
//

import UIKit

class HeaderView: UIView {
    
    
    lazy var closeBtn : UIButton = {
        let closeBtn = UIButton()
        closeBtn.setImage(Icons.close, for: .normal)
        closeBtn.isEnabled = true
        closeBtn.translatesAutoresizingMaskIntoConstraints = false
        closeBtn.addTarget(self, action: #selector(closeButtonAction(_:)), for: .touchUpInside)
        return closeBtn
    }()
    
    
    lazy var headerTitleLabel: UILabel = {
        let title = UILabel()
        title.textAlignment = .center
        title.font = UIFont.systemFont(ofSize: 15)
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
        
    }()
    
    var title: String? {
        didSet {
            headerTitleLabel.text = title
        }
    }
    
    var backColor: UIColor? {
        didSet {
            backgroundColor = backColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        headerTitleLabel.textColor = .darkGray
        closeBtn.tintColor = .white
        headerTitleLabel.text = title
        setupLabel()
        setupCloseBtn()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("\(self) is being deinitialized")
    }

    
    private var closeButtonActionClosure: (() -> Void)?
    var defaultDismissalAction: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()

        setupLabel()
        setupCloseBtn()
    }
    
    private func setupLabel() {
        
        addSubview(headerTitleLabel)
        headerTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerTitleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 54),
            headerTitleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -54),
            headerTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            headerTitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            
        ])
    }
    
    private func setupCloseBtn() {
        
        addSubview(closeBtn)
        closeBtn.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            closeBtn.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            closeBtn.topAnchor.constraint(equalTo: topAnchor, constant: 17),
            closeBtn.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -17),
            closeBtn.heightAnchor.constraint(equalToConstant: 24)
            
        ])
    }
    
    
    @objc private func closeButtonAction(_ sender: UIButton) {
        closeButtonActionClosure?() ?? defaultDismissalAction?()
    }

    
    
    public func closeButtonDidTap(_ closure: @escaping (() -> Void)) {
        self.closeButtonActionClosure = closure
    }
    
}


