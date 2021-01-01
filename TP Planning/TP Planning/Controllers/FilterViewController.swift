//
//  FilterViewController.swift
//  TP Planning
//
//  Created by Vinit Ingale on 12/30/20.
//

import UIKit
import IQDropDownTextField

class FilterViewController: UIViewController, IQDropDownTextFieldDelegate {

    @IBOutlet weak var categoryTF: IQDropDownTextField!
    @IBOutlet weak var subCategoryTF: IQDropDownTextField!
    @IBOutlet weak var leafCategoryTF: IQDropDownTextField!
    
    var selectedCategory: Category?
    var selectedSubCategory: SubCategory?
    var selectedLeaftCategory: LeafCategory?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryTF.delegate = self
        categoryTF.tag = 0
        
        subCategoryTF.delegate = self
        subCategoryTF.tag = 1
        
        leafCategoryTF.delegate = self
        leafCategoryTF.tag = 2
        
        categoryTF.isOptionalDropDown = false
        subCategoryTF.isOptionalDropDown = false
        leafCategoryTF.isOptionalDropDown = false

        categoryTF.itemList = HomeMainDataHelper.shared.categories.map({ $0.name })
        selectedCategory = HomeMainDataHelper.shared.categories.first
        
        setUpSubCategory()
        setUpLeafCategory()
    }
    
    func textField(_ textField: IQDropDownTextField, didSelectItem item: String?) {
        if textField.tag == 0 {
            selectedCategory = HomeMainDataHelper.shared.categories.filter({$0.name == item}).first
            setUpSubCategory()
        } else if textField.tag == 1 {
            selectedSubCategory = selectedCategory?.subCategory?.filter({$0.name == item}).first
            setUpLeafCategory()
        } else {
            selectedLeaftCategory = selectedSubCategory?.leafCategory?.filter({$0.name == item}).first
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func backButtonClicked(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    func setUpSubCategory() {
        subCategoryTF.isUserInteractionEnabled = false
        
        if let subCategrogies = selectedCategory?.subCategory, subCategrogies.count > 0 {
            subCategoryTF.isUserInteractionEnabled = true
            subCategoryTF.selectedRow = 0
            subCategoryTF.itemList = subCategrogies.map({ $0.name })
            selectedSubCategory = selectedCategory?.subCategory?.first
        } else {
            selectedSubCategory = nil
            selectedLeaftCategory = nil
            subCategoryTF.itemList = nil
        }
        setUpLeafCategory()
    }
    
    func setUpLeafCategory() {
        leafCategoryTF.isUserInteractionEnabled = false

        if let leafCategrogies = selectedSubCategory?.leafCategory, leafCategrogies.count > 0 {
            leafCategoryTF.isUserInteractionEnabled = true
            leafCategoryTF.selectedRow = 0
            leafCategoryTF.itemList = leafCategrogies.map({ $0.name })
            selectedLeaftCategory = selectedSubCategory?.leafCategory?.first
        } else {
            selectedLeaftCategory = nil
            leafCategoryTF.itemList = nil
        }
    }
    
    @IBAction func applyFilterButtonClicked(_ sender: UIButton) {
        if let docVC = storyboard?.instantiateViewController(withIdentifier: "DocListViewController") as? DocListViewController {
            docVC.modalPresentationStyle = .fullScreen
            docVC.selectedCategory = selectedCategory
            docVC.selectedSubCategory = selectedSubCategory
            docVC.selectedLeaftCategory = selectedLeaftCategory
            present(docVC, animated: true, completion: nil)
        }
    }
    
}

extension FilterViewController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return false
    }
}
