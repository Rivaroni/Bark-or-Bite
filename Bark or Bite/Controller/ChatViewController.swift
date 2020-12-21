//
//  ChatViewController.swift
//  Bark or Bite
//
//  Created by Michael Rivera on 12/18/20.
//

import UIKit
import Firebase
import FirebaseFirestore

class ChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    
    var db = Firestore.firestore()
    var dogName: String?
    var messages: [Message] = []
    let cpuBody: [String] = ["Whats up", "You want this dog?", "Well too bad bro", "Testing testing", "This app is trash LOL", "Ive come a long way"]
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        textField.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        tableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "CustomMessage")
        
        loadMessages()
    }
    
    @IBAction func sendButtonTapped(_ sender: UIButton) {
        textField.resignFirstResponder()
        
        let cpuText = cpuBody.randomElement()!
       
        if let message = textField.text{
            db.collection("chatList").document(dogName!).collection("messageList").addDocument(data: [
                "messageBody": message,
                "cpuBody": cpuText,
                "dateField": Date().timeIntervalSince1970
            ])
            { (error) in
                if let e = error{
                    print("Issue saving data to Firestore, \(e)")
                } else {
                    print("Successfully saved data.")
                    self.textField.text = ""
                }
            }
            
        }
        
    }
    
    func loadMessages(){
        
        db.collection("chatList").document(dogName!).collection("messageList")
            .order(by: "dateField", descending: false)
            .addSnapshotListener { (querySnapshot, error) in
                
                self.messages = []
                
                if let e = error {
                    print("Issue retrieving data from Firestore \(e)")
                } else {
                    if let snapshotDocuments = querySnapshot?.documents{
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            if let messageBody = data["messageBody"] as? String, let cpuBody = data["cpuBody"] as? String{
                                let newMessageEntry = Message(messageBody: messageBody, cpuBody: cpuBody)
                                self.messages.append(newMessageEntry)
                            }
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                
                            }
                            
                        }
                    }
                }
            }
    }
}




//MARK: - UITableView Functions
extension ChatViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.section]
        let cpuMessages = messages[indexPath.section]
        var cellChooser: MessageCell!
        
        if indexPath.section >= 0 {
            if indexPath.row % 2 == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: "CustomMessage", for: indexPath) as! MessageCell
                cell.messageText.text = message.messageBody
                cell.leftProfilePicture.isHidden = true
                cell.profilePicture.isHidden = false
                cellChooser = cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CustomMessage", for: indexPath) as! MessageCell
                cell.messageText.text = cpuMessages.cpuBody
                cell.leftProfilePicture.isHidden = false
                cell.profilePicture.isHidden = true
                cellChooser = cell
            }
            
        }
        
        return cellChooser
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return messages.count
    }
    
}

//MARK: - UITextField functions

extension ChatViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
