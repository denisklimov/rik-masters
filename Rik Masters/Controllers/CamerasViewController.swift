//
//  CamerasViewController.swift
//  Rik Masters
//
//  Created by Denis Klimov on 13.05.2023.
//

import UIKit


class CamerasViewController: UIViewController {
    
    let dataManager = DataManager()
    let refreshControl = UIRefreshControl()
    
    var sections = [String?]()
    var indexedCameras = [[CameraModel]]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.addTarget(nil, action: #selector(refresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
        updateData()
    }
    
    
    func updateData(from method: PrefferedMethod = .automatic) {
        
        Task {
            do {
                
                let cameras = try await dataManager.getCamerasData(from: method)
                cameras.forEach { camera in
                    let sectionTitle = camera.room
                    if !sections.contains(sectionTitle) {
                        sections.append(sectionTitle)
                    }
                }

                indexedCameras.removeAll()
                sections.forEach { section in
                    indexedCameras.append(cameras.filter{$0.room == section})
                }
                
            } catch {
                
                alertOK(title: "Error", message: error.localizedDescription)
            }
            
            tableView.reloadData()
        }
    }
    
    
    @objc func refresh() {
        
        updateData(from: .network)
        refreshControl.endRefreshing()
    }
}



extension CamerasViewController: UITableViewDelegate {
        
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section] ?? "Untitled"
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "Verdana", size: 17.0)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let favoriteAction = UIContextualAction(style: .normal, title: "") {_,_,_ in
            var cameraForUpdate = self.indexedCameras[indexPath.section][indexPath.row]
            cameraForUpdate.favorites = !cameraForUpdate.favorites
            self.dataManager.updateCamera(camera: cameraForUpdate)
            self.updateData()
        }
        
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 35.0, weight: .thin)
        let image = UIImage(named: "favoriteButton")
        favoriteAction.image = image
        favoriteAction.backgroundColor = .systemGray6
        
        let actionConfiguration = UISwipeActionsConfiguration(actions: [favoriteAction])
        actionConfiguration.performsFirstActionWithFullSwipe = false
        
        return actionConfiguration
    }
}



extension CamerasViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return indexedCameras[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CamerasTableViewCell
        let camera = indexedCameras[indexPath.section][indexPath.row]
        
        cell.snapShotImage.image = camera.snapshot
        cell.camNameLabel.text = camera.name
        cell.favoriteSign.isHidden = !camera.favorites
        cell.recordSign.isHidden = !camera.rec
        cell.playSign.isHidden = camera.snapshot == nil ? true : false
        
        return cell
    }
}
