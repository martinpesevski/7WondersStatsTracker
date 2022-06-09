//
//  AddScoreViewController.swift
//  SevenWondersStatTracker
//
//  Created by Martin Peshevski on 5.8.21.
//

import UIKit
import SnapKit

protocol AddScoreViewControllerDelegate {
    func didAdd(score: Int, indexPath: IndexPath)
}

class AddScoreViewController: UIViewController {
    var delegate: AddScoreViewControllerDelegate?
    var bottomConstraint: ConstraintMakerEditable?
    
    lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.textColor = .label
        l.text = "Enter your score"
        l.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        
        return l
    }()
    
    lazy var textField: UITextField = {
        let t = UITextField()
        t.placeholder = "Enter score"
        t.keyboardType = .numberPad
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
            guard let self = self else { return }
            guard let text = self.textField.text, !text.isEmpty, let score = Int(text) else {
                let alert = UIAlertController(title: "Please enter a valid score", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    alert.dismiss(animated: false, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
                
                return
            }
            self.delegate?.didAdd(score: score, indexPath: self.indexPath)
            self.dismiss(animated: true, completion: nil)
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
    
    let indexPath: IndexPath
    
    init(indexPath: IndexPath) {
        self.indexPath = indexPath
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        modalPresentationStyle = .overCurrentContext
        
        view.addSubview(content)
        view.backgroundColor = .systemBackground
        content.snp.makeConstraints { make in
            make.top.left.right.equalTo(view.layoutMarginsGuide).inset(20)
            bottomConstraint = make.bottom.equalTo(view.layoutMarginsGuide).inset(20)
        }
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
