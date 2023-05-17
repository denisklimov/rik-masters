//
//  DataManager.swift
//  Rik Masters
//
//  Created by Denis Klimov on 16.05.2023.
//

import Foundation
import RealmSwift


enum PrefferedMethod {
    case automatic
    case database
    case network
}

enum TypeOfData {
    case camera
    case door
}

enum DataManagerError: Error {
    case invalidDataType
}


class DataManager {
    
    private let apiManager = ApiDataManager()

    
    public func getCamerasData(from method: PrefferedMethod = .automatic) async throws -> [CameraModel] {
        
        var cameras = [CameraModel]()
        
        switch method {
        case .automatic:
            cameras = try await getCamerasDataAutomatic()
        case .database:
            cameras = getCamerasDataFromRealm()
        case .network:
            cameras = try await getCamerasDataFromNetwork()
        }
        
        return cameras
    }
    
    
    private func getCamerasDataAutomatic() async throws -> [CameraModel] {
        
        var cameras = [CameraModel]()
        
        if RealmDataManager().isExists(objectsOfType: .camera) {
            cameras = getCamerasDataFromRealm()
        } else {
            do {
                cameras = try await getCamerasDataFromNetwork()
            } catch {
                throw error
            }
        }
        
        return cameras
    }
    
    
    private func getCamerasDataFromNetwork() async throws -> [CameraModel] {
        
        var cameras = [CameraModel]()
        
        do {
            cameras = try await apiManager.getCameras()
        } catch {
            throw error
        }
        
        RealmDataManager().writeCameras(cameras: cameras)
        
        return cameras
    }
    
    
    private func getCamerasDataFromRealm() -> [CameraModel] {
        
        var cameras = [CameraModel]()
        let realmCams = RealmDataManager().readCameras()
        
        realmCams.forEach { camera in
            let cam = CameraModel(managedObject: camera)
            cameras.append(cam)
        }
        
        return cameras
    }
    
    
    public func updateCamera(camera: CameraModel) {
        RealmDataManager().updateCamera(camera: camera)
    }
    
    
    
    
    public func getDoorsData(from method: PrefferedMethod = .automatic) async throws -> [DoorModel] {
        
        var doors = [DoorModel]()
        
        switch method {
        case .automatic:
            doors = try await getDoorsDataAutomatic()
        case .database:
            doors = getDoorsDataFromRealm()
        case .network:
            doors = try await getDoorsDataFromNetwork()
        }
        
        return doors
    }
    
    private func getDoorsDataAutomatic() async throws -> [DoorModel] {
        
        var doors = [DoorModel]()
        
        if RealmDataManager().isExists(objectsOfType: .door) {
            doors = getDoorsDataFromRealm()
        } else {
            do {
                doors = try await getDoorsDataFromNetwork()
            } catch {
                throw error
            }
        }
        
        return doors
    }
    
    
    private func getDoorsDataFromNetwork() async throws -> [DoorModel] {
        
        var doors = [DoorModel]()
        
        do {
            doors = try await apiManager.getDoors()
        } catch {
            throw error
        }
        
        RealmDataManager().writeDoors(doors: doors)
        
        return doors
    }
    
    
    private func getDoorsDataFromRealm() -> [DoorModel] {
        
        var doors = [DoorModel]()
        let realmDoors = RealmDataManager().readDoors()
        
        realmDoors.forEach { door in
            let doorElement = DoorModel(managedObject: door)
            doors.append(doorElement)
        }
        
        return doors
    }
    
    
    
    public func updateDoor(door: DoorModel) {
        RealmDataManager().updateDoor(door: door)
    }
}
