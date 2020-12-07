//
//  NoteViewController.swift
//  Reminder
//
//  Created by Sachdave Singh on 12/6/20.
//

import UIKit

class NoteViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
       @IBOutlet var noteLabel: UITextView!

       public var noteTitle: String = ""
       public var note: String = ""

       override func viewDidLoad() {
           super.viewDidLoad()
           titleLabel.text = noteTitle
           noteLabel.text = note
        
    
       }
}
