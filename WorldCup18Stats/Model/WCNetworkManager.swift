//
//  WCNetworkManager.swift
//  WorldCup18Stats
//
//  Created by Pavel Belder on 21/06/2018.
//  Copyright © 2018 Pavel Belder. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

fileprivate let wcUrl = "https://raw.githubusercontent.com/openfootball/world-cup.json/master/2018/worldcup.json"

/*
 This class is in charge of all the network calls to the world cup API
 */
class WCNetworkManager{
    
    class func fetchWorldCupJSON(copletionHandler:@escaping (_:Any?)->Void){
        
        guard let url = URL(string: wcUrl) else {return}
        
        Alamofire.request(url).validate().responseJSON { (res) in
                        
            guard res.result.isSuccess else {
                
                print("res.result.isSuccess == false")
                copletionHandler(nil)
                return
            }
            
            guard let json = res.result.value else {

                print("Error while fetching json")
                copletionHandler(nil)
                return
            }
            
            copletionHandler(json)
        }
    }
    
}
