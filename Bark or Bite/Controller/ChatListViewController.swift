//
//  ChatViewController.swift
//  Bark or Bite
//
//  Created by Michael Rivera on 12/16/20.
//

import UIKit
import Firebase
import FirebaseFirestore
import ProgressHUD

class ChatListViewController: UIViewController{
    
    @IBOutlet weak var chatTableView: UITableView!

    let dataBase = Firestore.firestore()
    var chatList = [ChatList]()
    var dogName: String?
    var indexPath = IndexPath()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ProgressHUD.show()
        ProgressHUD.animationType = .circleStrokeSpin
        
        chatTableView.dataSource = self
        
        chatTableView.delegate = self
        
        chatTableView.register(UINib(nibName: "ChatListCell", bundle: nil), forCellReuseIdentifier: "CustomChat")
        
        loadList()
        
    }
    
}

//MARK: - TableView loading and functions

extension ChatListViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomChat", for: indexPath) as! ChatListCell
        
        cell.dogImageView.image = chatList[indexPath.row].image
        cell.dogTextLabel.text = chatList[indexPath.row].dogName
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            dogName = chatList[indexPath.row].dogName
            performSegue(withIdentifier: "toChat", sender: self)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let TrashAction = UIContextualAction(style: .normal, title: "Trash") { (ac, view, success) in
            let dogString = self.chatList[indexPath.row].dogName
            let alert = UIAlertController(title: "Delete Chat", message: "Are you sure you want to delete this chat: \(dogString)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (alertAction) in
                self.deleteFirebase(indexpath: indexPath, string: dogString)
            }))
            
            self.present(alert, animated: true, completion: nil)
            
        }
        
        TrashAction.backgroundColor = #colorLiteral(red: 0.8729329705, green: 0.8204954267, blue: 1, alpha: 1)
        TrashAction.image = UIImage(named: "trash")
        
        return UISwipeActionsConfiguration(actions: [TrashAction])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let destinationVC = segue.destination as? ChatViewController
            destinationVC?.dogName = dogName
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
                                    ProgressHUD.dismiss()
                                }
                                
                            }
                        }
                    }; self.chatTableView.reloadData()
                    ProgressHUD.dismiss()
                }
            }
    }
    
    func deleteFirebase(indexpath: IndexPath, string: String){
        dataBase.collection("chatList").document(string).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
                self.chatTableView.reloadData()
            }
        }
    }
    
}
