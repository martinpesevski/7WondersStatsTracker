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
    var delegate: AddUserViewControllerDelegate?
    
    lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.textColor = .label
        l.text = "Type a name for your new user"
        l.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        
        return l
    }()
    
    lazy var textField: UITextField = {
        let t = UITextField()
        t.placeholder = "Enter name"
        t.becomeFirstResponder()
        return t
    }()
    
    lazy var content: UIStackView = {
       let s = UIStackView(arrangedSubviews: [titleLabel, textField, UIView(), buttonStack])
        s.axis = .vertical
        s.spacing = 20
        s.alignment = .fill
        
        return s
    }()
    
    lazy var cancelButton: UIButton = {
        let b = UIButton()
        b.setTitle("Cancel", for: .normal)
        b.setTitleColor(.label, for: .normal)
        b.backgroundColor = .systemGray5
        b.layer.cornerRadius = 20
        b.addAction(UIAction(handler: { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }), for: .touchUpInside)
        
        return b
    }()
    
    lazy var doneButton: UIButton = {
        let b = UIButton()
        b.setTitle("Done", for: .normal)
        b.setTitleColor(.label, for: .normal)
        b.backgroundColor = .systemGray5
        b.layer.cornerRadius = 20
        b.addAction(UIAction(handler: { [weak self] _ in
            guard let text = self?.textField.text, !text.isEmpty else {
                let alert = UIAlertController(title: "Name cannot be empty", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    alert.dismiss(animated: false, completion: nil)
                }))
                self?.present(alert, animated: true, completion: nil)
                
                return
            }
            self?.delegate?.didAdd(user: User(name: text))
            self?.dismiss(animated: true, completion: nil)
        }), for: .touchUpInside)
        
        return b
    }()
    
    lazy var buttonStack: UIStackView = {
       let l = UIStackView(arrangedSubviews: [cancelButton, doneButton])
        l.axis = .horizontal
        l.distribution = .fillEqually
        l.spacing = 10
        return l
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        modalPresentationStyle = .overCurrentContext
        
        view.addSubview(content)
        view.backgroundColor = .systemBackground
        content.snp.makeConstraints { make in make.edges.equalTo(view.layoutMarginsGuide).inset(20) }
        NotificationCenter.default.addObserver(self,
               selector: #selector(onKeyboardChange(notification:)),
               name: UIResponder.keyboardWillChangeFrameNotification,
               object: nil)
    }
    
    @objc func onKeyboardChange(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }

        let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        
        content.snp.updateConstraints { make in
            make.bottom.equalTo(view.layoutMarginsGuide).inset((endFrame?.size.height ?? 0.0) + 20)
        }
    }
}
