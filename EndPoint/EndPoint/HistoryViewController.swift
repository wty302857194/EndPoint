//
//  HistoryViewController.swift
//  EndPoint
//
//  Created by wbb on 2021/1/15.
//

import UIKit
private let kIdentifier: String = "Identifier"
class HistoryViewController: UIViewController {
    var dataArray = Array<Any>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        NotificationCenter.default.addObserver(self, selector: #selector(onNotifitionClicks), name: Notification.Name(kNotifationName), object: nil)

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
extension HistoryViewController {
    private func initUI() {
        view.addSubview(tableView)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: kIdentifier)
        
        tableView.tableFooterView = UIView.init()
    }
    
    
    @objc func onNotifitionClicks(notifi : Notification) {
        dataArray = notifi.userInfo!["userInfo"] as! [Any]
        
        tableView.reloadData()
   }
}

/// MARK - delegate
extension HistoryViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: kIdentifier)!
        cell.accessoryType = .disclosureIndicator;
        if let dic = dataArray[dataArray.count - 1 - indexPath.row] as? Dictionary<String, Any> {
            cell.textLabel?.text = (dic["time"] as! String)

        }
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        if let dic = dataArray[dataArray.count - 1 - indexPath.row] as? Dictionary<String, Any> {
            vc.dataDic = dic["jsonData"] as? Dictionary<String, String>
        }
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
}
