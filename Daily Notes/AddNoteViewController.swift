//
//  AddNoteViewController.swift
//  Daily Notes
//
//  Created by Maurício Oliveira on 14/02/2019.
//  Copyright © 2019 Maurício Oliveira. All rights reserved.
//

import UIKit
import CoreData

class AddNoteViewController: UIViewController {

    @IBOutlet weak var text: UITextView!
    var context: NSManagedObjectContext!
    var note: NSManagedObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //configuracoes iniciais (O TECLADO É AUTOMATICAMENTE MOSTRADO)
        self.text.becomeFirstResponder()
        
        if self.note != nil {
            showNote(note: self.note)
        } else {
            self.text.text = ""
        }

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.context = appDelegate.persistentContainer.viewContext
    }
    
    func showNote (note: NSManagedObject) {
        if let noteText = note.value(forKey: "text") {
            self.text.text = noteText as? String
        }
    }
    
    @IBAction func save(_ sender: Any) {
        
        if self.note != nil {
            self.updateNote(note: self.note)
        } else {
            self.saveNote()
        }
        
        //Return main view
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func updateNote(note: NSManagedObject) {
        note.setValue(self.text.text, forKey: "text")
        note.setValue(Date(), forKey: "date")
        
        do {
            try self.context.save()
        } catch let error as Error  {
            print("Error: " + error.localizedDescription)
        }
    }
    
    func saveNote() {
        //create object
        let newNote = NSEntityDescription.insertNewObject(forEntityName: "Note", into: self.context)
        
        newNote.setValue(self.text.text, forKey: "text")
        newNote.setValue(Date(), forKey: "date")
        
        do {
            try self.context.save()
            print("Success!")
        } catch let error as Error  {
            print("Error: " + error.localizedDescription)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
