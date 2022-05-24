//
//  TableViewController.swift
//  WunderPferd
//
//  Created by Student1 on 19.04.2022.
//

import UIKit

class TableViewController: UIViewController {
    
    var imageService = ServiceLocator.imageService()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: LocationTableViewCell.nibName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: LocationTableViewCell.nibName)
        
        for i in 10...80 {
            source.append(("Char \(i)", "desc \(i)", "https://rickandmortyapi.com/api/character/avatar/\(i).jpeg"))
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    var source: [(String, String, String)] = []
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TableViewController: UITableViewDelegate {
    // выюрана ячейка
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(source[indexPath.row].0)
    }
}

extension TableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return source.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // dequeue Reusable переиспользует вьюшки ячеек при пролистывании
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LocationTableViewCell.nibName) as? LocationTableViewCell else {
            return UITableViewCell()
        }
        let tuple = source[indexPath.row]
        cell.title.text = tuple.0
        cell.subtitle.text = tuple.1
        cell.id = tuple.2
        imageService.getImage(urlString: tuple.2) {
            image in
            guard let image = image else { return }
            cell.myImage.image = image
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        String(section)
    }

}
