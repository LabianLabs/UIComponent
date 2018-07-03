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

protocol FeedCommentComponentDeledate  {
    func commentDidTouch()
}

public class FeedCommentComponent: UIViewComponent {
    
    @IBAction func commentDidTouch(_ sender: UIButton) {
        self.delegate?.commentDidTouch()
    }
    
    override public func setup() {
        super.setup()
        inputButton.layer.cornerRadius = 7
        inputButton.clipsToBounds = true
        inputButton.layer.borderWidth = 1
        inputButton.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        inputButton.setTitle("Your comment ...", for: .normal)
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2
        avatarImageView.clipsToBounds = true
        messageView.layer.cornerRadius = 7
        messageView.clipsToBounds = true
        messageLabel.lineBreakMode = NSLineBreakMode(rawValue: 0)!
    }
    override public func update() {
        super.update()
        guard let value  = self.value as? Data else {
            return
        }
        avatarImageView.image = UIImage(named: value.url)
        if value.message != "" {
            messageLabel.text = value.message
            inputButton.isHidden = true
        } else {
            messageView.isHidden = true
        }
    }
    
    var delegate: FeedCommentComponentDeledate?
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var inputButton: UIButton!
}
