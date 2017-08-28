//
//  NBATeamScheduleTableViewController.swift
//  NBA
//
//  Created by Dodge on 2017/8/27.
//  Copyright © 2017年 奇哥Dodge. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView
import SnapKit
import EventKit


class NBATeamScheduleTableViewController: UITableViewController,NVActivityIndicatorViewable {
    
    var code : String = "celtics"
    lazy var datas = [Game]()
    
    lazy var eventStore = EKEventStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self .initSubView()
        
        self.fetchSchedule()
    }
    
    func initSubView(){
        self.tableView.register(UINib.init(nibName: "GameTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "schedule")
        self.tableView.tableFooterView = UIView()
        
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "导入日历", style: .done, target: self, action: #selector(NBATeamScheduleTableViewController.insertEventToCalendar))
        
        
        let header = UIView(frame: CGRect(x: 0, y: 0, width: self.view.width, height: 50))
        self.tableView.tableHeaderView = header
        
        let homeLabel = UILabel()
        homeLabel.text = "主场"
        homeLabel.textAlignment = .left
        homeLabel.font = UIFont.boldSystemFont(ofSize: 17)
        homeLabel.textColor = UIColor.red
        header.addSubview(homeLabel)
        homeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(header).offset(20)
            make.bottom.equalTo(header).offset(-5)
            make.width.equalTo(100)
        }
        
        
        let awayLabel = UILabel()
        awayLabel.text = "客场"
        awayLabel.textAlignment = .right
        awayLabel.font = UIFont.boldSystemFont(ofSize: 17)
        awayLabel.textColor = UIColor.blue
        header.addSubview(awayLabel)
        awayLabel.snp.makeConstraints { (make) in
            make.right.equalTo(header).offset(-20)
            make.bottom.equalTo(header).offset(-5)
            make.width.equalTo(100)
        }
        
        let line = UILabel()
        line.backgroundColor = UIColor.lightGray
        line.alpha = 0.4
        header.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.right.left.equalTo(header)
            make.bottom.equalTo(header)
            make.height.equalTo(0.8)
        }

    }
    
    func fetchSchedule(){
        startAnimating(CGSize(width: 30, height: 30),type:.ballBeat,color: UIColor.init(hexString: "#E0486C"),backgroundColor:UIColor.white)
        Alamofire.request("http://china.nba.com/static/data/team/schedule_\(self.code).json").responseJSON { (response) in
    
        // swiftJson的解析方式
        let json = JSON(response.result.value as Any)
        for monthGroups in json["payload"]["monthGroups"].arrayValue{
            
            for game in monthGroups["games"].arrayValue{
                
        //使用原始的JSON数据
        //   self.datas.append(game)
                
        //生成模型
                let gameModel = Game(JSONString: game.rawString()!)
                self.datas.append(gameModel!)
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
            self.stopAnimating()
        }
    }
    
    //插入到日历中
    func insertEventToCalendar(){
        self.eventStore .requestAccess(to: .event, completion: { (granted, error) in

            //授权过
            if granted{
                self.saveEvent()
            }
        })
    }
    
    func saveEvent(){
        
       
        
        let alertView = CKAlertViewController.alert(withTitle: nil, message: "导入到日历？")
        
        let cancelAction = CKAlertAction(title: "取消") { (action) in
        }
        let sureAction = CKAlertAction(title: "确定") { (action) in
            
            self.startAnimating(CGSize(width: 30, height: 30),type:.ballBeat,color: UIColor.init(hexString: "#E0486C"),backgroundColor:UIColor.white)
            
            DispatchQueue.global().async {
            //把比赛写入日历
//            print(self.eventStore)
                for game in self.datas{
                    
                    let event = EKEvent(eventStore: self.eventStore)
                    
                    // 标题
                    let title = game.homeTeamName! + "VS" + game.awayTeamName!
                    event.title = title
                    
                    //时间
                    let date = Date.init(timeIntervalSince1970: TimeInterval(Int64(game.gameDate!)!/1000))
                    
                    event.startDate = date
                    event.endDate = date.addingTimeInterval(150*60)
                    event.calendar = self.eventStore.defaultCalendarForNewEvents
                    
                    do{
                        try self.eventStore.save(event, span: EKSpan.thisEvent)
                    }catch let error as NSError{
                        print(error)
                    }
                }
                DispatchQueue.main.async {
                    self.stopAnimating()
                }
            }
        
        }
        alertView?.addAction(cancelAction)
        alertView?.addAction(sureAction)
        self.present(alertView!, animated: true, completion: nil)
    }
    
    // MARK: - tableView
    
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
