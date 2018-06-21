//
//  ViewController.swift
//  WorldCup18Stats
//
//  Created by Pavel Belder on 21/06/2018.
//  Copyright © 2018 Pavel Belder. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import NVActivityIndicatorView


/*
 The app presents a list of matches from the groups stage of the current world cup.
 I found an api that returns a json with all the matches.
 When the view is about to come up , i send a requests to get the json from the server.
 The json is parsed to a dictionary such that every key is a date of a match and the value for
 the key is an array of matches played on that day , sorted by date.
 There is not much to present after the group phase cause little is known and it's a different kind of
 json there so i skipped it :).
 If there was a network error , there is an appropriate message.
 If the JSON had an error in it, there is an appropriate message.
 There might be bugs (obviously) but i've tested a little - happy day seems to work.
 */
class ViewController: UIViewController, NVActivityIndicatorViewable {
    
    //MARK:- Properties
    @IBOutlet weak var tableView: UITableView!
    let cellReuseIdentifier = "cell"
    
    //Datasource
    var matchesDict :[Date:[Match]] = [:]{
        
        didSet{
            self.sortedMatchesDatesArr = self.matchesDict.keys.sorted()
            self.tableView.reloadData()
        }
    }
    
    var sortedMatchesDatesArr:[Date] = []
    
    
    //MARK:- Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //start indicator animation
        self.startAnimatingNVActivityIndicatorView()
        
        //begin fetching the json
        WCNetworkManager.fetchWorldCupJSON { [weak self] (json) in
            
            //stop the animation
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
                
                self?.stopAnimating()
                
                guard let json = json else{
                    
                    self?.showErrorMessage(error: WCError.networkError)
                    return
                }
                
                guard let matchesDict = WCDataManager.getMatchesByDayFromJSON(json: json) else {
                    
                    self?.showErrorMessage(error: WCError.invalideJSON)
                    return
                }
                
                self?.matchesDict =  matchesDict
                
                
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- NVActivityIndicatorView animation
    func startAnimatingNVActivityIndicatorView(){
        
        let bgColor = UIColor.white.withAlphaComponent(0.5)
        let color = UIColor(red: 0, green: 136/255, blue: 204/255, alpha: 1)
        
        startAnimating(type: NVActivityIndicatorType.ballClipRotate,color:color, backgroundColor:bgColor)
    }
    
    
    func showErrorMessage(error:WCError){
        
        var errorAlertMessage = "an error has occured"
        
        switch error {
            
        case .invalideJSON:
            errorAlertMessage = "A server error has occured"
            
        case .networkError:
            errorAlertMessage = "A network error has occured"

        }
        
        let okBtnTitle = "Ok"
        
        let errorAlertController = UIAlertController (title: errorAlertMessage, message: nil, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: okBtnTitle, style: UIAlertActionStyle.cancel, handler: nil)
        
        errorAlertController .addAction(okAction)
        
        self.present(errorAlertController , animated: true, completion: nil)
    }
}
    


//MARK:- UITableViewDataSource
extension ViewController : UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.matchesDict.keys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.matchesDict[self.sortedMatchesDatesArr[section]]!.count)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let date = self.sortedMatchesDatesArr[section]
        let str = date.toString(style: .weekday) + ", " + date.toString(style:.month) + " " + date.toString(style: .ordinalDay)
        
        return str
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: self.cellReuseIdentifier, for: indexPath) as! MatchTableViewCell
        
        let date = self.sortedMatchesDatesArr[indexPath.section]
        let match = self.matchesDict[date]![indexPath.row]
        
        let numberOfGoalsTeamA = match.teamAGoalsScored != nil ? match.teamAGoalsScored! : 0
        let numberOfGoalsTeamB = match.teamBGoalsScored != nil ? match.teamBGoalsScored! : 0
        
        cell.setupCellWith(teamAName: match.teamA, teamBName:  match.teamB, teamAScore: numberOfGoalsTeamA, teamBScore: numberOfGoalsTeamB , timeOfDay:match.date)
        
        return cell
    }
}


