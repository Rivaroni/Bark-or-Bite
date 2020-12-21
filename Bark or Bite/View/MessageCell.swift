//
//  MessageCell.swift
//  Bark or Bite
//
//  Created by Michael Rivera on 12/20/20.
//

import UIKit

class MessageCell: UITableViewCell{
    
    @IBOutlet weak var messageBubble: UIView!
    @IBOutlet weak var messageText: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var leftProfilePicture: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        messageBubble.layer.cornerRadius = messageBubble.frame.size.height / 5
        leftProfilePicture.isHidden = true
    }
}
