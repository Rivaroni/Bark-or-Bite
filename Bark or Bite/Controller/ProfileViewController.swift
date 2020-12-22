//
//  ProfileViewController.swift
//  Bark or Bite
//
//  Created by Michael Rivera on 12/16/20.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameTextLabel: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var termsView: UIView!
    @IBOutlet weak var privacyView: UIView!
    @IBOutlet weak var aboutView: UIView!
    @IBOutlet weak var editProfileView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        profileImage.layer.cornerRadius = 45
        topView.layer.shadowColor = UIColor.black.cgColor
        topView.layer.shadowOpacity = 0.15
        topView.layer.shadowOffset = .init(width: -2.5, height: 3)
        topView.layer.shadowRadius = 3
        termsView.layer.shadowColor = UIColor.black.cgColor
        termsView.layer.shadowOpacity = 0.15
        termsView.layer.shadowOffset = .init(width: -2.5, height: 3)
        termsView.layer.shadowRadius = 3
        privacyView.layer.shadowColor = UIColor.black.cgColor
        privacyView.layer.shadowOpacity = 0.15
        privacyView.layer.shadowOffset = .init(width: -2.5, height: 3)
        privacyView.layer.shadowRadius = 3
        aboutView.layer.shadowColor = UIColor.black.cgColor
        aboutView.layer.shadowOpacity = 0.15
        aboutView.layer.shadowOffset = .init(width: -2.5, height: 3)
        aboutView.layer.shadowRadius = 3
        editProfileView.layer.cornerRadius = 20
        editProfileView.layer.shadowColor = UIColor.black.cgColor
        editProfileView.layer.shadowOpacity = 0.5
        editProfileView.layer.shadowOffset = .init(width: -1.5, height: 3)
        editProfileView.layer.shadowRadius = 1
        
       
    }
    
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
    }
    
   

}
