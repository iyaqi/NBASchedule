//
//  Game.swift
//  NBA
//
//  Created by Dodge on 2017/8/20.
//  Copyright © 2017年 奇哥Dodge. All rights reserved.
//

import UIKit
import ObjectMapper

class Game : Mappable{
    var gameDate:String?  //日期
    var gameAddress:String? // 比赛地址
    var homeTeamCity:String? // 主场城市
    var homeTeamName:String? // 主场球队
    var awayTeamCity:String? // 客场城市
    var awayTeamName:String? // 客场球队
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        gameDate      <- map["profile.utcMillis"]
        gameAddress   <- map["profile.arenaName"]
        homeTeamCity  <- map["homeTeam.profile.city"]
        homeTeamName  <- map["homeTeam.profile.name"]
        awayTeamCity  <- map["awayTeam.profile.city"]
        awayTeamName  <- map["awayTeam.profile.name"]
    }
    
    
}
