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
import CDAlertView


class NBATeamScheduleTableViewController: UITableViewController,NVActivityIndicatorViewable {
    
    var team : Team
    lazy var datas = [Game]()
    
    lazy var eventStore = EKEventStore()
    
    init(team:Team) {
        self.team =  team
        super.init(style: .plain)
        print(self.team.code!)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self .initSubView()
        
        self.fetchSchedule()
    }
    
    func initSubView(){
        
    
        self.title = self.team.code?.capitalized
        
        self.tableView.register(UINib.init(nibName: "GameTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "schedule")
        self.tableView.tableFooterView = UIView()
        self.tableView.estimatedSectionHeaderHeight=0;
        self.tableView.estimatedSectionFooterHeight=0;
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "导入日历", style: .done, target: self, action: #selector(NBATeamScheduleTableViewController.insertEventToCalendar))
        
        
        let header = UIView(frame: CGRect(x: 0, y: 0, width:UIScreen.main.bounds.width , height: 50))
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
        Alamofire.request("http://china.nba.com/static/data/team/schedule_\(self.team.code!).json").responseJSON { (response) in
    
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

            //授权过可以方位日历
            if granted{
                let tempArray = self.eventStore.calendars(for: .event)
                var inserted = false
                for calendar in tempArray{
                    print(calendar)
                    
                    //判断是否已经导入了比赛内容
                    if calendar.title == self.team.name {
                        inserted = true
                    }
                }
                
                if !inserted {
                    self.saveEvent()
                }else{
                    DispatchQueue.main.async {
                        CDAlertView(title: "", message: "已经导入过该队比赛!", type: .notification).show()
                    }
                }
            }
        })
    }
    
    func saveEvent(){
        
        let alertView = CKAlertViewController.alert(withTitle: nil, message: "导入到日历？")
        
        let cancelAction = CKAlertAction(title: "取消") { (action) in
        }
        let sureAction = CKAlertAction(title: "确定") { (action) in
            
//             删除日历的事件
//            let tempArray = self.eventStore.calendars(for: .event)
//            for calendar in tempArray{
//                print(calendar)
//                if calendar.title == self.code {
//                    do{
//                        try self.eventStore.removeCalendar(calendar, commit: true)
//                    }catch let error as NSError{
//                        print(error)
//                    }
//                }
//            }
            
            self.startAnimating(CGSize(width: 30, height: 30),type:.ballBeat,color: UIColor.init(hexString: "#E0486C"),backgroundColor:UIColor.white)
            
//            异步任务
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
                    
                    let calendar = self.eventStore.defaultCalendarForNewEvents
                    calendar.title = self.team.name! + "赛程"
                    calendar.cgColor = UIColor.purple.cgColor
                    event.calendar = calendar
                    
                    do{
                        try self.eventStore.save(event, span: EKSpan.thisEvent)
                    }catch let error as NSError{
                        print(error)
                    }
                }
                //主线程刷新UI
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
