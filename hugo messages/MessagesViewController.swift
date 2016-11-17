//
//  MessagesViewController.swift
//  hugo messages
//
//  Created by hugo on 11/16/16.
//  Copyright © 2016 hugosama. All rights reserved.
//


import UIKit
class MessagesViewController: UITableViewController {
    
    var store : MessageStore!
    
    override func viewDidLoad() {
        store.fetchMessages {
            (messagesResult) -> Void in
            self.updateDataSource()
        }
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get a new or recycled cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell",for: indexPath)
        // Set the text on the cell with the description of the item
        // that is at the nth index of items, where n = row this cell
        // will appear in on the tableview
        let message = store.allMessages[indexPath.row]
        // Configure the cell with the Item
        cell.textLabel?.text = String(message.id)
        cell.detailTextLabel?.text = message.message
        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return store.allMessages.count
    }
    
    func updateDataSource() {
        store.fetchAllMessages { (messagesResult)  in
            switch(messagesResult) {
                case let .success(messages):
                    self.store.allMessages = messages
                    self.tableView.reloadData()
                case .failure(_):break
            }
        }        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showMessage"?:
            // Figure out which row was just tapped
            if let row = tableView.indexPathForSelectedRow?.row {
                let detailViewController = segue.destination as! MessageDetailViewController
                // Get the item associated with this row and pass it along
                let message = store.allMessages[row]
                detailViewController.message = message
            }
        case "showNewMessage"?:
            let newMessageController = segue.destination as! ViewController
            newMessageController.store = store
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    
    
}
