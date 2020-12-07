//
//  ViewController.swift
//  Reminder
//
//  Created by Sachdave Singh on 11/27/20.
//

import UIKit
import CoreData
import UserNotifications

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
    @IBOutlet weak var tableView: UITableView!
    
    var todoArr = [String]()
    var todoIDArr = [UUID]()
    var todoDesArr = [String]()
    var todoDateArr = [Date]()
    var models = [MyReminder]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        //add a plus sign shaped button to the top of the navigation controller that the user clicks
        //to add an item
        //navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(didTapAdd))
        
        //call get data
        getData()
    }
    
    //update the table view when a table item is added
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name("newTodo"), object: nil )
        
        //new lines added
//        if let selectedIndexPath = tableView.indexPathForSelectedRow {
//            tableView.deselectRow(at: selectedIndexPath, animated: true)
//        }
        
        // till here
    }
    
    // new
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let selectedTrail = todoArr[indexPath.row]
//
//        if let viewController = storyboard?.instantiateViewController(identifier: "add") as? SecondViewController {
////            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TodoList")
////
////            let idStr = todoIDArr[indexPath.row].uuidString
////            let appDelegate = UIApplication.shared.delegate as! AppDelegate
////            let context = appDelegate.persistentContainer.viewContext
////            request.predicate = NSPredicate(format: "id = %@", idStr)
////
////            if request.predicate.text == MyReminder.identifier {
////
//
//
//
//            viewController.todoItem = selectedTrail
//            viewController.todoInput?.text = todoArr[indexPath.row]
//            viewController.todoDescription?.text = todoDesArr[indexPath.row]
//            //viewController.datePicker = todoDateArr[indexPath.row]
//            navigationController?.pushViewController(viewController, animated: true)
//        }
//    }
//
    // new till here
    
    //number of rows in the table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numRows = todoArr.count
        return numRows
    }
    //inset each todo item into a cell in the table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = todoArr[indexPath.row]
        return cell
    }
    
    //get data from core data using a fetch request
    @objc func getData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName:"TodoList")
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                self.todoArr.removeAll(keepingCapacity: false)
                self.todoIDArr.removeAll(keepingCapacity: false)
                self.todoDesArr.removeAll(keepingCapacity: false)
                self.todoDateArr.removeAll(keepingCapacity: false)
            }
            for result in results as! [NSManagedObject] {
                if let todo = result.value(forKey: "todo") as? String {
                    todoArr.append(todo)
                }
                if let id = result.value(forKey: "id") as? UUID {
                    todoIDArr.append(id)
                }
                if let describe = result.value(forKey: "describe") as? String {
                    todoDesArr.append(describe)
                }
                if let date = result.value(forKey: "date") as? Date {
                    todoDateArr.append(date)
                }
            }
            //refresh table view
            tableView.reloadData()
        } catch {
            print("error")
        }
    }
    
    //perform segue to the second VC
    //@objc func addButtonClicked() {
      //  performSegue(withIdentifier: "toSecondVC", sender: nil)
    //}
    
    @IBAction func didTapTest(_ sender: Any) {
        //fire test notfi
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: {success, error in
            if success {
                //schedule test
                self.scheduleTest()
            } else if error != nil {
                print("error occured")
            }
        })
    }
    
    func scheduleTest() {
        let content = UNMutableNotificationContent()
        content.title = "Hello World"
        content.sound = .default
        content.body = "this shit fuckin works??"
        
        let targetDate = Date().addingTimeInterval(10)
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second], from: targetDate), repeats: false)
        
        let request = UNNotificationRequest(identifier: "some_long_id", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: {error in
            if error != nil {
                print("something went wrong")
            }
        })
    }
    
    @IBAction func didTapAdd(_ sender: Any) {
        //show add vc
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: {success, error in
            if success {
                //schedule test
                self.scheduleTest2()
            } else if error != nil {
                print("error occured")
            }
        })
    }
    
    func scheduleTest2() {
        DispatchQueue.main.async {
               //do UIWork here
            guard let vc = self.storyboard?.instantiateViewController(identifier: "add") as? SecondViewController else {
                        return
                    }

                    vc.title = "New Reminder"
                    vc.navigationItem.largeTitleDisplayMode = .never
                    vc.completion = { title, body, date in
                        DispatchQueue.main.async {
                            self.navigationController?.popToRootViewController(animated: true)
                            let new = MyReminder(title: title, date: date, identifier: "id_\(title)")
                            self.models.append(new)
                            self.tableView.reloadData()

                            let content = UNMutableNotificationContent()
                            content.title = title
                            content.sound = .default
                            content.body = body

                            let targetDate = date
                            let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second],
                                                                                                    from: targetDate),
                                                repeats: false)

                            let request = UNNotificationRequest(identifier: "some_long_id", content: content, trigger: trigger)
                            UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
                                if error != nil {
                                    print("something went wrong")
                                }
                            })
                        }
                    }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    //delete func
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            let context = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TodoList")
            
            let idStr = todoIDArr[indexPath.row].uuidString
            
            request.predicate = NSPredicate(format: "id = %@", idStr)
            
            request.returnsObjectsAsFaults = false
            
            do {
                let results = try context.fetch(request)
                if results.count > 0 {
                     
                    for result in results as! [NSManagedObject] {
                        if let id = result.value(forKey: "id") as? UUID{
                            //remove values from the table view
                            if id == todoIDArr[indexPath.row] {
                                context.delete(result)
                                todoArr.remove(at: indexPath.row)
                                todoIDArr.remove(at: indexPath.row)
                                todoDesArr.remove(at: indexPath.row)
                                todoDateArr.remove(at: indexPath.row)
                                self.tableView.reloadData()
                            }
                            do {
                                try context.save()
                            } catch {
                                print("Error")
                            }
                            //end loop
                            break
                        }
                    }
                }
                
            } catch {
                print("error")
            }
            
        }
    
    struct MyReminder {
        let title: String
        let date: Date
        let identifier: String
    }
    
    }
