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
    
    @IBOutlet var txtMessage: UITextView!
    
    override func viewDidLoad() {
        txtMessage.layer.cornerRadius = 5
        txtMessage.layer.borderColor = UIColor.black.cgColor
        txtMessage.layer.borderWidth = 1
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    /// sends a message
    ///
    /// - Parameter sender: button
    @IBAction func sendMessage(_ sender: UIButton) {
        if let text = self.txtMessage?.text,
            !text.isEmpty {
            store.saveMessage(message: text, completion: { (messageResult) in
                switch(messageResult) {
                    case let .failure(error) :
                        print(error)
                        break
                    case let .successNew(message) :
                        print(message)
                        break
                    default:break
                }
                DispatchQueue.main.async {
                   _ = self.navigationController?.popToRootViewController(animated: true)
                }
            })
        }
        
    }
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }

}

