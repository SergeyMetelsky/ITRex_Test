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
    
    var userDictionary: [String : Any] = [:] {
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
        
//        let userData = DownloadedFile()
        guard let userURL = userURL else { return }
//        userData.getJsonFile(at: userURL) { [weak self] json in
        DownloadedFile.shared.getJsonFile(at: userURL) { [weak self] json in

            guard let jsonArray = json as? [String: Any] else { return }
            self?.userDictionary = jsonArray
        }
        
    }
    
    func showUserInfo() {
        if let name = userDictionary["name"] as? String {
            nameLabel.text = name
        } else {
            nameLabel.text = "—"
        }
        if let email = userDictionary["email"] as? String{
            emailLabel.text = email
        } else {
            emailLabel.text = "—"
        }
        if let dateOfCreation = userDictionary["created_at"] as? String {
            if let date = setDateFormat(of: dateOfCreation) {
                dateOfCreationLabel.text = "created at " + date
            } else {
                dateOfCreationLabel.text = "created at —"
            }
        } else {
            dateOfCreationLabel.text = "—"
        }
        if let company = userDictionary["company"] as? String {
            companyLabel.text = "company: " + company
        } else {
            companyLabel.text = "—"
        }
        if let location = userDictionary["location"] as? String {
            locationLabel.text = "location: " + location
        } else {
            locationLabel.text = "—"
        }
        if let followingCount = userDictionary["following"] as? Int {
            followingCountLabel.text = "\(followingCount) following"
        } else {
            followingCountLabel.text = "—"
        }
        if let followersCount = userDictionary["followers"] as? Int {
            followersCountLabel.text = "\(followersCount) followers"
        } else {
            followersCountLabel.text = "—"
        }
        if let publicRepositoryCount = userDictionary["public_repos"] as? Int {
            publicRepositoryCountLabel.text = "\(publicRepositoryCount) public repos."
        } else {
            publicRepositoryCountLabel.text = "—"
        }
        if let imageURL = userDictionary["avatar_url"] as? String {
            
            //            let avatarImage = DownloadedFile()
            //            avatarImage.getImageFile(at: imageURL) { [weak self] image in
            DownloadedFile.shared.getImageFile(at: imageURL) { [weak self] image in
                
                DispatchQueue.main.async {
                    self?.avatarImageView.image = image
                }
            }
        }
    }
    
    func setDateFormat(of date: String) -> String? {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:SS'Z'"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        guard let dateObj = dateFormatterGet.date(from: date) else { return nil }
        return dateFormatter.string(from: dateObj)
    }
}
