//
//  WCDataManager.swift
//  WorldCup18Stats
//
//  Created by Pavel Belder on 21/06/2018.
//  Copyright © 2018 Pavel Belder. All rights reserved.
//

import Foundation
import SwiftyJSON
import AFDateHelper

enum WCError : Error {
    
    case invalideJSON
    case networkError
}

/*
 This class is in charge of manipulating the data.
 I'm invoking SwiftyJSON here and not in the network manager in case
 sometime in the future , I decide to user a different framework
 */
class WCDataManager {
    

    /**
     - parameters:
        - json: the full json as it came from the server
     
     - returns: a dictionary where every key is a date representing a day of matches and the value is an array of the matches played on that day. If an error has occured, returns nil.
     */
    class func getMatchesByDayFromJSON(json:Any)->[Date:[Match]]?{
        
        let swiftyJSON = JSON(json)
        
        var matchesDict:[Date:[Match]] = [:]
        
        for (_,matchDay):(String, JSON) in swiftyJSON["rounds"] {
            
            //PB - need to check what happens when Mathes init fails
            let matches = try? matchDay["matches"].arrayValue.map { (matchJSON) throws -> Match in
                
                guard let match = Match(fromJSON: matchJSON) else{
                        throw WCError.invalideJSON
                }
                return match
            }
            
            //if there was an error in the matches creation, return nil
            guard var matchesArr = matches else {return nil}
            
            //if there are no matches on that day (or an error on the data, move on to the next day)
            if matchesArr.count == 0 {
                continue
            }
        
            //sort the array by date (the earlier matches first)
            matchesArr.sort {return $0.date < $1.date}
            
            //get the date with the time nullified
            let matchDayDate = matchesArr[0].date.adjust(hour: 0, minute: 0, second: 0)
            
            matchesDict[matchDayDate] = matchesArr
        }
        
        return matchesDict
    }
}
