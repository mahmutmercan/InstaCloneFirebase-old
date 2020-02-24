//
//  FeedViewController.swift
//  InstaCloneFirebase
//
//  Created by İlker isa Mercan on 3.02.2020.
//  Copyright © 2020 Mahmut Mercan. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
import Kingfisher

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var userEmailArray = [String]()
    var userCommentArray = [String]()
    var likeArray = [Int]()
    var userImageArray = [String]()
    var imageArrayUrl = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        getDataFromFirestore()
    }
    func getDataFromFirestore() {
        
        let fireStoreDatabase = Firestore.firestore()
//        let settings = fireStoreDatabase.settings
        fireStoreDatabase.collection("Posts").addSnapshotListener { (snapshot, error) in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                if snapshot?.isEmpty != true && snapshot != nil {
                    
                    self.userImageArray.removeAll(keepingCapacity: false)
                    self.userEmailArray.removeAll(keepingCapacity: false)
                    self.userCommentArray.removeAll(keepingCapacity: false)
                    self.likeArray.removeAll(keepingCapacity: false)
                    self.imageArrayUrl.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents {
                        let documentID = document.documentID
                        if let postedBy = document.get("postedBy") as? String{
                            self.userEmailArray.append(postedBy)
                        }
                        if let postComment = document.get("postComment") as? String {
                            self.userCommentArray.append(postComment)
                        }
                        if let likes = document.get("likes") as? Int {
                            self.likeArray.append(likes)
                        }
                        if let imageUrl = document.get("imageUrl") as? String {
                            self.userImageArray.append(imageUrl)
                        }
                        if let imageUrlLabel = document.get("imageUrlLabel") as? String{
                            self.imageArrayUrl.append(imageUrlLabel)
                        }
                        
                    }
                    self.tableView.reloadData()
                    
                }
            }
        }
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userEmailArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        cell.userEmailLabel.text = userEmailArray[indexPath.row]
        cell.likeLabel.text = String(likeArray[indexPath.row])
        
        //bu satırı story den kaldırdım istersen ekle
        //cell.imageUrlLabel.text = String(userImageArray[indexPath.row])

        cell.commentLabel.text = userCommentArray[indexPath.row]
        //cell.userImageView.image =  UIImage(named: "monalisa")
        cell.userImageView.sd_setImage(with: URL(string: self.userImageArray[indexPath.row]))
        
        return cell
    }
}
