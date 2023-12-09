//
//  DropDownViewController.swift
//  bottomSheet
//
//  Created by Bahar on 9/11/1402 AP.
//

import UIKit

class DropDownUseCaseViewController: CustomBottomSheetViewController, UITableViewDataSource, UITableViewDelegate {

    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
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
    
    override var cornerRadius: CGFloat {
        0
    }
    
    private let dataArray: [String] = ["text 1", "text 2", "text 3", "text 4", "text 5"]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        tableView.tableFooterView = UIView()
    }


    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        
        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(headerViewSheet)
        headerViewSheet.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(tableView)

        NSLayoutConstraint.activate([
            containerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            containerView.rightAnchor.constraint(equalTo: view.rightAnchor),
            containerView.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor),
            containerView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor),
            
            headerViewSheet.topAnchor.constraint(equalTo: containerView.topAnchor),
            headerViewSheet.heightAnchor.constraint(equalToConstant: 58),
            headerViewSheet.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            headerViewSheet.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            
            tableView.topAnchor.constraint(equalTo: headerViewSheet.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            

        ])
        view.layoutIfNeeded()
        
        defaultContainerHeight = containerView.frame.height
        
        containerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: defaultContainerHeight)
        containerViewBottomConstraint = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: defaultContainerHeight)
        
        containerViewHeightConstraint?.isActive = true
        containerViewBottomConstraint?.isActive = true
        adjustModalHeightBasedOnContent()
    }

    override func contentView() -> UIView? {
        return tableView
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = dataArray[indexPath.row]
        cell.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)

        
        return cell
    }

    //MARK: - Adjust Modal Height
    override func adjustModalHeightBasedOnContent() {
        let rowHeight: CGFloat = 50
        let tableHeight = rowHeight * CGFloat(dataArray.count) + headerViewHeightConstraint
        let totalHeight = min(tableHeight, maximumContainerHeight)
        containerViewHeightConstraint?.constant = totalHeight
        view.layoutIfNeeded()
    }
}

