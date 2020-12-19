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
    var dogName: String!
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        textField.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 50
        
        print("in chat controller \(dogName)")
        //  loadMessages()
    }
    
    @IBAction func sendButtonTapped(_ sender: UIButton) {
        textField.resignFirstResponder()
        print(textField.text)
        print(dogName)
        if let message = textField.text{
            db.collection("chatList").document(dogName).collection("messageList").addDocument(data: [
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
        //TODO: Figure out how to load the cells with messages
        //        db.collection("chatList").document().collection("messageList").order(by: "dateField")
        //            .addSnapshotListener { (querySnapshot, error) in
        //
        //                self.messages = []
        //
        //                if let e = error {
        //                    print("Issue retrieving data from Firestore \(e)")
        //                } else {
        //                    if let snapshotDocuments = querySnapshot?.documents{
        //                        for doc in snapshotDocuments {
        //                            let data = doc.data()
        //                            if let messageBody = data["messageBody"] as? String{
        //                                let newMessage = Message(messageBody: messageBody)
        //                                self.messages.append(newMessage)
        //
        //                                DispatchQueue.main.async {
        //                                    self.tableView.reloadData()
        //                                    let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
        //                                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
        //                                }
        //
        //                            }
        //                        }
        //                    }
        //                }
    }
    
}


//MARK: - UITableView Functions
extension ChatViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Chat", for: indexPath)
        
        cell.textLabel?.text = message.messageBody
        print("cell text: \(message.messageBody)")
        
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
