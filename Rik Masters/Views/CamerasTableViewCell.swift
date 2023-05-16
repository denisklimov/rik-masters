//
//  CamerasTableViewCell.swift
//  Rik Masters
//
//  Created by Denis Klimov on 14.05.2023.
//

import UIKit


class CamerasTableViewCell: UITableViewCell {
    
    @IBOutlet weak var snapShotImage: UIImageView!
    @IBOutlet weak var camNameLabel: UILabel!
    @IBOutlet weak var recordSign: UIStackView!
    @IBOutlet weak var favoriteSign: UIImageView!
    @IBOutlet weak var playSign: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let maskView = UIView(frame: CGRect(x: 16, y: 0, width: self.frame.width - 32, height: self.frame.height - 15))
        maskView.layer.cornerRadius = 10.0
        maskView.backgroundColor = .white
        contentView.mask = maskView
    }
}
