//
//  File.swift
//  SevenWondersStatTracker
//
//  Created by Martin Peshevski on 13.7.21.
//

import UIKit
import SnapKit

protocol UserSelectionDelegate: AnyObject {
    func didSelectUsers(_ users: [User])
}

class UserSelectionViewController: UIViewController {
    var delegate: UserSelectionDelegate?
    
    var tableView: UITableView = {
        let table = UITableView()
        table.allowsMultipleSelection = true
        table.tableFooterView = UIView() //hide empty cells

        return table
    }()
    
    var addButton: UIButton = {
        let b = UIButton()
        b.setTitle("New user", for: .normal)
        b.setTitleColor(.label, for: .normal)
        b.backgroundColor = .systemGray5
        b.layer.cornerRadius = 20
        
        return b
    }()
    
    var doneButton: UIButton = {
       let b = UIButton()
        b.setTitle("Done", for: .normal)
        b.setTitleColor(.label, for: .normal)
        b.backgroundColor = .systemGray5
        b.layer.cornerRadius = 20

        return b
    }()
    
    var butonStack: UIStackView = {
        let s = UIStackView()
        s.axis = .horizontal
        s.distribution = .fillEqually
        s.spacing = 10
        return s
    }()
    
    var contentStack: UIStackView = {
        let s = UIStackView()
        s.axis = .vertical
        s.spacing = 10
        return s
    }()
    
    var dataManager: DatabaseManager
    
    init(dataManager: DatabaseManager) {
        self.dataManager = dataManager
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        modalPresentationStyle = .overFullScreen
        view.backgroundColor = .systemBackground
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "userCell")
        
        addButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            self.onAdd()
        }), for: .touchUpInside)
        
        doneButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            self.onDone()
        }), for: .touchUpInside)
                
        butonStack.addArrangedSubview(addButton)
        butonStack.addArrangedSubview(doneButton)
        
        contentStack.addArrangedSubview(tableView)
        contentStack.addArrangedSubview(butonStack)
        view.addSubview(contentStack)
        
        for (index, user) in dataManager.users.enumerated() where dataManager.selectedUsers.contains(user) {
            tableView.selectRow(at: IndexPath(row: index, section: 0), animated: false, scrollPosition: .none)
        }
        
        contentStack.snp.makeConstraints { make in make.edges.equalTo(view.layoutMarginsGuide).inset(20) }
    }
    
    func onAdd() {
        let addUserVC = AddUserViewController()
        addUserVC.delegate = self
        present(addUserVC, animated: true, completion: nil)
    }
    
    func onDone() {
        if let rows = tableView.indexPathsForSelectedRows {
            var selected: [User] = []
            for row in rows {
                selected.append(dataManager.users[row.row])
            }
            delegate?.didSelectUsers(selected)
        }
        dismiss(animated: true, completion: nil)
    }
}

extension UserSelectionViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath)
        cell.textLabel?.text = dataManager.users[indexPath.row].name
        cell.backgroundColor = .systemGray5
        cell.layer.cornerRadius = 20
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.users.count
    }
}

extension UserSelectionViewController: AddUserViewControllerDelegate {
    func didAdd(user: User) {
        dataManager.addUser(user)
        tableView.reloadData()
    }
}
