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

class NBATeamsTableViewController: UITableViewController,NVActivityIndicatorViewable {
    lazy var teamsData = [Array<Team>]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.tableFooterView = UIView()
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
                    print(teamJson["profile"].rawString()!)
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
        var cell = tableView.dequeueReusableCell(withIdentifier: "nba_team")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "nba_team")
        }
        let teamsArray = self.teamsData[indexPath.section]
        let team = teamsArray[indexPath.row]
        
        cell?.textLabel?.text = team.name

        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let teamsArray = self.teamsData[indexPath.section]
        let team = teamsArray[indexPath.row]
        
        let teamScheduleView = NBATeamScheduleTableViewController()
        teamScheduleView.code = team.code!
        self.navigationController?.pushViewController(teamScheduleView, animated: true)
    }

}
