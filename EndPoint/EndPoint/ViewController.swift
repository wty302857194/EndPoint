//
//  ViewController.swift
//  EndPoint
//
//  Created by wbb on 2021/1/14.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var currentDic : Dictionary<String, String>?
    var currentArray : Array<Any>?
    var timer = Timer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initUI()
    }
    @IBAction func historyClick(_ sender: Any) {
        
        let vc = HistoryViewController()
        self.navigationController!.pushViewController(vc, animated: true)
    }
    

}
/// MARK - init ui
extension ViewController {
    private func initUI() {
        self.title = "Home";
        tableView.register(UINib.init(nibName: "MyTableViewCell", bundle: nil), forCellReuseIdentifier: "indentifier")
        tableView.tableFooterView = UIView.init()

        
//        loadRequestData()
        
        self.titleLabel.text = "no history data, fetch data in 5s"
    
        addTimer()
    }
    
    
    @objc func onNotifitionClicks(notifi : Notification) {
       print("通知实现===\(notifi)")
   }
}
/// MARK - timer
extension ViewController {
    func addTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
            self.loadRequestData()
        }
        timer.fire()
        
        RunLoop.current.add(timer, forMode: .common)
    }
}
/// MARK - requestData
extension ViewController {
    func loadRequestData() {
        
        let req = URLRequest(url: URL(string: "https://api.github.com")!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 60)
        URLSession.shared.dataTask(with: req) { [weak self] (data, resp, err) in
            if let data = data {
                let jsonDic: NSDictionary = (self?.getDictionaryFromJSONString(data: data as NSData))!
                DispatchQueue.main.async {
                    self?.saveData(data: jsonDic as Any, key: "dataArr")
                    
                    self?.currentDic = Dictionary(_immutableCocoaDictionary: jsonDic)
                    self?.currentArray =  jsonDic.allKeys
                    self?.tableView.reloadData()
                }
            }
        }.resume()

    }
    
    func getDictionaryFromJSONString(data:NSData) ->NSDictionary{
        let dict = try? JSONSerialization.jsonObject(with: data as Data, options: .mutableContainers)
        if dict != nil {
            return dict as! NSDictionary
        }
        return NSDictionary()
         
     
    }
    
}

/// MARK  - delegate
extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentArray?.count ?? 0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MyTableViewCell = tableView.dequeueReusableCell(withIdentifier: "indentifier", for: indexPath) as! MyTableViewCell;
        let key: String = currentArray?[indexPath.row] as? String ?? ""
        
        cell.titleLab.text = key + "："
        cell.contentLab.text = currentDic?[key]
        return cell;
        
    }
}


/// MARK - tool

extension ViewController {
    func saveData(data: Any, key: String)  {
        
        objc_sync_enter(self)

        let time = self.currentTime()
        self.titleLabel.text = time

        guard var dataArr = UserDefaults.standard.value(forKey: key) as? Array<Any>  else {
            let dic = ["jsonData":data,"time":time];
            let arr: Array = [dic]
            
            UserDefaults.standard.setValue(arr, forKey: key)
            UserDefaults.standard.synchronize()

            NotificationCenter.default.post(name: NSNotification.Name(kNotifationName), object: nil, userInfo: ["userInfo":arr])
            
            objc_sync_exit(self)

            return
        }
        
        var dic = [String: Any]()
        dic["jsonData"] = data
        dic["time"] = time
        dataArr.append(dic);
        
        UserDefaults.standard.setValue(dataArr, forKey: key)
        UserDefaults.standard.synchronize()

        NotificationCenter.default.post(name: NSNotification.Name(kNotifationName), object: nil, userInfo: ["userInfo":dataArr])

        objc_sync_exit(self)
        

    }
    
    func currentTime() -> String {
        let date = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return timeFormatter.string(from: date)
        
    }
        
}
