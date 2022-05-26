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
    private var maxPages = Int.max
    private var folio: Folio!
    private var locationList: [Location] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    private enum scrollDirection { case up, down }
    
    private struct Constants {
        static let locationLimit = 60
    }
    
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
        }
    }

    private func loadData(direction: scrollDirection = .down, completion: @escaping () -> ()) {
        var nextPage: Int
        if locationList.isEmpty {
            nextPage = 1
        } else {
            switch direction {
            case .up:
                nextPage = (locationList.first?.page ?? 0) - 1
            case .down:
                nextPage = (locationList.last?.page ?? 0) + 1
            }
        }
        guard nextPage > 0 && nextPage <= maxPages else { return }
        locationNetworkManager.getLocations(page: nextPage) {
            [weak self] locations, error in
            guard let self = self else {
                return
            }
            if let locations = locations {
                var position = 0
                for var location in locations.results {
                    location.page = nextPage
                    switch direction {
                    case .up:
                        self.locationList.insert(location, at: position)
                        position += 1
                    case .down:
                        self.locationList.append(location)
                    }
                }
                print("add \(direction)")
                if self.locationList.count > Constants.locationLimit {
                    var removePage: Int?
                    switch direction {
                    case .up:
                        print("rem bot")
                        removePage = self.locationList.last?.page
                    case .down:
                        print("rem top")
                        removePage = self.locationList.first?.page
                    }
                    self.locationList.removeAll(where: { location in location.page == removePage })
                
                }
                self.maxPages = locations.info.pages
                print(self.tableView.contentOffset.y)
                completion()
            } else {
                ErrorMessageSnackBar.showMessage(in: self.view, message: "ошибка загрузки данных")
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
            print("reload")
            self.tableView.reloadData()
            self.nextPage += 1
        }
    }
}

extension PlanetViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: move to planet controller
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        folio.tableView(tableView, willDisplay: cell, forRowAt: indexPath)
        if indexPath.row == 0 {
            loadData(direction: .up) {
                self.tableView.reloadData()
            }
        }
        if indexPath.row > locationList.count - 5 {
            loadData(direction: .down) {
                self.tableView.reloadData()
            }
        }
    }
}

extension PlanetViewController: UITableViewDataSource, FolioDelegate  {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PlanetTableViewCell.className) as? PlanetTableViewCell else {
            return UITableViewCell()
        }
        let location = locationList[indexPath.row]
        cell.locationLabel.text = location.name
        cell.typeLabel.text = location.type
        cell.populationLabel.text = "population: \(location.id)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        locationList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func reachedBottom(in tableView: UITableView) {
        print("bottom")
        loadData(direction: .down) {
            self.tableView.reloadData()
        }
    }
    
    func reachedTop(in tableView: UITableView) {
        print("top")
    }
}
