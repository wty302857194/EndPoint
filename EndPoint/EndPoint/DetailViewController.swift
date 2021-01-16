//
//  DetailViewController.swift
//  EndPoint
//
//  Created by wbb on 2021/1/15.
//

import UIKit

class DetailViewController: UIViewController {

    var dataArray = Array<String>()
    var dataDic : Dictionary<String, String>! {
        didSet {
            dataArray = Array(dataDic.keys);
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        for (key, value) in self.dataDic {
           print("字典 key \(key) -  字典 value \(value)")
            dataArray.append(key)
        }

        initUI()
    }


    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

}
/// MARK - init ui
extension DetailViewController {
    private func initUI() {
        view.addSubview(tableView)
        
        tableView.register(UINib.init(nibName: "MyTableViewCell", bundle: nil), forCellReuseIdentifier: "indentifier")

        tableView.tableFooterView = UIView.init()
    }
}

/// MARK - delegate
extension DetailViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MyTableViewCell = tableView.dequeueReusableCell(withIdentifier: "indentifier", for: indexPath) as! MyTableViewCell;
        if let key:String = dataArray[indexPath.row] {
                cell.titleLab.text = key + "："
                cell.contentLab.text = dataDic?[key]
            }
        
        
        
        
        return cell;
        
    }
    
    
}
