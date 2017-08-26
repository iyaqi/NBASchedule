//
//  ViewController.swift
//  NBA
//
//  Created by Dodge on 2017/8/15.
//  Copyright © 2017年 奇哥Dodge. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView

class ViewController: UITableViewController {
    lazy var datas = [JSON]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tableView.register(UINib.init(nibName: "GameTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "schedule")
        self.tableView.tableFooterView = UIView()
        
        let activityIndicatorView = NVActivityIndicatorView(frame: CGRect.init(x: 0, y: 0, width: 50, height: 50), type: .ballBeat, color: UIColor.init(hexString: "#E0486C"), padding: 5)
        activityIndicatorView.startAnimating()
        self.fetchSchedule()
    }
    
    func fetchSchedule() -> Void {
        Alamofire.request("http://china.nba.com/static/data/team/schedule_celtics.json").responseJSON { (response) in
            
            // swiftJson的解析方式
            let json = JSON(response.result.value as Any)
            for monthGroups in json["payload"]["monthGroups"].arrayValue{
                for game in monthGroups["games"].arrayValue{
                    self.datas.append(game)
                }
            }

//            原始的解析方法
//            if let json = response.result.value as? NSDictionary {
//                if let payload = json["payload"] as? NSDictionary{
//
//                    if let monthGroups = payload["monthGroups"] as? NSArray{
////                        print(monthGroups)
////                        print(monthGroups[0])
//                        for monthGames in monthGroups{
//                            if let monthGamesDict = monthGames as? NSDictionary{
//                                if let games = monthGamesDict["games"] as? NSArray{
//                                    print(games)
//                                    for x in games{
//                                        let game = x as? NSDictionary
//                                        self.datas.append(game!)
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//            }
            self.tableView.reloadData()
        }
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datas.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:GameTableViewCell = tableView.dequeueReusableCell(withIdentifier: "schedule") as! GameTableViewCell
        let game = self.datas[indexPath.row]
        
        cell.setContent(game: game)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

