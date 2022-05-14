//
//  TableWithDataViewController.swift
//  WunderPferd
//
//  Created by Vadim Gorodilov on 09.05.2022.
//

import UIKit

class AutomaticViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        var test = CellData(data: "test")
    }
    
    var tableView: UITableView?
    var dataList: [SectionData]?
}
