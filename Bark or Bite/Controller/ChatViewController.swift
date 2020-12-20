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
        
        if let message = textField.text{
            db.collection("chatList").document(dogName!).collection("messageList").addDocument(data: [
                "messageBody": message,
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
                            if let messageBody = data["messageBody"] as? String{
                                let newMessageEntry = Message(messageBody: messageBody)
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
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomMessage", for: indexPath) as! MessageCell
        
        cell.messageText.text = message.messageBody
        
        return cell
    }
    
    
}

//MARK: - UITextField functions

extension ChatViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
