//
//  DatabaseAccess.swift
//  AKTabbar-Database
//
//  Created by macmini3 on 16/12/19.
//  Copyright © 2019 Gatisofttech. All rights reserved.
//

import UIKit
import SQLite3

class DatabaseAccess: NSObject {
    
    var dabasePath: String?
    
    override init() {
        super.init()
        
        if let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
            
            if !FileManager.default.fileExists(atPath: "\(documentDirectory)/Hello World.db") {
                
                do {
                    try FileManager.default.copyItem(atPath: "\(Bundle.main.resourcePath!)/Hello World.db", toPath: "\(documentDirectory)/Hello World.db")
                    dabasePath = "\(documentDirectory)/Hello World.db"
                    print("DB File Copied At Path:-\n","\(documentDirectory)/Hello World.db")
                    return
                }
                catch {
                    print("Error While Copying DB to Document Directory :-\n",error)
                }
            }
            else {
                dabasePath = "\(documentDirectory)/Hello World.db"
                print("DB File Already Exist At Path:-\n","\(documentDirectory)/Hello World.db")
                return
            }
        }
        else {
            print("Document Directory Exist")
            return
        }
    }
    
    func InsertEventData(_ date: String, _ name: String, _ desc: String) -> Bool {
        
        var opaquePointerO: OpaquePointer? = nil
        var success = Bool()
        
        if sqlite3_open(dabasePath, &opaquePointerO) == SQLITE_OK {
            
            let sqlQuery = "INSERT INTO KIAN (EVENTDATE,EVENTNAME,EVENTDESCRIPTION) VALUES (\"\(date)\",\"\(name)\",\"\(desc)\")"
            
            var opaquePointerI: OpaquePointer? = nil
            if sqlite3_prepare_v2(opaquePointerO, sqlQuery, -1, &opaquePointerI, nil) == SQLITE_OK {
                while sqlite3_step(opaquePointerI) == SQLITE_ROW {
                }
                sqlite3_finalize(opaquePointerI)
                success = true
            }
            else {
                success = false
            }
            sqlite3_close(opaquePointerO)
        }
        else {
            success = false
        }
        return success
    }
    
    func GetEventsData(_ date: String) -> [EventsModel] {
        
        var userData = [EventsModel]()
        
        var opaquePointerO: OpaquePointer? = nil
        
        if sqlite3_open(dabasePath, &opaquePointerO) == SQLITE_OK {
            
            let sqlQuery = "SELECT EVENTDATE,EVENTNAME,EVENTDESCRIPTION FROM KIAN WHERE EVENTDATE = \"\(date)\""
            
            var opaquePointerI: OpaquePointer? = nil
            
            if sqlite3_prepare_v2(opaquePointerO, sqlQuery, -1, &opaquePointerI, nil) == SQLITE_OK {
                while sqlite3_step(opaquePointerI) == SQLITE_ROW {
                    let tempData = EventsModel()
                    tempData.eventDate = String(cString:sqlite3_column_text(opaquePointerI, 0))
                    tempData.eventName = String(cString:sqlite3_column_text(opaquePointerI, 1))
                    tempData.eventDesc = String(cString:sqlite3_column_text(opaquePointerI, 2))
                    userData.append(tempData)
                }
                sqlite3_finalize(opaquePointerI)
            }
            sqlite3_close(opaquePointerO)
        }
        return userData
    }
    
    
    func EventExists(_ date: String) -> Bool {
        
        var opaquePointerO: OpaquePointer? = nil
        var success = Bool()
        
        if sqlite3_open(dabasePath, &opaquePointerO) == SQLITE_OK {
            
            let sqlQuery = "SELECT * FROM KIAN WHERE EVENTDATE = \"\(date)\""
            
            var opaquePointerI: OpaquePointer? = nil
            
            if sqlite3_prepare_v2(opaquePointerO, sqlQuery, -1, &opaquePointerI, nil) == SQLITE_OK {
                
                while sqlite3_step(opaquePointerI) == SQLITE_ROW {
                    success = !String(cString:sqlite3_column_text(opaquePointerI, 1)).isEmpty
                }
                sqlite3_finalize(opaquePointerI)
            }
            else {
                success = false
            }
            sqlite3_close(opaquePointerO)
        }
        else {
            success = false
        }
        return success
    }
}
