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
    
    private var userDetailedInfo: UserDetailedInfo? {
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
        
        guard let userURL = userURL else { return }
        
        DownloadedFile.shared.getJsonFile(data: UserDetailedInfo.self, at: userURL) { [unowned self] json in
            guard let jsonUserDetailedInfo = json else {
                DispatchQueue.main.async {
                    Alert.showAlert(on: self, with: "Внимание!", message: "Сервер не отвечает")
                }
                return
            }
            self.userDetailedInfo = jsonUserDetailedInfo
        }
    }
    
    func showUserInfo() {
        if let name = userDetailedInfo?.name {
            nameLabel.text = name
        } else {
            nameLabel.text = "—"
        }
        if let email = userDetailedInfo?.email {
            emailLabel.text = email
        } else {
            emailLabel.text = "—"
        }
        if let dateOfCreation = userDetailedInfo?.created_at {
            if let date = setDateFormat(of: dateOfCreation) {
                dateOfCreationLabel.text = "created at " + date
            } else {
                dateOfCreationLabel.text = "created at —"
            }
        } else {
            dateOfCreationLabel.text = "—"
        }
        if let company = userDetailedInfo?.company { 
            companyLabel.text = "company: " + company
        } else {
            companyLabel.text = "—"
        }
        if let location = userDetailedInfo?.location {
            locationLabel.text = "location: " + location
        } else {
            locationLabel.text = "—"
        }
        if let followingCount = userDetailedInfo?.following {
            followingCountLabel.text = "\(followingCount) following"
        } else {
            followingCountLabel.text = "—"
        }
        if let followersCount = userDetailedInfo?.followers {
            followersCountLabel.text = "\(followersCount) followers"
        } else {
            followersCountLabel.text = "—"
        }
        if let publicRepositoryCount = userDetailedInfo?.public_repos {
            publicRepositoryCountLabel.text = "\(publicRepositoryCount) public repos."
        } else {
            publicRepositoryCountLabel.text = "—"
        }
        if let imageURL = userDetailedInfo!.avatar_url {
            
            DownloadedFile.shared.getImageFile(at: imageURL) { [unowned self] image in
                guard let image = image else {
                    DispatchQueue.main.async {
                        Alert.showAlert(on: self, with: "Внимание!", message: "Сервер не отвечает")
                    }
                    return
                }
                DispatchQueue.main.async {
                    self.avatarImageView.image = image
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
