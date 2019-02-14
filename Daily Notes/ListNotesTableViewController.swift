//
//  ListNotesTableViewController.swift
//  Daily Notes
//
//  Created by Maurício Oliveira on 14/02/2019.
//  Copyright © 2019 Maurício Oliveira. All rights reserved.
//

import UIKit
import CoreData

class ListNotesTableViewController: UITableViewController {
    
    var notes: [NSManagedObject] = []
    var context: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.context = appDelegate.persistentContainer.viewContext
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadNotes()
    }
    
    func loadNotes() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        
        do {
            let notesAux = try context.fetch(request)
            
            if notesAux.count > 0 {
                self.notes = notesAux as! [NSManagedObject]
            } else {
                notes = []
            }
            tableView.reloadData()
            
        } catch let error as Error {
            print (error.localizedDescription)
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notes.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseCell", for: indexPath)
        
        let note = notes[indexPath.row]
        
        if let noteText = note.value(forKey: "text") {
            
            if let noteDate = note.value(forKey: "date") {
                
                let dateFormat = DateFormatter()
                dateFormat.dateFormat = "dd/MM/yyyy hh:mm"
                
                let newDate = dateFormat.string(from: noteDate as! Date)
                
                cell.textLabel?.text = noteText as? String
                cell.detailTextLabel?.text = newDate
            }
        }
        
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let note = notes[indexPath.row]
            
            self.context.delete(note)
            
            do {
                try self.context.save()
                
                self.loadNotes()
            } catch let error as Error {
                print (error.localizedDescription)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        let note = self.notes[indexPath.row]
        
        performSegue(withIdentifier: "noteSegue", sender: note)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "noteSegue" {
            
            let vcDestiny = segue.destination as! AddNoteViewController
            
            vcDestiny.note = sender as? NSManagedObject
            
        }
        
    }
    
}
