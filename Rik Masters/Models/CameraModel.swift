//
//  CameraModel.swift
//  Rik Masters
//
//  Created by Denis Klimov on 14.05.2023.
//

import Foundation
import UIKit

struct CameraModel {
    let name: String
    let snapshot: UIImage?
    let room: String?
    let id: Int
    var favorites, rec: Bool
}

extension CameraModel {

    init(managedObject: RealmCamera) {
        name = managedObject.name
        snapshot = managedObject.snapshot!.isEmpty ? nil : UIImage(data: managedObject.snapshot!)
        room = managedObject.room
        id = managedObject.id
        favorites = managedObject.favorites
        rec = managedObject.rec
    }
}
