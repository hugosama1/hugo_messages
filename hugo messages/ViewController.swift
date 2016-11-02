//
//  ViewController.swift
//  hugo messages
//
//  Created by hugo on 10/21/16.
//  Copyright © 2016 hugosama. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    var store : MessageStore!
    
    @IBOutlet var txtMessage: UITextField!
    
    override func viewDidLoad() {
        
        store.fetchMessages {
            (messagesResult) -> Void in
            print(messagesResult)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @IBAction func sendMessage(_ sender: UIButton) {
        if let text = self.txtMessage?.text,
            !text.isEmpty {
            print(text)
        }
        
    }
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }

}

