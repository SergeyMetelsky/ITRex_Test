//
//  OneUserTableViewCell.swift
//  ITRex_Test
//
//  Created by Sergey on 3/29/21.
//

import UIKit

class OneUserTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width / 2
        avatarImageView.clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(userData: [String : Any]) {
        
        if let name = userData["login"] as? String {
            nameLabel.text = name
        } else {
            nameLabel.text = "—"
        }
        
        if let imageURL = userData["avatar_url"] as? String {
            DownloadedFile.shared.getImageFile(at: imageURL) { (image) in
                
                DispatchQueue.main.async { [self] in
                    avatarImageView.image = image
                }
            }
        }
    }
}
