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
    
    
    func setContent( game:Game ){
        //主场
        self.homeTeamCity.text = game.homeTeamCity
        self.homeTeamName.text = game.homeTeamName
        //客场
        self.awayTeamCity.text = game.awayTeamCity
        self.awayTeamName.text = game.awayTeamName
        
        //主场
        self.gameAddress.text = "球馆:" + game.gameAddress!

        //日期
        let date = NSDate.init(timeIntervalSince1970: TimeInterval(Int64(game.gameDate!)!/1000))
        self.gameDate.text = "北京日期:" + date.string(withFormat: "yyyy年MM月dd日 HH:mm")!
    }
    
}
