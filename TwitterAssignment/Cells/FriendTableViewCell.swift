//
//  FriendTableViewCell.swift
//  TwitterAssignment
//
//  Created by Madhuri Patil on 09/06/21.
//

import UIKit

class FriendTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setupUI() {
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
    }

}
