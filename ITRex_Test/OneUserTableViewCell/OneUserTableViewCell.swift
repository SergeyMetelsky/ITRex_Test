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
    
    func configureCell(userData: UserGeneralInfo) {
        guard let avataUrl = userData.avatar_url, let login = userData.login else { return }
        nameLabel.text = login
        
        DownloadedFile.shared.getImageFile(at: avataUrl) { (image) in
            DispatchQueue.main.async { [self] in
                avatarImageView.image = image
            }
        }
    }
}

