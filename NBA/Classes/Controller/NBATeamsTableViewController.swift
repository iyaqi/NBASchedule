//
//  NBATeamsTableViewController.swift
//  NBA
//
//  Created by Dodge on 2017/8/27.
//  Copyright © 2017年 奇哥Dodge. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView
import SwiftyJSON
import ImageLoader



class NBATeamsTableViewController: UITableViewController,NVActivityIndicatorViewable {
    lazy var teamsData = [Array<Team>]()
    var logoInfo:[String:Any]?
    
    private let TeamCellIdentifier = "nba_team"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.tableFooterView = UIView()
        self.tableView.rowHeight = 80;
        self.tableView.register(UINib.init(nibName: "NBATeamTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: TeamCellIdentifier)
        
        let path = Bundle.main.path(forResource: "Team_Logo", ofType: ".json")
        let logoJsonData = NSData(contentsOfFile: path!)
        logoInfo = JSON(data: logoJsonData! as Data).dictionaryValue
        

        self.fetchNBATeams()
    }
    
    func fetchNBATeams() {
        Alamofire.request("http://china.nba.com/static/data/league/conferenceteamlist.json").responseJSON { (response) in
            let result = JSON(response.result.value as Any)
//            print(result)
            let listGroups = result["payload"]["listGroups"].arrayValue
            
            for teams in listGroups{
                var tempArray = [Team]()
                for teamJson in teams["teams"].arrayValue{
//                    print(teamJson["profile"].rawString()!)
                    let team = Team(JSONString: teamJson["profile"].rawString()!)
                    tempArray.append(team!)
                }
                self.teamsData.append(tempArray)
            }
            self.tableView.reloadData()
        }
    }

  
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.teamsData.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let teamsArray = self.teamsData[section]
        return teamsArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:NBATeamTableViewCell = tableView.dequeueReusableCell(withIdentifier: TeamCellIdentifier, for: indexPath) as! NBATeamTableViewCell
        
        let teamsArray = self.teamsData[indexPath.section]
        let team = teamsArray[indexPath.row]
        
        //拼接图片的url
        let a = self.logoInfo?[team.code!]!
        let imageUrlString = "http://mat1.gtimg.com/sports/nba/logo/1602/\(String(describing: a!)).png"
        team.imageUrl = imageUrlString
        
        cell.setContent(team)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let teamsArray = self.teamsData[indexPath.section]
        let team = teamsArray[indexPath.row]
        
        let teamScheduleView = NBATeamScheduleTableViewController(team: team)
        self.navigationController?.pushViewController(teamScheduleView, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let teamsArray = self.teamsData[section]
        let team = teamsArray[0]
        return team.displayConference
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

}
