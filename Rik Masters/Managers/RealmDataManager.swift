//
//  RealmManager.swift
//  Rik Masters
//
//  Created by Denis Klimov on 16.05.2023.
//

import Foundation
import RealmSwift
import UIKit


class RealmCamera: Object {
    
    @Persisted(primaryKey: true) var uid: ObjectId
    @Persisted var name: String
    @Persisted var snapshot: Data?
    @Persisted var room: String?
    @Persisted var id: Int
    @Persisted var favorites: Bool
    @Persisted var rec: Bool

    convenience init(cameraModel: CameraModel) {
        self.init()
        self.name = cameraModel.name
        self.snapshot = cameraModel.snapshot?.pngData()
        self.room = cameraModel.room
        self.id = cameraModel.id
        self.favorites = cameraModel.favorites
        self.rec = cameraModel.rec
    }
}

class RealmDoor: Object {
    
    @Persisted(primaryKey: true) var uid: ObjectId
    @Persisted var name: String
    @Persisted var room: String?
    @Persisted var id: Int
    @Persisted var favorites: Bool
    @Persisted var snapshot: Data?
    @Persisted var lock: Bool

    convenience init(doorModel: DoorModel) {
        
        self.init()
        self.name = doorModel.name
        self.room = doorModel.room
        self.id = doorModel.id
        self.favorites = doorModel.favorites
        self.snapshot = doorModel.snapshot?.pngData()
        self.lock = doorModel.lock
    }
}

enum RealmObjectType {
    case camera
    case door
}

class RealmDataManager {
    
    private let realm = try! Realm()
    
    
    public func isExists(objectsOfType type: RealmObjectType) -> Bool {
        switch type {
        case .camera:
            return realm.objects(RealmCamera.self).count > 0 ? true : false
        case .door:
            return realm.objects(RealmDoor.self).count > 0 ? true : false
        }
    }

    
    public func readCameras() -> Results<RealmCamera> {
        return realm.objects(RealmCamera.self)
    }
    
    
    public func writeCameras(cameras: [CameraModel]) {
        
        let realmCameraList = List<RealmCamera>()
        
        cameras.forEach { camera in
            realmCameraList.append(RealmCamera(cameraModel: camera))
        }
        
        try! realm.write {
            realm.delete(realm.objects(RealmCamera.self))
            realm.add(realmCameraList)
        }
    }
    
    
    public func updateCamera(camera: CameraModel) {
        
        let camForUpdate = realm.objects(RealmCamera.self).where{ $0.id == camera.id }.first
        try! realm.write {
            camForUpdate?.favorites = camera.favorites
        }
    }
    
    
    public func readDoors() -> Results<RealmDoor> {
        return realm.objects(RealmDoor.self)
    }
    

    public func writeDoors(doors: [DoorModel]) {

        let realmDoorList = List<RealmDoor>()

        doors.forEach { door in
            realmDoorList.append(RealmDoor(doorModel: door))
        }

        try! realm.write {
            realm.delete(realm.objects(RealmDoor.self))
            realm.add(realmDoorList)
        }
    }
    
    
    public func updateDoor(door: DoorModel) {
        
        let doorForUpdate = realm.objects(RealmDoor.self).where{ $0.id == door.id }.first
        try! realm.write {
            doorForUpdate?.favorites = door.favorites
            doorForUpdate?.name = door.name
            doorForUpdate?.lock = door.lock
        }
    }
    
    
    public func deleteAll() {
       
        try! realm.write {
            realm.deleteAll()
        }
    }
}
