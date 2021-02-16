//
//  ListOfUsersTableViewController.swift
//  ITRex_Test
//
//  Created by Sergey on 2/9/21.
//

import UIKit

class ListOfUsersTableViewController: UITableViewController {
    let allUsersURL: String = "https://api.github.com/users"
    var allUsersArray: [[String : Any]] = [[:]] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let allUsersData = DownloadedFile()
        allUsersData.getJsonFile(at: allUsersURL) { (json) in
            guard let jsonArray = json as? [[String: Any]] else { return }
            
            DispatchQueue.main.async {
                self.allUsersArray = jsonArray
            }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UserTableViewCell
        
        if let nameLabel = allUsersArray[indexPath.row]["login"] as? String {
            cell.nameLabel.text = nameLabel
        } else {
            cell.nameLabel.text = "—"
        }
        
        if let imageURL = allUsersArray[indexPath.row]["avatar_url"] as? String {
            
            let avatarImage = DownloadedFile()
            avatarImage.getImageFile(at: imageURL) { (image) in
                
                DispatchQueue.main.async {
                    cell.avatarImageView.image = image
                }
            }
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let destinationViewController = segue.destination as? UserDataViewController else { return }
        guard let selectedCell = sender as? UserTableViewCell else { return }
        guard let indexPath = tableView.indexPath(for: selectedCell) else { return }
        
        if let url = allUsersArray[indexPath.row]["url"] as? String {
            destinationViewController.userURL = url
        }
    }
}
