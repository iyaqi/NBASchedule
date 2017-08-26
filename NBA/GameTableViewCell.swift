//
//  GameTableViewCell.swift
//  NBA
//
//  Created by Dodge on 2017/8/26.
//  Copyright © 2017年 奇哥Dodge. All rights reserved.
//

import UIKit
import SwiftyJSON
import YYKit

class GameTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var homeTeamCity: UILabel!

    @IBOutlet weak var homeTeamName: UILabel!
    
    @IBOutlet weak var gameDate: UILabel!
    @IBOutlet weak var gameAddress: UILabel!
    
    @IBOutlet weak var awayTeamCity: UILabel!
    
    @IBOutlet weak var awayTeamName: UILabel!
    
    
    func setContent( game:JSON ){
        //主场
        self.homeTeamCity.text = game["homeTeam"]["profile"]["city"].stringValue
        self.homeTeamName.text = game["homeTeam"]["profile"]["name"].stringValue
        
        //客场
        self.awayTeamCity.text = game["awayTeam"]["profile"]["city"].stringValue
        self.awayTeamName.text = game["awayTeam"]["profile"]["name"].stringValue
        
        //主场
        self.gameAddress.text = "球馆:" + game["profile"]["arenaName"].stringValue

        //日期
        let date = NSDate.init(timeIntervalSince1970: TimeInterval(game["profile"]["utcMillis"].int64Value/1000) )
        self.gameDate.text = "日期:" + date.string(withFormat: "yyyy年MM月dd日")!
    }
    
}
