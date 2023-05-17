//
//  ApiDataManager.swift
//  Rik Masters
//
//  Created by Denis Klimov on 13.05.2023.
//

import Foundation
import UIKit


enum ApiDecoderError: Error {
    case notSuccess
}


extension ApiDecoderError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .notSuccess:
            return "Not success ressponce from API server."
        }
    }
}



class ApiDataManager {
    
    
    public func getCameras() async throws -> [CameraModel] {

        let data: Data
        let urlString = "https://cars.cprogroup.ru/api/rubetek/cameras/"
        
        do {
            data = try await getData(from: urlString)
        } catch {
            throw error
        }
        
        let model: ApiCamerasModel
        
        do {
            model = try decodeData(from: data, to: ApiCamerasModel.self)
        } catch {
            throw error
        }

        guard model.success else { throw ApiDecoderError.notSuccess }
        
        var cameras = [CameraModel]()
        
        model.data.cameras.forEach { camera in
            var snapshotImage = UIImage(systemName: "video.slash")
            let snapshotUrl = URL(string: camera.snapshot)
            if snapshotUrl != nil {
                snapshotImage = try? UIImage(data: Data(contentsOf: snapshotUrl!))
            }
            
            let cameraModel = CameraModel(
                name: camera.name,
                snapshot: snapshotImage,
                room: camera.room,
                id: camera.id,
                favorites: camera.favorites,
                rec: camera.rec)
            cameras.append(cameraModel)
        }
        
        return cameras
    }
    
    
    public func getDoors() async throws -> [DoorModel] {
        
        let data: Data
        let urlString = "https://cars.cprogroup.ru/api/rubetek/doors/"
        
        do {
            data = try await getData(from: urlString)
        } catch {
            throw error
        }
        
        let model: APIDoorsModel
        
        do {
            model = try decodeData(from: data, to: APIDoorsModel.self)
        } catch {
            throw error
        }
        
        guard model.success else { throw ApiDecoderError.notSuccess }
        
        var doors = [DoorModel]()
        
        model.data.forEach { door in
            var snapshotImage: UIImage? = nil
            if door.snapshot != nil {
                snapshotImage = UIImage(systemName: "video.slash")
                let snapshotUrl = URL(string: door.snapshot!)
                snapshotImage = try? UIImage(data: Data(contentsOf: snapshotUrl!))
            }
            
            let doorModel = DoorModel(name: door.name, room: door.room, id: door.id, favorites: door.favorites, snapshot: snapshotImage)
            doors.append(doorModel)
        }
        
        return doors
        
    }
    
    
    private func getData(from urlString: String) async throws -> Data {
        
        var data: Data
        let urlString = urlString
        
        do {
            data = try await NetworkManager().getData(from: urlString)
        } catch {
            throw error
        }
        
        return data
    }
    
    private func decodeData<T: Decodable>(from data: Data, to model: T.Type) throws -> T {
        
        var model: T
        
        do {
            model = try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw error
        }
        
        return model
    }
}
