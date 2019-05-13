//
//  PredictiveData.swift
//  Deploy
//
//  Created by Cenes_Dev on 25/04/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import Foundation

class PredictiveData {
    
    var attendingFriends: Int!;
    var date: Int64 = 0;
    var predictivePercentage: Int = 0;
    var readableDate: String!;
    var totalFriends: Int = 0;
    
    func loadPredicitiveDataFromList(predictiveArray: NSArray) -> [PredictiveData] {
        
        var predictiveDataList = [PredictiveData]();

        for predictive in predictiveArray {
            
            let predictiveDict  = predictive as! NSDictionary
            
            let predictiveData = PredictiveData();
            predictiveData.attendingFriends = predictiveDict.value(forKey: "attendingFriends") as! Int;
            predictiveData.date = predictiveDict.value(forKey: "date") as! Int64;
            predictiveData.predictivePercentage = predictiveDict.value(forKey: "predictivePercentage") as! Int;
            predictiveData.readableDate = predictiveDict.value(forKey: "readableDate") as! String;
            predictiveData.totalFriends = predictiveDict.value(forKey: "totalFriends") as! Int;
            predictiveDataList.append(predictiveData);
        }
        
        return predictiveDataList;
    }
}
