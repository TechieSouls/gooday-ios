//
//  CenesProperty.swift
//  Deploy
//
//  Created by Cenes_Dev on 10/05/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import Foundation

class CenesProperty {
    
    var cenesPropertyId: Int32!
    var name: String!;
    var cenesPropertyValue: CenesPropertyValue!;
    
    func loadCenesProperty(cenesPropertyDict: NSDictionary) -> CenesProperty {
        
        let cenesProperty = CenesProperty();
        cenesProperty.cenesPropertyId = cenesPropertyDict.value(forKey: "cenesPropertyId") as! Int32?
        cenesProperty.name = cenesPropertyDict.value(forKey: "name") as! String;
        
        let cenesPropertyValueDict = cenesPropertyDict.value(forKey: "cenesPropertyValue") as! NSDictionary;
        cenesProperty.cenesPropertyValue = loadCenesPropertyValue(cenesPropertyValueDict: cenesPropertyValueDict);
        
        return cenesProperty;
    }
    
    
    func loadCenesPropertyValue(cenesPropertyValueDict: NSDictionary) -> CenesPropertyValue {
        let cenesPropertyValue = CenesPropertyValue();
        cenesPropertyValue.cenesPropertyId = cenesPropertyValueDict.value(forKey: "cenesPropertyId") as! Int32?
        cenesPropertyValue.cenesPropertyValueId = cenesPropertyValueDict.value(forKey: "cenesPropertyValueId") as! Int32?
        cenesPropertyValue.entityId = cenesPropertyValueDict.value(forKey: "entityId") as! Int32?
        cenesPropertyValue.value = cenesPropertyValueDict.value(forKey: "value") as! String?

        return cenesPropertyValue;
    }
    
    func loadCenesProperties(cenesPropertiesArray: NSArray) -> [CenesProperty] {
        
        var cenesProperties = [CenesProperty]();
        for cenesProperty in  cenesPropertiesArray {
            let cenesPropertyDict = cenesProperty as! NSDictionary;
            cenesProperties.append(loadCenesProperty(cenesPropertyDict: cenesPropertyDict));
        }
        return cenesProperties;
    }
}

class CenesPropertyValue {
    
    var cenesPropertyValueId: Int32!;
    var entityId: Int32!;
    var value: String!
    var cenesPropertyId: Int32!
}
