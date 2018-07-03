////  FeedCommentComponent.swift
//  UIComponent_Example
//
//  Created by labs01 on 7/3/18.
//  Copyright © LabianLabs 2015
//

import Foundation
import UIComponent
import UIKit

struct Data {
    var url: String
    var message: String
    init(url: String, message: String) {
        self.url = url
        self.message = message
    }
}

public class FeedCommentComponent: UIViewComponent {
    override public func setup() {
        super.setup()
        inputTextView.layer.cornerRadius = 
    }
    override public func update() {
        super.update()
        guard let value  = self.value as? Data else {
            return
        }
        avatarImageView.image = UIImage(named: value.url)
        if value.message != "" {
            messageLabel.text = value.message
            inputTextView.isHidden = true
        } else {
            messageView.isHidden = true
        }
    }
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var inputTextView: UITextView!
}
