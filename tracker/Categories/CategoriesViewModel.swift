//
//  CategoriesViewModel.swift
//  tracker
//
//  Created by Александр  Сухинин on 13.07.2024.
//

import Foundation

typealias Binding<T> = (T) -> Void

class CategoriesViewModel{
    var onCreationAllowedStateChange: Binding<Bool>?
    var onPickedCategoryChanged: Binding<String>?
    private var pickedCategory: String?
    let model = TrackerCategoryStore(day: .monday)
    func getCategoristCount() -> Int{
        return model.categoriesCount
    }
    func setTrackerStore(){
        let trackerStore = TrackerStore(day: .saturday)
        model.setTrackerStore(trackerStore: trackerStore)
    }
    
    func getCategoryName(index: Int) -> String{
        setTrackerStore()
        return model.getCategoryName(section: index)
    }
    func getCategoryNameVC(index: Int) -> String{
        setTrackerStore()
        return model.getCategoryNameVC(section: index)
    }
    
    func createNewCategory(categoryName: String){
        setTrackerStore()
        model.newCategory(categoryName: categoryName)
    }
    func isCategoryChosen(index: Int) -> Bool{
        setTrackerStore()
        return model.getCategoryNameVC(section: index) == pickedCategory ? true : false
    }
    
    func setPickedCategory(name: String){
        pickedCategory = name
        onPickedCategoryChanged?(name)
    }
    
    func getPickedCategory() -> String?{
        pickedCategory
    }

    func textFieldDidChange(categoryName: String){
        if categoryName == ""{
            onCreationAllowedStateChange?(false)
        } else {
            onCreationAllowedStateChange?(true)
        }
    }
    
    func isEmpty() -> Bool{
        return model.isEmpty
    }
    
}
