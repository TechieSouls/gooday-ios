//
//  SqliteDbStore.swift
//  Cenes
//
//  Created by Cenes_Dev on 21/11/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import Foundation
import SQLite3

class SqliteDbStore {

    // Get the URL to db store file
    let dbURL: URL
    // The database pointer.
    var db: OpaquePointer?
    // Prepared statement https://www.sqlite.org/c3ref/stmt.html to insert an event into Table.
    // we use prepared statements for efficiency and safe guard against sql injection.
    var insertEntryStmt: OpaquePointer?
    var readEntryStmt: OpaquePointer?
    var updateEntryStmt: OpaquePointer?
    var deleteEntryStmt: OpaquePointer?

    init() {
            do {
                do {
                    dbURL = try FileManager.default
                        .url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                        .appendingPathComponent("integration.db")
                    print("URL: %s", dbURL.absoluteString)
                } catch {
                    //TODO: Just logging the error and returning empty path URL here. Handle the error gracefully after logging
                    print("Some error occurred. Returning empty path.")
                    dbURL = URL(fileURLWithPath: "")
                    return
                }
                
                try openDB()
                try createEventTable()
                } catch {
                    //TODO: Handle the error gracefully after logging
                    print("Some error occurred. Returning.")
                    return
                }
        }
        
        // Command: sqlite3_open(dbURL.path, &db)
        // Open the DB at the given path. If file does not exists, it will create one for you
        func openDB() throws {
            if sqlite3_open(dbURL.path, &db) != SQLITE_OK { // error mostly because of corrupt database
                print("error opening database at %s", dbURL.absoluteString)
    //            deleteDB(dbURL: dbURL)
                throw SqliteError(message: "error opening database \(dbURL.absoluteString)")
            }
        }
        
        // Code to delete a db file. Useful to invoke in case of a corrupt DB and re-create another
        func deleteDB(dbURL: URL) {
            print("removing db")
            do {
                try FileManager.default.removeItem(at: dbURL)
            } catch {
                print("exception while removing db %s", error.localizedDescription)
            }
        }
        
        func createEventTable() throws {
            // create the tables if they dont exist.
            
            // create the table to store the entries.
            // ID | Name | Employee Id | Designation
            let ret =  sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Records (event_id INTEGER, title TEXT, description TEXT, event_picture TEXT, start_time INTEGER, end_time INTEGER, location TEXT, latitude TEXT, longitude TEXT, created_by_id INTEGER, source TEXT, schedule_as TEXT, thumbnail TEXT)", nil, nil, nil)
            if (ret != SQLITE_OK) { // corrupt database.
                logDbErr("Error creating db table - Records")
                throw SqliteError(message: "unable to create table Records")
            }
            
        }
        
        func logDbErr(_ msg: String) {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR %s : %s", msg, errmsg)
        }
    }

    // Indicates an exception during a SQLite Operation.
    class SqliteError : Error {
        var message = ""
        var error = SQLITE_ERROR
        init(message: String = "") {
            self.message = message
        }
        init(error: Int32) {
            self.error = error
        }
    }
