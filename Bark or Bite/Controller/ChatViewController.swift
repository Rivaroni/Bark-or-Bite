//
//  ChatViewController.swift
//  Bark or Bite
//
//  Created by Michael Rivera on 12/16/20.
//

import UIKit
import Firebase
import FirebaseFirestore

class ChatViewController: UIViewController{
  
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var chatTextField: UITextField!
    
    let dataBase = Firestore.firestore()
    let chatList = [ChatList]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatTableView.dataSource = self

    }
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
    }

}

extension ChatViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "List", for: indexPath)
        
        cell.imageView?.image = chatList[indexPath.row].image
        cell.textLabel?.text = chatList[indexPath.row].dogName
        
        return cell
    }
    
}
