//
//  TrackNameCell.swift
//  tracker
//
//  Created by Александр  Сухинин on 29.05.2024.
//
import UIKit

protocol TrackNameCellDelegateProtocol: AnyObject{
    func textFieldDidChange(text: String)
}

final class TrackNameCell: UICollectionViewCell{
    let textField = UITextField()
    weak var textFieldDelegate: TrackNameCellDelegateProtocol?
    override init(frame: CGRect){
        super.init(frame: frame)
        let textFieldPlaceholder = NSLocalizedString("trackname_cell_placeholder", comment: "")
        textField.placeholder = textFieldPlaceholder
        textField.clearsOnBeginEditing = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.cornerRadius = 16
        textField.backgroundColor = UIColor(named: "TextFieldColor")
        textField.indent(size: 10)
        textField.delegate = self
        contentView.addSubview(textField)
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            textField.topAnchor.constraint(equalTo: contentView.topAnchor),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getName() -> String?{
        return textField.text
    }
}

extension TrackNameCell: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
         let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
         textFieldDelegate?.textFieldDidChange(text: newText)
         return true
     }
}

