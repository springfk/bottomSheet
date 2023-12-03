//
//  ListModalTableViewController.swift
//  bottomSheet
//
//  Created by Bahar on 9/11/1402 AP.
//
import UIKit

class ListModalTableViewController: BaseModalViewController, UITableViewDataSource, UITableViewDelegate {

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
    
    // Override contentView to return the tableView
    override func contentView() -> UIView? {
        return tableView
    }
    // Define an array of strings
    private let dataArray: [String] = ["text1", "text2", "text3", "text4","text5","text6","text7"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()

    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        view.addSubview(headerViewSheet)
        headerViewSheet.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)

        // Set up constraints
        NSLayoutConstraint.activate([
            
            tableView.topAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor),
            
            headerViewSheet.heightAnchor.constraint(equalToConstant: 58),
            headerViewSheet.leftAnchor.constraint(equalTo: view.leftAnchor),
            headerViewSheet.rightAnchor.constraint(equalTo: view.rightAnchor),
            headerViewSheet.bottomAnchor.constraint(equalTo: tableView.topAnchor)

        ])

        let rowHeight: CGFloat = 44
        let headerHeight: CGFloat = tableView.tableHeaderView?.frame.height ?? 0

        defaultContainerHeight = (rowHeight * CGFloat(dataArray.count)) + headerHeight + 20
        
        containerViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: defaultContainerHeight)
        containerViewBottomConstraint = tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: defaultContainerHeight)

        containerViewHeightConstraint?.isActive = true
        containerViewBottomConstraint?.isActive = true

    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = dataArray[indexPath.row]
        return cell
    }


}
