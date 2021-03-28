//
//  ListOfUsersTableViewController.swift
//  ITRex_Test
//
//  Created by Sergey on 2/9/21.
//

import UIKit

class ListOfUsersTableViewController: UITableViewController {
    private let allUsersURL: String = "https://api.github.com/users"
    var allUsersArray: [[String : Any]] = [[:]] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        let allUsersData = DownloadedFile()
        //        allUsersData.getJsonFile(at: allUsersURL) { [weak self] json in
        DownloadedFile.shared.getJsonFile(at: allUsersURL) { [weak self] json in
            
            guard let jsonArray = json as? [[String: Any]] else { return }
            
            self?.allUsersArray = jsonArray
        }
        
        self.title = "List of users"
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allUsersArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as? UserTableViewCell else { return UITableViewCell() }
        
        if let nameLabel = allUsersArray[indexPath.row]["login"] as? String {
            cell.nameLabel.text = nameLabel
        } else {
            cell.nameLabel.text = "—"
        }
        
        if let imageURL = allUsersArray[indexPath.row]["avatar_url"] as? String {
            
            //            let avatarImage = DownloadedFile()
            //            avatarImage.getImageFile(at: imageURL) { (image) in
            DownloadedFile.shared.getImageFile(at: imageURL) { (image) in
                
                
                DispatchQueue.main.async {
                    cell.avatarImageView.image = image
                }
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newController = storyboard?.instantiateViewController(identifier: "UserData")
        guard let destinationViewController = newController as? UserDataViewController else { return }
        navigationController?.pushViewController(destinationViewController, animated: true)
        
        guard let url = allUsersArray[indexPath.row]["url"] as? String else { return }
        destinationViewController.userURL = url
    }
}
