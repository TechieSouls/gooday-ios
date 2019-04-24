//
//  PersistanceManager.swift
//  Deploy
//
//  Created by Cenes_Dev on 13/04/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import Foundation
import CoreData;

class PersistanceManager {
    
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate;
        let context = appDelegate.persistentContainer.viewContext
        return context;
    }
}
