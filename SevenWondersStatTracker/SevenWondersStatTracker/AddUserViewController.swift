//
//  AddUserViewController.swift
//  SevenWondersStatTracker
//
//  Created by Martin Peshevski on 13.7.21.
//

import UIKit
import SnapKit

protocol AddUserViewControllerDelegate {
    func didAdd(user: User)
}

class AddUserViewController: UIViewController {
    var titleLabel: UILabel = {
        let l = UILabel()
        l.textColor = .label
        l.text = "Type a name for your new user"
        l.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        
        return l
    }()
    var textField: UITextField = {
        let t = UITextField()
        return t
    }()
    
    var content: UIStackView = {
       let s = UIStackView()
        s.axis = .vertical
        s.spacing = 20
        s.alignment = .leading
        
        return s
    }()
    
    var doneButton: UIButton = {
        let b = UIButton()
        b.setTitle("Done", for: .normal)
        b.setTitleColor(.label, for: .normal)
        b.backgroundColor = .systemGray5
        b.layer.cornerRadius = 20
        
        return b
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        modalPresentationStyle = .overCurrentContext
        
        doneButton.addAction(UIAction(handler: <#T##UIActionHandler##UIActionHandler##(UIAction) -> Void#>), for: <#T##UIControl.Event#>)
        
        content.addArrangedSubview(titleLabel)
        content.addArrangedSubview(textField)
        content.addArrangedSubview(UIView())
        content.addArrangedSubview(doneButton)
        
        view.addSubview(content)
        content.snp.makeConstraints { make in make.edges.equalTo(view.layoutMarginsGuide).inset(20) }
    }
}
