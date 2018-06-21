//
//  MatchTableViewCell.swift
//  WorldCup18Stats
//
//  Created by Pavel Belder on 21/06/2018.
//  Copyright © 2018 Pavel Belder. All rights reserved.
//

import Foundation
import UIKit
import AFDateHelper

class MatchTableViewCell:UITableViewCell{
    
    @IBOutlet weak var teamALabel:UILabel?
    @IBOutlet weak var teamBLabel:UILabel?
    @IBOutlet weak var teamAScoreLabel:UILabel?
    @IBOutlet weak var teamBScoreLabel:UILabel?
    @IBOutlet weak var timeOfDayLabel:UILabel?
    
    func setupCellWith(teamAName:String,
                       teamBName:String,
                       teamAScore:Int,
                       teamBScore:Int,
                       timeOfDay:Date){
        
        self.teamALabel?.text = teamAName
        self.teamBLabel?.text = teamBName
        self.teamAScoreLabel?.text = "\(teamAScore)"
        self.teamBScoreLabel?.text = "\(teamBScore)"
        
        let timeStr =  timeOfDay.toString(format: DateFormatType.custom("HH:mm"))
        
        
        
//        let timeStr = "\(String(describing: timeOfDay.component(DateComponentType.hour)))" + ":" + "\(timeOfDay.component(DateComponentType.minute))"
        
        self.timeOfDayLabel?.text = timeStr
    }
}
