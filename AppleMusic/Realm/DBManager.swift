//
//  DBManager.swift
//  AppleMusic
//
//  Created by TOOK on 18.12.2019.
//  Copyright © 2019 Vitaly. All rights reserved.
//

import UIKit
import RealmSwift

class DBManager {
    
    var database: Realm
    static let sharedInstance = DBManager()
    
    private init() {
        database = try! Realm()
    }
    
    func getDataFromSiteList() -> Results<TrackModel> {
        
        let results: Results<TrackModel> = database.objects(TrackModel.self)
        //.sorted(byKeyPath: "siteName", ascending: true)
        return results
    }
    
    func addDataSiteList(object: TrackModel) {
        do {
            try database.write {
                database.add(object, update: .all)
            }
        }
        catch {
            print ("error additing data to site list")
        }
    }
    
    func deleteAllDatabase()  {
        
        do {
            try database.write {
                database.deleteAll()
            }
        }
        catch {
            print ("error to delete all database")
        }
    }
    
    func deleteSiteFromDb(object: TrackModel) {
        
        do {
            try database.write {
                database.delete(object)
            }
        }
        catch {
            print ("error to delete site from database")
        }
    }
    
}

