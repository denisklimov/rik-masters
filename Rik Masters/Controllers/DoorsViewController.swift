//
//  DoorsViewController.swift
//  Rik Masters
//
//  Created by Denis Klimov on 13.05.2023.
//

import UIKit


class DoorsViewController: UIViewController {

    let dataManager = DataManager()
    let refreshControl = UIRefreshControl()
    
    var doors = [DoorModel]()
    var selectedDoor: DoorModel?
    let lockedImage = UIImage(named: "locked")
    let unlockedImage = UIImage(named: "unlocked")
    
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
                self.doors.removeAll()
                self.doors = try await dataManager.getDoorsData(from: method)
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "detail" {
            let detailViewController = segue.destination as! DoorDetailViewController
            detailViewController.door = selectedDoor
            detailViewController.doorsViewController = self
        }
    }
}


extension DoorsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedDoor = doors[indexPath.row]
        performSegue(withIdentifier: "detail", sender: nil)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let editAction = UIContextualAction(style: .normal, title: "") { action, view, handler in
            let alertController = UIAlertController(title: "Реактирование", message: "Введите название", preferredStyle: .alert)
            alertController.addTextField()
            let okAction = UIAlertAction(title: "Сохранить", style: .default) { action in
                var doorForUpdate = self.doors[indexPath.row]
                doorForUpdate.name = (alertController.textFields?.first?.text)!
                self.dataManager.updateDoor(door: doorForUpdate)
                self.updateData()
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true)
        }
        
        editAction.image = UIImage(named: "editButton")
        editAction.backgroundColor = .systemGray6
        
        let favoriteAction = UIContextualAction(style: .normal, title: "") { action, view, handler in
            var doorForUpdate = self.doors[indexPath.row]
            doorForUpdate.favorites = !doorForUpdate.favorites
            self.dataManager.updateDoor(door: doorForUpdate)
            self.updateData()
        }
        
        favoriteAction.image = UIImage(named: "favoriteButton")
        favoriteAction.backgroundColor = .systemGray6
        
        return UISwipeActionsConfiguration(actions: [favoriteAction, editAction])
    }
}

extension DoorsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return doors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if doors[indexPath.row].snapshot == nil {

            let cell = tableView.dequeueReusableCell(withIdentifier: "doorCell", for: indexPath) as! DoorsTableViewCell
            let door = doors[indexPath.row]
            cell.doorNameLabel.text = door.name
            cell.favoriteSignImage.isHidden = !door.favorites
            cell.lockImage.image = door.lock ? lockedImage : unlockedImage
            
            return cell
            
        } else {

            let cell = tableView.dequeueReusableCell(withIdentifier: "intercomCell", for: indexPath) as! IntercomTableViewCell
            let door = doors[indexPath.row]
            cell.snapshotImage.image = door.snapshot
            cell.intercomNameLabel.text = door.name
            cell.favoriteSignImage.isHidden = !door.favorites
            cell.lockImage.image = door.lock ? lockedImage : unlockedImage
            return cell
        }
    }
}
