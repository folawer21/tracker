//
//  Colors.swift
//  tracker
//
//  Created by Александр  Сухинин on 23.07.2024.
//

import UIKit

struct Colors {
    //StubView
    static let stubTextLabelColor = UIColor { (traits: UITraitCollection) -> UIColor in
        if traits.userInterfaceStyle == .light {
            return UIColor.black
        } else {
            return UIColor.white
        }
    }
    
    //TrackerVC
    static let blackBackgroundColor = UIColor.trackersVCBackground
    static let datePickerColor =  UIColor(named: "datePickerColor")

    static let addButtonColor =  UIColor(named: "addButtonColor")
    static let trackCellText = UIColor(named: "addButtonColor")
    //TabBar
    static let tabBarBorderColor = UIColor { (traits: UITraitCollection) -> UIColor in
        if traits.userInterfaceStyle == .light {
            return UIColor.ypGray
        } else {
            return UIColor.trackersVCBackground
        }
    }
    
    //TrackerCreatingVC
    static let trackerCreatingVCbuttonsColors = UIColor(named: "trackerCreatingButtonsColors")
    static let trackerCreatingVCbuttonsTextColors = UIColor(named: "trackerCreatingVCbuttonsTextColors")
    
    //Create habbit/event VC
    static let headerCollectionViewColor = UIColor(named: "headerCollectionColor")
    static let createHabbitEventSecondaryColor = UIColor(named: "createHabbitEventSecondaryColor")
    
    //EmojiCells
    static let emojiBlockColor = UIColor(named: "EmojiBlock")
    static let emojiColor = UIColor(named: "emojiColor")
    
    //CancelCreateButtonCell
    static let createButtonColor = UIColor(named: "addButtonColor")
    static let cancelButtonTextAndBorder = UIColor(named: "RedForBottoms")
    static let createButtonTextColorEnabled = UIColor(named: "createCancelButtonTextColorEnabled")
    static let createButtonTextColorDisabled = UIColor(named: "createCancelButtonTextColorDisabled")
    
    //TimetableVC
    
    static let separatorColor = UIColor(named: "separatorColor")
    
    static let gradientBlue = UIColor(named: "gradientBlue")
    static let gradientGreen = UIColor(named: "gradientGreen")
    static let gradientRed = UIColor(named: "gradientRed")
    static let white = UIColor.white
    static let filter_blue = UIColor.blue
}
