//
//  IntercomTableViewCell.swift
//  Rik Masters
//
//  Created by Denis Klimov on 15.05.2023.
//

import UIKit

class IntercomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var snapshotImage: UIImageView!
    @IBOutlet weak var intercomNameLabel: UILabel!
    @IBOutlet weak var lockImage: UIImageView!
    @IBOutlet weak var favoriteSignImage: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let maskView = UIView(frame: CGRect(x: 16, y: 0, width: self.frame.width - 32, height: self.frame.height - 15))
        maskView.layer.cornerRadius = 10.0
        maskView.backgroundColor = .white
        contentView.mask = maskView
    }
}
