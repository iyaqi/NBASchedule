

//
//  NBATeamTableViewCell.swift
//  NBA
//
//  Created by Dodge on 2017/9/2.
//  Copyright © 2017年 奇哥Dodge. All rights reserved.
//

import UIKit

class NBATeamTableViewCell: UITableViewCell {

    @IBOutlet weak var teamImageView: UIImageView!
    
    @IBOutlet weak var divisionNameLabel: UILabel!
    @IBOutlet weak var teamNameLabel: UILabel!
    
    func setContent(_ team:Team ){
        
        teamImageView?.load.request(with: team.imageUrl!)
        teamNameLabel.text = team.name
        divisionNameLabel.text = team.division
    }

}
