//
//  ChatListCell.swift
//  Bark or Bite
//
//  Created by Michael Rivera on 12/20/20.
//

import UIKit

class ChatListCell: UITableViewCell{
    
    @IBOutlet weak var dogImageView: UIImageView!
    @IBOutlet weak var dogTextLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        dogImageView.layer.cornerRadius = 35
        
    }

    
}
