//
//  MessageDetailViewController.swift
//  hugo messages
//
//  Created by hugo on 11/16/16.
//  Copyright © 2016 hugosama. All rights reserved.
//

import UIKit

class MessageDetailViewController : UIViewController {
    var message : Message?
    
    @IBOutlet var txtMessage: UITextView!
    
    override func viewDidLoad() {
        txtMessage.text = message?.message
    }
    
}
