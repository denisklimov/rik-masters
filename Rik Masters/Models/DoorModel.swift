//
//  DoorModel.swift
//  Rik Masters
//
//  Created by Denis Klimov on 15.05.2023.
//

import Foundation
import UIKit

struct DoorModel {
    var name: String
    let room: String?
    let id: Int
    var favorites: Bool
    let snapshot: UIImage?
    var lock: Bool = true
}

extension DoorModel {

    init(managedObject: RealmDoor) {
        name = managedObject.name
        room = managedObject.room
        id = managedObject.id
        favorites = managedObject.favorites
        snapshot = managedObject.snapshot == nil ? nil : UIImage(data: managedObject.snapshot!)
        lock = managedObject.lock
    }
}
