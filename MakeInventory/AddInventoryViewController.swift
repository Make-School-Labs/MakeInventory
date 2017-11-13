//
//  AddInventoryViewController.swift
//  MakeInventory
//
//  Created by Eliel A. Gordon on 11/12/17.
//  Copyright © 2017 Eliel Gordon. All rights reserved.
//

import UIKit

class AddInventoryViewController: UIViewController {
    let coreDataStack = CoreDataStack.instance
    
    @IBOutlet weak var departmentPicker: UIPickerView!
    @IBOutlet weak var inventoryNameField: UITextField!
    @IBOutlet weak var inventoryQuantityField: UITextField!
    var departments = [
        "HR",
        "Instructors",
        "Finance"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        departmentPicker.delegate = self
        departmentPicker.dataSource = self
    }
    
    @IBAction func savePressed(_ sender: Any) {
        guard let name = inventoryNameField.text, let quantity = Int64(inventoryQuantityField.text!) else {return}
        
        // Inventories
        let inv = Inventory(
            context: coreDataStack.privateContext
        )
        
        inv.name = name
        inv.quantity = quantity
        
        let department = Department(
            context: coreDataStack.privateContext
        )
        
        let selectedRow = departmentPicker.selectedRow(inComponent: 0)
        let departmentName = departments[selectedRow]
        
        department.name = departmentName
        
        inv.department = department
        
        coreDataStack.saveTo(context: coreDataStack.privateContext)
        
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension AddInventoryViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return departments.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return departments[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
}
