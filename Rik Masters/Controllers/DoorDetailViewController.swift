//
//  DoorDetailViewController.swift
//  Rik Masters
//
//  Created by Denis Klimov on 15.05.2023.
//

import UIKit

class DoorDetailViewController: UIViewController {

    var isLocked = true
    let locked = UIImage(systemName: "lock")
    let unlocked = UIImage(systemName: "lock.open")
    
    
    @IBOutlet weak var doorNameLabel: UILabel!
    @IBOutlet weak var doorLockImage: UIImageView!
    @IBOutlet weak var doorRoomLabel: UILabel!
    @IBOutlet weak var doorIdLabel: UILabel!
    @IBOutlet weak var doorLockButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doorLockButton.setTitle("Открыть дверь", for: .normal)
        
    }

    @IBAction func doorLockToggle(_ sender: UIButton) {

        doorLockImage.image = !isLocked ? locked : unlocked
        doorLockButton.setTitle(!isLocked ? "Открыть дверь" : "Закрыть дверь", for: .normal)
        isLocked = isLocked ? false : true
    }
    @IBAction func favoriteButton(_ sender: UIButton) {
        
    }
}
