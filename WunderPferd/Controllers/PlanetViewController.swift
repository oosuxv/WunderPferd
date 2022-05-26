//
//  PlanetViewController.swift
//  WunderPferd
//
//  Created by Vadim Gorodilov on 23.05.2022.
//

import UIKit

class PlanetViewController: UIViewController {
    
    private let locationNetworkManager = ServiceLocator.locationNetworkManager()
    private var nextPage = 1
    private var allPagesLoaded = false
    private var isLoading = false
    private var locationList: [Location] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: PlanetTableViewCell.className, bundle: nil),
                           forCellReuseIdentifier: PlanetTableViewCell.className)
        loadData()
    }
    
    func loadData() {
        guard !allPagesLoaded && !isLoading else {
            return
        }
        isLoading = true
        locationNetworkManager.getLocations(page: nextPage) {
            [weak self] locations, error in
            guard let self = self else {
                return
            }
            if let locations = locations {
                self.locationList.append(contentsOf: locations.results)
                self.tableView.reloadData()
                self.allPagesLoaded = self.nextPage >= locations.info.pages
                self.nextPage += 1
                self.isLoading = false
            } else {
                ErrorMessageSnackBar.showMessage(in: self.view, message: "ошибка загрузки данных")
                print(error as Any)
            }
        }
    }
    
    @IBAction func reloadButtonTap(_ sender: Any) {
        nextPage = 1
        allPagesLoaded = false
        isLoading = false
        locationList.removeAll()
        loadData()
    }
}

extension PlanetViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: move to planet controller
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row > locationList.count - 5 {
            loadData()
        }
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        locationList.count
    }
}
