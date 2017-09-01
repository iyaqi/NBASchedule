//
//  Team.swift
//  NBA
//
//  Created by Dodge on 2017/8/27.
//  Copyright © 2017年 奇哥Dodge. All rights reserved.
//

import UIKit
import ObjectMapper

class Team: Mappable {
    
    var name:String?  //名称
    var code:String?  //代号
    var city:String?  //日期
    var division:String?  //分区
    var conference:String?  //联盟分区
    var displayConference:String? //联盟分区显示
    var imageUrl:String? //球队图片
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        code <- map["code"]
        city <- map["city"]
        division <- map["division"]
        conference <- map["conference"]
        displayConference <- map["displayConference"]
    }
}
