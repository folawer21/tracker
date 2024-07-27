//
//  TrackCell.swift
//  tracker
//
//  Created by Александр  Сухинин on 29.05.2024.
//
//
import UIKit
import YandexMobileMetrica

protocol TrackCellDelegateProtocol: AnyObject {
    func deleteTrackerRecord(id: UUID)
    func addTrackerRecord(id: UUID)
    func deleteTracker(id: UUID?)
    func editTracker(id: UUID?)
    func pinTracker(id: UUID?, pinned: Bool)
}

final class TrackCell: UICollectionViewCell {
    // Цветной блок
    private let colorBlock = UIView()
    private let emodji = UILabel()
    private let emodjiBlock = UIView()
    private let nameLabel = UILabel()
    private let pinImage = UIImageView()
    // Белый блок
    private let infoBlock = UIView()
    let daysLabel = UILabel()
    let plusButton = UIButton()
    var buttonWasTapped = false
    var trackerId: UUID?
    var pinned = false
    private let plusImage = UIImage(named: "plus")?.withRenderingMode(.alwaysTemplate)
    private let doneImage = UIImage(named: "Done")?.withRenderingMode(.alwaysTemplate)
    weak var delegate: TrackCellDelegateProtocol?

    func configCell(track: Tracker, days: Int, isDone: Bool, availible: Bool, isPinned: Bool ) {
        pinned = isPinned
        setupContextMenu()
        trackerId = track.id
        emodji.text = track.emoji
        nameLabel.text = track.name
        colorBlock.backgroundColor = track.color
        plusButton.tintColor = track.color
        configScreen()
        if track.type == .habbit {
            configStateHabbit(isDone: isDone, availible: availible)
        }
        if track.type == .single {
            configStateSingle(isDone: isDone, availible: availible)
        }
        changeText(daysCount: days)
    }

    private func setupContextMenu() {
        let interaction = UIContextMenuInteraction(delegate: self)
        self.addInteraction(interaction)
    }
    func togglePinned() {
        self.pinned.toggle()
    }
    private func configStateHabbit(isDone: Bool, availible: Bool ) {
        plusButton.layer.opacity = 1
        if isDone {
            buttonWasTapped = true
            plusButton.isSelected = true
            plusButton.layer.opacity = 0.3
            enableButton()
        } else {
            if availible {
                buttonWasTapped = false
                plusButton.isSelected = false
                enableButton()
            } else {
                buttonWasTapped = false
                plusButton.isSelected = false
                plusButton.layer.opacity = 0.3
                disableButton()
            }
        }
    }

    private func configStateSingle(isDone: Bool, availible: Bool) {
        plusButton.layer.opacity = 1
        if isDone && availible {
            buttonWasTapped = true
            plusButton.isSelected = true
            plusButton.layer.opacity = 0.3
            enableButton()
        }
        if isDone && !availible {
            buttonWasTapped = true
            plusButton.isSelected = true
            plusButton.layer.opacity = 0.3
            disableButton()
            plusButton.imageView?.image = doneImage
        }
        if !isDone && availible {
            buttonWasTapped = false
            plusButton.isSelected = false
            enableButton()
        }
        if !isDone && !availible {
            buttonWasTapped = false
            plusButton.isSelected = false
            plusButton.layer.opacity = 0.3
            disableButton()
        }
    }
    private func changeText(daysCount: Int) {
        let daysString = String.localizedStringWithFormat(
            NSLocalizedString("number_of_days", comment: ""),
            daysCount
        )
        daysLabel.text = daysString
    }
    func enableButton() {
        plusButton.isEnabled = true
    }
    func disableButton() {
        plusButton.isEnabled = false
    }
    @objc func buttonTapped() {
        guard let id = trackerId else {return}
        let params: [AnyHashable: Any] = ["screen": "Main", "item": "track"]
        YMMYandexMetrica.reportEvent("click", parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
        if buttonWasTapped {
            delegate?.deleteTrackerRecord(id: id)
        } else {
            delegate?.addTrackerRecord(id: id)
        }
    }
}

extension TrackCell {
    func configScreen() {
        addSubViews()
        applyConstraints()
        configButton()
        translateToFalse()
        pinImage.image = UIImage(named: "pinImage")
        pinImage.contentMode = .scaleAspectFit
        pinImage.translatesAutoresizingMaskIntoConstraints = false
        pinImage.isHidden = !pinned
        emodjiBlock.backgroundColor = .white.withAlphaComponent(0.3)
        emodjiBlock.layer.cornerRadius = 12
        emodjiBlock.layer.masksToBounds = true
        colorBlock.layer.cornerRadius = 16
        infoBlock.backgroundColor = Colors.blackBackgroundColor
        daysLabel.numberOfLines = 2
        daysLabel.textColor = Colors.trackCellText
        daysLabel.font = .systemFont(ofSize: 12)
        nameLabel.textColor = .white
        emodji.font =  UIFont.systemFont(ofSize: 14)
        emodji.textAlignment = .center
    }

    func translateToFalse() {
        colorBlock.translatesAutoresizingMaskIntoConstraints = false
        emodji.translatesAutoresizingMaskIntoConstraints = false
        emodjiBlock.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        infoBlock.translatesAutoresizingMaskIntoConstraints = false
        daysLabel.translatesAutoresizingMaskIntoConstraints = false
        plusButton.translatesAutoresizingMaskIntoConstraints = false
    }

    func addSubViews() {
        contentView.addSubview(colorBlock)
        contentView.addSubview(infoBlock)
        colorBlock.addSubview(emodjiBlock)
        colorBlock.addSubview(nameLabel)
        colorBlock.addSubview(pinImage)
        infoBlock.addSubview(daysLabel)
        infoBlock.addSubview(plusButton)
        emodjiBlock.addSubview(emodji)
    }

    func applyConstraints() {
        NSLayoutConstraint.activate([
            colorBlock.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            colorBlock.topAnchor.constraint(equalTo: contentView.topAnchor),
            colorBlock.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            colorBlock.bottomAnchor.constraint(equalTo: infoBlock.topAnchor),
            infoBlock.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            infoBlock.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            infoBlock.topAnchor.constraint(equalTo: colorBlock.bottomAnchor),
            infoBlock.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            pinImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            pinImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            pinImage.widthAnchor.constraint(equalToConstant: 24),
            pinImage.heightAnchor.constraint(equalToConstant: 24),

            emodjiBlock.leadingAnchor.constraint(equalTo: colorBlock.leadingAnchor, constant: 12),
            emodjiBlock.topAnchor.constraint(equalTo: colorBlock.topAnchor, constant: 12),
            emodjiBlock.heightAnchor.constraint(equalToConstant: 24),
            emodjiBlock.widthAnchor.constraint(equalToConstant: 24),

            emodji.centerXAnchor.constraint(equalTo: emodjiBlock.centerXAnchor),
            emodji.centerYAnchor.constraint(equalTo: emodjiBlock.centerYAnchor),

            nameLabel.leadingAnchor.constraint(equalTo: colorBlock.leadingAnchor, constant: 12),
            nameLabel.bottomAnchor.constraint(equalTo: colorBlock.bottomAnchor, constant: -12),
            nameLabel.trailingAnchor.constraint(equalTo: colorBlock.trailingAnchor, constant: -12),
            nameLabel.topAnchor.constraint(equalTo: emodjiBlock.bottomAnchor, constant: 8),

            daysLabel.leadingAnchor.constraint(equalTo: infoBlock.leadingAnchor, constant: 14),
            daysLabel.bottomAnchor.constraint(equalTo: infoBlock.bottomAnchor, constant: -24),
            daysLabel.trailingAnchor.constraint(equalTo: plusButton.leadingAnchor, constant: -8),
            daysLabel.topAnchor.constraint(equalTo: infoBlock.topAnchor, constant: 16),

            plusButton.leadingAnchor.constraint(equalTo: daysLabel.trailingAnchor, constant: 8),
            plusButton.topAnchor.constraint(equalTo: infoBlock.topAnchor, constant: 8),
            plusButton.trailingAnchor.constraint(equalTo: infoBlock.trailingAnchor, constant: -12),
            plusButton.bottomAnchor.constraint(equalTo: infoBlock.bottomAnchor, constant: -16),
            plusButton.widthAnchor.constraint(equalToConstant: 34),
            plusButton.heightAnchor.constraint(equalToConstant: 34)
        ])
    }
    func configButton() {
        plusButton.setImage(plusImage, for: .normal)
        plusButton.setImage(doneImage, for: .selected)
        plusButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
}

extension TrackCell: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(
        _ interaction: UIContextMenuInteraction,
        configurationForMenuAtLocation location: CGPoint
    ) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self ] _ in
            var pinString = ""
            if self?.pinned == false {
                pinString = NSLocalizedString("pin_cell", comment: "")
            } else {
                pinString = NSLocalizedString("unpin_cell", comment: "")
            }
            let action1 = UIAction(title: pinString ) { [weak self] _ in
                guard let self = self else {return }
                self.delegate?.pinTracker(id: self.trackerId, pinned: self.pinned)
                self.togglePinned()
            }
            let action2 = UIAction(title: NSLocalizedString("edit_cell", comment: "")) { [weak self] _ in
                let params: [AnyHashable: Any] = ["screen": "Main", "item": "edit"]
                YMMYandexMetrica.reportEvent("click", parameters: params, onFailure: { error in
                    print("REPORT ERROR: %@", error.localizedDescription)
                })
                self?.delegate?.editTracker(id: self?.trackerId)
            }
            let action3 = UIAction(title: "") { [weak self] _ in
                let params: [AnyHashable: Any] = ["screen": "Main", "item": "delete"]
                YMMYandexMetrica.reportEvent("click", parameters: params, onFailure: { error in
                    print("REPORT ERROR: %@", error.localizedDescription)
                })
                self?.delegate?.deleteTracker(id: self?.trackerId)
            }
            action3.setValue(
                NSAttributedString.coloredString(NSLocalizedString("delete_cell", comment: ""), color: .red),
                forKey: "attributedTitle"
            )
            return UIMenu(title: "", children: [action1, action2, action3])
        }
    }
}

extension NSAttributedString {
    static func coloredString(_ text: String, color: UIColor) -> NSAttributedString {
        return NSAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor: color])
    }
}
