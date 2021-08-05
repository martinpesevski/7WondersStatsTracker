//
//  ViewController.swift
//  SevenWondersStatTracker
//
//  Created by Martin Peshevski on 2.7.21.
//

import UIKit
import SnapKit

struct CellModel {
    var type: CellType
    var row: ScoreType
    var column: Int
    var score: Int?
}

enum CellType {
    case score(text: String)
    case name(text: String)
    case total(text: String)
    case image(image: ScoreType)
    
    var alertText: String {
        switch self {
        case .score: return "Enter your score"
        case .name: return "Enter your name"
        case .total: return "Enter your total"
        case .image: return ""
        }
    }
    
    var keyboardStyle: UIKeyboardType {
        switch self {
        case .score: return .numberPad
        case .name: return .namePhonePad
        case .total: return .numberPad
        case .image: return .default
        }
    }
}

enum ScoreType: Int {
    case people = 0
    case army = 8
    case coins = 16
    case wonders = 24
    case blue = 32
    case yellow = 40
    case purple = 48
    case green = 56
    case sum = 64
    
    static func scoreType(index: Int) -> ScoreType {
        return ScoreType(rawValue: (index / 8) * 8) ?? .army
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .people: return .green.withAlphaComponent(0.3)
        case .army: return .red.withAlphaComponent(0.3)
        case .coins: return .orange.withAlphaComponent(0.3)
        case .wonders: return .brown.withAlphaComponent(0.3)
        case .blue: return .blue.withAlphaComponent(0.3)
        case .yellow: return .yellow.withAlphaComponent(0.3)
        case .purple: return .purple.withAlphaComponent(0.3)
        case .green: return .green.withAlphaComponent(0.3)
        case .sum: return .systemGray.withAlphaComponent(0.3)
        }
    }
    
    var image: UIImage? {
        switch self {
        case .people: return UIImage(named: "people")?.withRenderingMode(.alwaysTemplate)
        case .army: return nil
        case .coins: return UIImage(named: "coin")?.withRenderingMode(.alwaysTemplate)
        case .wonders: return UIImage(named: "wonder")?.withRenderingMode(.alwaysTemplate)
        case .blue: return nil
        case .yellow: return nil
        case .purple: return nil
        case .green: return nil
        case .sum: return UIImage(named: "add")?.withRenderingMode(.alwaysTemplate)
        }
    }
}

class CustomCell: UICollectionViewCell{
    var celltype: CellType = .name(text: "")
    var imageView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        return img
    }()
    var textLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .label
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        layer.borderColor = UIColor.label.cgColor
        layer.borderWidth = 2
        layer.cornerRadius = 5
        addSubview(imageView)
        imageView.snp.makeConstraints { make in make.edges.equalToSuperview() }

        addSubview(textLabel)
        textLabel.snp.makeConstraints { make in make.edges.equalToSuperview() }
    }
    
    func setup(model: CellModel) {
        celltype = model.type
        switch celltype {
        case .image(image: let scoreType):
            textLabel.isHidden = true
            imageView.isHidden = false
                imageView.backgroundColor = scoreType.backgroundColor
                if let image = scoreType.image {
                    imageView.image = image
                    imageView.tintColor = .label
                } else {
                    imageView.tintColor = .clear
                }
            backgroundColor = .red.withAlphaComponent(0.2)
        case .name(text: let text):
            setupTextLabel(text: text)
            backgroundColor = .blue.withAlphaComponent(0.2)
        case .score(text: let text):
            setupTextLabel(text: text)
            backgroundColor = .systemGray5
        case .total(text: let text):
            setupTextLabel(text: text)
            backgroundColor = .systemGray3
        }
    }
    
    func setupTextLabel(text: String) {
        imageView.isHidden = true
        textLabel.isHidden = false
        textLabel.text = text
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ViewController: UIViewController {
    var fields: [CellModel] = {
        var f: [CellModel] = []
        for i in 0..<72 {
            var model = CellModel(type: .score(text: ""), row: ScoreType.scoreType(index: i), column: i % 8, score: nil)
            if i % 8 == 0 { model.type = .image(image: ScoreType(rawValue: i) ?? .army)}
            else if i < 8 {  model.type = .name(text: "") }
            else if i > 64 { model.type = .total(text: "") }
            else {  model.type = .score(text: "") }
            f.append(model)
        }
        return f
    }()
    
    let databaseManager = DatabaseManager()
    
    var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 2
        
        flowLayout.minimumLineSpacing = 2
        flowLayout.itemSize = CGSize(width: (UIScreen.main.bounds.width / (8)) - 16, height: (UIScreen.main.bounds.height / (8)) - 16)
        
        let col = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        col.backgroundColor = .systemBackground
        col.register(CustomCell.self, forCellWithReuseIdentifier: "customCell")
        
        return col
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        collectionView.dataSource = self
        collectionView.delegate  = self
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
            make.top.equalToSuperview().inset(20)
        }
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as? CustomCell ?? CustomCell(frame: .zero)
        cell.setup(model: fields[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fields.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch fields[indexPath.item].type {
        case .image: return
        case .name: showNameDialog(indexPath: indexPath)
        case .score: showNameDialog(indexPath: indexPath)
        case .total: return
        }
    }
    
    func showNameDialog(indexPath: IndexPath) {
        
//        let alert = UIAlertController(title: fields[indexPath.row].type.alertText, message: nil, preferredStyle: .alert)
//        alert.addTextField { [weak self] field in
//            guard let self = self else { return }
//
//
//            field.delegate = self
//            field.keyboardType = self.fields[indexPath.row].type.keyboardStyle
//            field.tag = indexPath.item
//        }
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
//            alert.textFields?[0].endEditing(false)
//        }))
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        present(alert, animated: true, completion: nil)
        
        databaseManager.loadUsers { [weak self] users in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                let userSelection = UserSelectionViewController(dataManager: self.databaseManager)
                self.present(userSelection, animated: true, completion: nil)
            }
        }
        
    }
    
    func calculateTotal(_ forColumn: Int) {
        var total = 0
        for field in fields where field.column == forColumn {
            if let score = field.score { total += score }
        }
        
        for (index, _) in fields.enumerated() {
            let field = fields[index]
            if field.column == forColumn {
                switch field.type {
                case .total:
                    fields[index].type = .total(text: "\(total)")
                    collectionView.reloadData()
                default: break
                }
            }
        }
    }
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch fields[textField.tag].type {
        case .image: return
        case .name:
            databaseManager.loadUsers { [weak self] users in
                guard let self = self else { return }
                if users.filter({ user in user.name == textField.text }).isEmpty {
                    if let text = textField.text { self.databaseManager.addUser(User(name: text)) }
                }
            }
            fields[textField.tag].type = .name(text: textField.text ?? "")
        case .score:
            fields[textField.tag].type = .score(text: textField.text ?? "")
            fields[textField.tag].score = Int(textField.text ?? "0")
            calculateTotal(fields[textField.tag].column)
        case .total: return
        }
        collectionView.reloadData()
    }
}
