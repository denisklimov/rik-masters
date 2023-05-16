//
//  ApiCamerasModel.swift
//  Rik Masters
//
//  Created by Denis Klimov on 13.05.2023.
//

import Foundation


struct ApiCamerasModel: Codable {
    let success: Bool
    let data: RoomsAndCameras
}


struct RoomsAndCameras: Codable {
    let room: [String]
    let cameras: [Camera]
}


struct Camera: Codable {
    let name: String
    let snapshot: String
    let room: String?
    let id: Int
    let favorites, rec: Bool
}
