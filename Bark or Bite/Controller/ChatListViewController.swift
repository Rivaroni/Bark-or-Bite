//
//  ChatViewController.swift
//  Bark or Bite
//
//  Created by Michael Rivera on 12/16/20.
//

import UIKit
import Firebase
import FirebaseFirestore

class ChatListViewController: UIViewController{
    
    @IBOutlet weak var chatTableView: UITableView!

    let dataBase = Firestore.firestore()
    var chatList = [ChatList]()
    var dogName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatTableView.dataSource = self
        
        chatTableView.delegate = self
        
        chatTableView.rowHeight = 125
        
        chatTableView.allowsSelection = true
  
        loadList()
       
    }
    
}

//MARK: - TableView loading and functions

extension ChatListViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "List", for: indexPath)
        
        cell.imageView?.image = chatList[indexPath.row].image
        cell.textLabel?.text = chatList[indexPath.row].dogName
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dogName = chatList[indexPath.row].dogName
        performSegue(withIdentifier: "toChat", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as? ChatViewController
        destinationVC?.dogName = dogName
        print(dogName)
    }
    
    func loadList(){
        
        dataBase.collection("chatList")
            .order(by: "mostRecent", descending: true)
            .addSnapshotListener { (querySnapshot, error) in
                
                self.chatList = []
                
                if let e = error {
                    print("Issue retrieving data from Firestore \(e)")
                } else {
                    if let snapshotDocuments = querySnapshot?.documents{
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            if let dogName = data["dogName"] as? String, let dogImage = data["imageURL"] as? String{
                                let imageURL = URL(string: dogImage)
                                let imageData = try! Data(contentsOf: imageURL!)
                                if let image = UIImage(data: imageData){
                                    let newListEntry = ChatList(dogName: dogName, image: image)
                                    self.chatList.append(newListEntry)
                                }
                                
                                DispatchQueue.main.async {
                                    self.chatTableView.reloadData()
                                }
                                
                            }
                        }
                    }
                }
            }
    }
    
}
