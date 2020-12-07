//
//  SecondViewController.swift
//  Reminder
//
//  Created by Sachdave Singh on 11/27/20.
//

import UIKit
import CoreData

class SecondViewController: UIViewController {

    @IBOutlet weak var secondVCLabel: UILabel!
    @IBOutlet weak var todoDescription: UITextField!
    @IBOutlet weak var todoInput: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var todoItem = String()
    
    public var completion: ((String,String,Date) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // save text input to core data whenever button is clicked
    @IBAction func saveButtonClicked(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        let newItem = NSEntityDescription.insertNewObject(forEntityName: "TodoList", into: context)
        
        newItem.setValue(todoInput.text!, forKey: "todo")
        newItem.setValue(todoDescription.text!, forKey: "describe")
        newItem.setValue(UUID(), forKey: "id")
        newItem.setValue(datePicker.date, forKey: "date")
        
        if let titleText = todoInput.text, !titleText.isEmpty,
           let bodyText = todoDescription.text, !bodyText.isEmpty {
           
           let targetDate = datePicker.date
            
           completion?(titleText,bodyText, targetDate)
            
        }
        
        do {
            try context.save()
        } catch {
          print("error")
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("newTodo"), object: nil)
        //navigationController?.popViewController(animated: true)
        performSegue(withIdentifier: "backtoReminder", sender: nil)
    }

}
