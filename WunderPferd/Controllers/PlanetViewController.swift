//
//  PlanetViewController.swift
//  WunderPferd
//
//  Created by Vadim Gorodilov on 23.05.2022.
//

import UIKit

class PlanetViewController: UIViewController {
    
    private let rickNetworkManager = ServiceLocator.shared.rickNetworkManager
    private var nextPage = 1
    private var maxPages = Int.max
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
            guard let self = self else {
                return
            }
            self.tableView.reloadData()
            self.nextPage += 1
        }
    }
    
    func loadData(completion: @escaping () -> ()) {
        guard nextPage < maxPages else {
            return
        }
        rickNetworkManager.getLocations(page: nextPage) {
            [weak self] locations, error in
            guard let self = self else {
                return
            }
            if let locations = locations {
                self.locationList.append(contentsOf: locations.results)
                self.maxPages = locations.info.pages
                completion()
            } else {
                print(error as Any)
            }
        }
    }
    
    @IBAction func reloadButtonTap(_ sender: Any) {
        nextPage = 1
        maxPages = Int.max
        locationList.removeAll()
        loadData {
            [weak self] in
            guard let self = self else {
                return
            }
            self.tableView.reloadData()
            self.nextPage += 1
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
        cell.populationLabel.text = "population: \(location.residents.count)"
        
        if indexPath.row == locationList.count - 1 {
            loadData{
                [weak self] in
                guard let self = self else {
                    return
                }
                self.tableView.reloadData()
                self.nextPage += 1
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        locationList.count
    }
}
