//
//  DoorDetailViewController.swift
//  Rik Masters
//
//  Created by Denis Klimov on 15.05.2023.
//

import UIKit

class DoorDetailViewController: UIViewController {

    let dataManager = DataManager()
    
    let lockedImage = UIImage(named: "locked")
    let unlockedImage = UIImage(named: "unlocked")
    var door: DoorModel?
    var doorsViewController: DoorsViewController? = nil
    
    @IBOutlet weak var doorNameLabel: UILabel!
    @IBOutlet weak var doorLockImage: UIImageView!
    @IBOutlet weak var translationImage: UIImageView!
    @IBOutlet weak var doorLockButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let door = door else { return }
        doorNameLabel.text = door.name
        if let snapshot = door.snapshot {
            translationImage.isHidden = false
            translationImage.image = snapshot
        } else {
            translationImage.isHidden = true
        }
        doorLockImage.image = door.lock ? lockedImage : unlockedImage
        doorLockButton.setTitle(door.lock ? "Открыть дверь" : "Закрыть дверь", for: .normal)
        
    }
    

    @IBAction func doorLockToggle(_ sender: UIButton) {
        
        guard var door = door else { return }
        
        doorLockImage.image = !door.lock ? lockedImage : unlockedImage
        doorLockButton.setTitle(!door.lock ? "Открыть дверь" : "Закрыть дверь", for: .normal)
        
        door.lock = !door.lock
        dataManager.updateDoor(door: door)
        doorsViewController!.updateData(from: .database)
    }
}
