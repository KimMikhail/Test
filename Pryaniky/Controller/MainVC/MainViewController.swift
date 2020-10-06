//
//  MainViewController.swift
//  Pryaniky
//
//  Created by  Mikhail on 28.09.2020.
//  Copyright © 2020  Mikhail. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {

    var dataModel: DataModel?
    var dataManager = DataManager.shared
    var views: [String]? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    var rowIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
        customizeView()
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        views?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell",
                                                 for: indexPath)
        customizeCell(cell: &cell,
                      indexPath: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath,
                              animated: true)
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        rowIndex = indexPath.row
        return indexPath
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let detailsVC = segue.destination as? DetailsViewController
        detailsVC?.data = dataModel?.data.first(where: { (data) -> Bool in
            return data.name == views![rowIndex]
        })
    }
    
    private func getData() {
        dataManager.fetchData()
        dataManager.onCompletion = { [weak self] dataModel in
            guard let self = self else { return }
            self.dataModel = dataModel
            self.views = dataModel.view
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private func customizeCell(cell: inout UITableViewCell, indexPath: IndexPath) {
        guard let view = views?[indexPath.row] else { return }
        guard ArrayEnum.init(rawValue: view) != nil else { return }
        cell.textLabel?.text = String(describing: ArrayEnum.init(rawValue:view)!)
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .lightGray
        cell.layer.cornerRadius = 10
        cell.layer.borderWidth = 3
        cell.layer.borderColor = .init(srgbRed: 255,
                                       green: 255,
                                       blue: 255,
                                       alpha:  1)
        
    }
    
    private func customizeView() {
        
        title = "Pryaniky"
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.separatorStyle = .none
        
    }
    
    @IBAction func showAllTypes(_ sender: Any) {
        guard let data = dataModel?.data else { return }
        
        let alertController = UIAlertController(title: "All Types", message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel)
    
        alertController.addAction(okAction)

        for data in data {
            alertController.message! += data.name + "\n"
        }
        
        present(alertController, animated: true)
    }
    
}



