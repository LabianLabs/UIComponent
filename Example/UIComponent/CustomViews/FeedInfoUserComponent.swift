////  FeedInfoUserComponent.swift
//  UIComponent_Example
//
//  Created by labs01 on 7/3/18.
//  Copyright © LabianLabs 2015
//

import Foundation
import UIComponent
import UIKit

//========================================================================================

let calendar = Calendar(identifier: .gregorian)

struct CalendarComponentAmount {
    let component: Calendar.Component
    let amount: Int
}

infix operator +: AdditionPrecedence

extension Date {
    static func +(date: Date, componentAmount: CalendarComponentAmount) -> Date {
        return calendar.date(byAdding: componentAmount.component,
                             value: componentAmount.amount,
                             to: date)!
    }
}

extension Int {
    
    var years: CalendarComponentAmount {
        return CalendarComponentAmount(component: .year, amount: self)
    }
    
    var months: CalendarComponentAmount {
        return CalendarComponentAmount(component: .month, amount: self)
    }
    
    var days: CalendarComponentAmount {
        return CalendarComponentAmount(component: .day, amount: self)
    }
    
    var hours: CalendarComponentAmount {
        return CalendarComponentAmount(component: .hour, amount: self)
    }
    
    var minutes: CalendarComponentAmount {
        return CalendarComponentAmount(component: .minute, amount: self)
    }
    
    var seconds: CalendarComponentAmount {
        return CalendarComponentAmount(component: .second, amount: self)
    }
}

//========================================================================================

struct Data {
    var actor: String
    var actee: String
    var rank: Int
    var url: String
    var date: Date
    init(actor: String, actee: String, rank: Int, url: String, date: Date) {
        self.actor = actor
        self.actee = actee
        self.rank = rank
        self.url = url
        self.date = date
    }
}

protocol FeedInfoUserDelegate {
    func onOptionDidTouch()
}
//========================================================================================

class FeedInfoUserComponent: UIViewComponent {
    //OVERRIDE
    public override func setup(){
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        avatarImageView.layer.borderWidth = 0.5
    }
    
    public override func update() {
        guard let value = self.value as? Data else {
            return
        }
        avatarImageView.image = UIImage(named: value.url)
        infoLabel.attributedText = getInfoText(actor: value.actor,
                                               rank: value.rank,
                                               actee: value.actee)
        timeLabel.text = getTime(from: value.date)
        optionButton.isHidden = value.actee != ""
    }
    
    //VIEW EVENTS
    @IBAction func optionDidTouch(_ sender: UIButton) {
        delegate?.onOptionDidTouch()
    }
    
    //UTILS
    public func getInfoText(actor: String,rank: Int, actee: String) -> NSAttributedString{
        let titleAttribute = NSMutableAttributedString(string: actor,
                                                       attributes: [kCTFontAttributeName as NSAttributedStringKey: UIFont.boldSystemFont(ofSize: 16)])
        if actee == "" {return titleAttribute}
        titleAttribute.append(NSAttributedString(string: " " + "win the",
                                                 attributes: [kCTFontAttributeName as NSAttributedStringKey: UIFont.systemFont(ofSize: 16)]))
        titleAttribute.append(NSAttributedString(string: " #\(rank)",
            attributes: [kCTFontAttributeName as NSAttributedStringKey: UIFont.boldSystemFont(ofSize: 16)]))
        titleAttribute.append(NSAttributedString(string: " " + "from",
                                                 attributes: [kCTFontAttributeName as NSAttributedStringKey: UIFont.systemFont(ofSize: 16)]))
        titleAttribute.append(NSAttributedString(string: " \(actee)",
            attributes: [kCTFontAttributeName as NSAttributedStringKey: UIFont.boldSystemFont(ofSize: 16)]))
        titleAttribute.append(NSAttributedString(string: " " + "on the ",
                                                 attributes: [kCTFontAttributeName as NSAttributedStringKey: UIFont.systemFont(ofSize: 16)]))
        titleAttribute.append(NSAttributedString(string: " " + "leaderboard",
                                                 attributes: [kCTFontAttributeName as NSAttributedStringKey: UIFont.boldSystemFont(ofSize: 16)]))
        return titleAttribute
    }
    
    public func getTime(from date: Date) -> String {
        let currenDate = Date()
        let calendar = Calendar.current
        let date = calendar.dateComponents([.day, .hour, .minute,], from: date)
        let components = calendar.dateComponents([.day, .hour, .minute,], from: currenDate)
        
        let exceptDay = components.day! - date.day!
        let exceptHour = components.hour! - date.hour!
        let exceptMinute = components.minute! - date.minute!
        if exceptDay != 0 {
            return "\(exceptDay) days ago"
        } else if exceptHour != 0 {
            return "\(exceptHour) hours ago"
        } else if exceptMinute != 0 {
            return "\(exceptMinute) mins ago"
        }
        return "< 1 minute ago"
    }

    //VARS
    var delegate: FeedInfoUserDelegate?
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var optionButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!}
