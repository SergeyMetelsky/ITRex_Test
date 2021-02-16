//
//  UserDataViewController.swift
//  ITRex_Test
//
//  Created by Sergey on 2/8/21.
//

import UIKit

class UserDataViewController: UIViewController {
    var userURL: String?
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var dateOfCreationLabel: UILabel!
    
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var publicRepositoryCountLabel: UILabel!
    
    var userArray: [String : Any] = [:] {
        didSet {
            DispatchQueue.main.async { [self] in
                showUserInfo()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let labelsArray = [emailLabel, dateOfCreationLabel, companyLabel, locationLabel, followingCountLabel, followersCountLabel, publicRepositoryCountLabel]
        
        for label in labelsArray {
            label?.adjustsFontSizeToFitWidth = true
            label?.minimumScaleFactor = 0.2
        }
        
        let userData = DownloadedFile()
        guard userURL != nil else { return }
        userData.getJsonFile(at: userURL!) { (json) in
            guard let jsonArray = json as? [String: Any] else { return }
            self.userArray = jsonArray
        }
        
    }
    
    func showUserInfo() {
        if let name = userArray["name"] as? String {
            nameLabel.text = name
        } else {
            nameLabel.text = "—"
        }
        if let email = userArray["email"] as? String{
            emailLabel.text = email
        } else {
            emailLabel.text = "—"
        }
        if let dateOfCreation = userArray["created_at"] as? String {
            dateOfCreationLabel.text = "created at " + setDateFormat(of: dateOfCreation)
        } else {
            dateOfCreationLabel.text = "—"
        }
        if let company = userArray["company"] as? String {
            companyLabel.text = "company: " + company
        } else {
            companyLabel.text = "—"
        }
        if let location = userArray["location"] as? String {
            locationLabel.text = "location: " + location
        } else {
            locationLabel.text = "—"
        }
        if let followingCount = userArray["following"] as? Int {
            followingCountLabel.text = "\(followingCount) following"
        } else {
            followingCountLabel.text = "—"
        }
        if let followersCount = userArray["followers"] as? Int {
            followersCountLabel.text = "\(followersCount) followers"
        } else {
            followersCountLabel.text = "—"
        }
        if let publicRepositoryCount = userArray["public_repos"] as? Int {
            publicRepositoryCountLabel.text = "\(publicRepositoryCount) public repos."
        } else {
            publicRepositoryCountLabel.text = "—"
        }
        if let imageURL = userArray["avatar_url"] as? String {
            
            let avatarImage = DownloadedFile()
            avatarImage.getImageFile(at: imageURL) { (image) in
                
                DispatchQueue.main.async {
                    self.avatarImageView.image = image
                }
            }
        }
    }
    
    func setDateFormat(of date: String) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:SS'Z'"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        let dateObj: Date? = dateFormatterGet.date(from: date)
        
        return dateFormatter.string(from: dateObj!)
    }
}
