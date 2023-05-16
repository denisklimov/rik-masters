//
//  DoorsViewController.swift
//  Rik Masters
//
//  Created by Denis Klimov on 13.05.2023.
//

import UIKit


class DoorsViewController: UIViewController {

    var doors = [DoorModel]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task{
            do {
                self.doors = try await ApiDecoder().getDoors()
            } catch {
                alertOK(title: "Error", message: error.localizedDescription)
            }
            tableView.reloadData()
        }
    }
}


extension DoorsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "detail", sender: indexPath)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let editAction = UIContextualAction(style: .normal, title: "") { action, view, handler in
            let alertController = UIAlertController(title: "Реактирование", message: "Введите название", preferredStyle: .alert)
            alertController.addTextField()
            let okAction = UIAlertAction(title: "Сохранить", style: .default) { action in
                self.doors[indexPath.row].name = (alertController.textFields?.first?.text)!
                self.tableView.reloadData()
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true)
        }
        editAction.image = UIImage(systemName: "pencil.line")?.withTintColor(UIColor(named: "Blue")!, renderingMode: .alwaysOriginal)
        editAction.backgroundColor = .systemGray6
        
        let favoriteAction = UIContextualAction(style: .normal, title: "") { action, view, handler in
            self.doors[indexPath.row].favorites = self.doors[indexPath.row].favorites ? false : true
            self.tableView.reloadData()
        }
        favoriteAction.image = UIImage(systemName: "star")?.withTintColor(UIColor(named: "Yellow")!, renderingMode: .alwaysOriginal)
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
            cell.doorNameLabel.text = doors[indexPath.row].name
            cell.favoriteSignImage.isHidden = doors[indexPath.row].favorites ? true : false

            return cell
            
        } else {

            let cell = tableView.dequeueReusableCell(withIdentifier: "intercomCell", for: indexPath) as! IntercomTableViewCell
            cell.snapshotImage.image = doors[indexPath.row].snapshot
            cell.intercomNameLabel.text = doors[indexPath.row].name
            cell.favoriteSignImage.isHidden = doors[indexPath.row].favorites ? true : false

            return cell
        }
    }
}
