//
//  PlanetViewController.swift
//  WunderPferd
//
//  Created by Vadim Gorodilov on 23.05.2022.
//

import UIKit

class PlanetViewController: UIViewController {
    
    private let rickNetworkManager = ServiceLocator.shared.rickNetworkManager
    private var currentPage = 1
    private var locationList: [Location] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: PlanetTableViewCell.className, bundle: nil),
                           forCellReuseIdentifier: PlanetTableViewCell.className)
        loadData {
            [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
            self.currentPage += 1
        }
    }
    
    func loadData(completion: @escaping () -> ()) {
        rickNetworkManager.getLocations(page: currentPage) {
            [weak self] locations, error in
            guard let self = self else { return }
            if let locations = locations {
                self.locationList.append(contentsOf: locations.results)
                completion()
            } else {
                print(error as Any)
            }
        }
    }
}

extension PlanetViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: move to planet controller
    }
}

extension PlanetViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PlanetTableViewCell.className) as? PlanetTableViewCell else {
            return UITableViewCell()
        }
        let location = locationList[indexPath.row]
        cell.locationLabel.text = location.name
        cell.typeLabel.text = location.type
        cell.populationLabel.text = String(location.residents.count)
        
        if indexPath.row == locationList.count - 1 {
            loadData{
                [weak self] in
                guard let self = self else { return }
                print("loading page \(self.currentPage)")
                self.tableView.reloadData()
                self.currentPage += 1
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        locationList.count
    }
}
