//
//  EntriesViewController.swift
//  Travelogue
//
//  Created by Max Taylor on 5/10/19.
//  Copyright © 2019 Max Taylor. All rights reserved.
//

import UIKit
import CoreData

class EntriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet weak var entriesTableView: UITableView!
    
    var trip: Trip?
    var entries = [Entry]()
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = trip?.name ?? ""
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateEntriesArray()
        entriesTableView.reloadData()
    }
    
    func alertNotifyUser(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func deleteEntry(at indexPath: IndexPath) {
        let entry = entries[indexPath.row]
        
        if let managedObjectContext = entry.managedObjectContext {
            managedObjectContext.delete(entry)
            
            do {
                try managedObjectContext.save()
                self.entries.remove(at: indexPath.row)
                entriesTableView.deleteRows(at: [indexPath], with: .automatic)
            } catch {
                alertNotifyUser(message: "Delete failed.")
                entriesTableView.reloadData()
            }
        }
    }
    
    func updateEntriesArray() {
        entries = trip?.entries?.sortedArray(using: [NSSortDescriptor(key: "name", ascending: true)]) as? [Entry] ?? [Entry]()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "entryCell", for: indexPath)
        
        if let cell = cell as? EntryTableViewCell {
            let entry = entries[indexPath.row]
            cell.nameLabel.text = entry.name
            if let dateAdded = entry.dateAdded {
                cell.dateAdded.text = dateFormatter.string(from: dateAdded)
            } else {
                cell.dateAdded.text = "unknown"
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") {
            action, index in
            self.deleteEntry(at: indexPath)
        }
        
        return [delete]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? EntryEditorViewController,
            let segueIdentifier = segue.identifier {
            destination.trip = trip
            if (segueIdentifier == "entry") {
                if let row = entriesTableView.indexPathForSelectedRow?.row {
                    destination.entry = entries[row]
                }
            }
        }
    }
}
