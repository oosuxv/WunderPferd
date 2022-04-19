//
//  TableViewController.swift
//  WunderPferd
//
//  Created by Student1 on 19.04.2022.
//

import UIKit

class TableViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: LocationTableViewCell.nibName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: LocationTableViewCell.nibName)
    }
    
    @IBOutlet weak var tableView: UITableView!
    var source: [(String, String)] = [
        ("oneTitle", "oneSubtitle"),
        ("1", "2"),
        ("Fuck you", "asshole"),
        ("more", "data"),
        ("other", "stuff"),
        ("please", "stop")
    ]
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
        if section == 0 {
            return 1
        }
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
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        String(section)
    }

}
