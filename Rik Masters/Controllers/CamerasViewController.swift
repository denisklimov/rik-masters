//
//  CamerasViewController.swift
//  Rik Masters
//
//  Created by Denis Klimov on 13.05.2023.
//

import UIKit

class CamerasViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    let refreshControl = UIRefreshControl()
    var sections = [String?]()
    var indexedRows = [[CameraModel]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        refreshControl.addTarget(nil, action: #selector(refresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        Task {
            do {
                let cameras = try await ApiDecoder().getCameras()
                cameras.forEach {
                    if !sections.contains($0.room) {
                        sections.append($0.room)
                    }
                }
                sections.forEach { section in
                    indexedRows.append(cameras.filter{$0.room == section})
                }
            } catch {
                alertOK(title: "Error", message: error.localizedDescription)
            }
            tableView.reloadData()
        }
    }
    
    @objc func refresh() {
        print("refresh")
        refreshControl.endRefreshing()
    }
}

extension CamerasViewController: UITableViewDelegate {
        
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section] == nil ? "Undefined" : sections[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "Verdana", size: 17.0)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let favoriteAction = UIContextualAction(style: .normal, title: "") { action, view, handler in
            self.indexedRows[indexPath.section][indexPath.row].favorites = self.indexedRows[indexPath.section][indexPath.row].favorites ? false : true
            tableView.reloadData()
            
        }
        let config = UIImage.SymbolConfiguration(pointSize: 35.0, weight: .thin)
        let image = UIImage(systemName: "star.circle", withConfiguration: config)?.withTintColor(UIColor(named: "Yellow")!, renderingMode: .alwaysOriginal)
        favoriteAction.image = image
        favoriteAction.backgroundColor = .systemGray6

        
        let configuration = UISwipeActionsConfiguration(actions: [favoriteAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
}

extension CamerasViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return indexedRows[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CamerasTableViewCell
        cell.snapShotImage.image = indexedRows[indexPath.section][indexPath.row].snapshot
        cell.camNameLabel.text = "\(indexedRows[indexPath.section][indexPath.row].name)"
        cell.favoriteSign.isHidden = indexedRows[indexPath.section][indexPath.row].favorites ? true : false
        cell.recordSign.isHidden = indexedRows[indexPath.section][indexPath.row].rec ? true : false
        cell.playSign.isHidden = indexedRows[indexPath.section][indexPath.row].snapshot == nil ? true : false
        return cell
    }
    
    
}
