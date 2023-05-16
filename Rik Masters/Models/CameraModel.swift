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
