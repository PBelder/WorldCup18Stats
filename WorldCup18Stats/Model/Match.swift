//
//  Match.swift
//  WorldCup18Stats
//
//  Created by Pavel Belder on 21/06/2018.
//  Copyright © 2018 Pavel Belder. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Match{
    
    let teamA:String
    let teamB:String
    let date:Date
    let teamAGoalsScored:Int? //optional in case the match hasn't been played yet
    let teamBGoalsScored:Int? //optional in case the match hasn't been played yet
    
    
    init(teamA:String,teamB:String,date:Date,teamAGoalsScored:Int?,teamBGoalsScored:Int?) {
        
        self.teamA = teamA
        self.teamB = teamB
        self.date = date
        self.teamAGoalsScored = teamAGoalsScored
        self.teamBGoalsScored = teamBGoalsScored
    }
    
    /*
     i would prefer to use a decoder (make Match conform to 'Codable' or 'Decodable')
     but in this case i found this easier.
     */
    init?(fromJSON matchJSON:JSON){
        
        //check that all the non optioanal values are here
        guard   let teamA =  matchJSON["team1"]["name"].string ,
                let teamB =  matchJSON["team2"]["name"].string,
                let dateStr = matchJSON["date"].string ,
                let timeStr = matchJSON["time"].string else {return nil}
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        guard let aDateTime = formatter.date(from: dateStr + " " + timeStr) else {return nil}
        
        let teamAGoalsScored = matchJSON["score1"].int
        let teamBGoalsScored = matchJSON["score2"].int
        
        //validate that either both scores are here or non
        if  !((teamAGoalsScored == nil && teamBGoalsScored == nil) ||
            (teamAGoalsScored != nil && teamAGoalsScored != nil)) {
            return nil
        }
     
        self.init(teamA: teamA, teamB: teamB, date: aDateTime, teamAGoalsScored: teamAGoalsScored, teamBGoalsScored: teamBGoalsScored)
    }
}

