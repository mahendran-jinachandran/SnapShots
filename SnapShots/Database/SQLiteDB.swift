//
//  SQLiteDB.swift
//  SnapShots
//
//  Created by mahendran-14703 on 09/11/22.
//

import Foundation
import SQLite3

class SQLiteDatabase: DatabaseProtocol {
    private var dbPointer: OpaquePointer?
    
    static var shared: SQLiteDatabase = {
        return SQLiteDatabase()
    }()
    
    func getDatabaseReady() {
        openDBConnection()
        createEntireTable()
        onPragmaKeys()
    }
    
    private func isDBReferenceExist() -> Bool {
        return dbPointer != nil
    }
    
    private func openDBConnection(){

        if isDBReferenceExist() {
            return
        }

        let DBPath = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("Snapshots.sqlite").relativePath
        
        print(DBPath)

        if sqlite3_open(DBPath, &dbPointer) == SQLITE_OK {
            print("Database connected")
        } else {
            print("Not connected")
        }
    }
    
    func closeConnection() {
        sqlite3_close(dbPointer)
        dbPointer = nil
        print("SQLITE Database connection closed")
    }
            
    private func onPragmaKeys() {
        var statement: OpaquePointer?
        
        if !isDBReferenceExist(){
            print("Error in connecting Database.Connecting...")
            getDatabaseReady()
        } 
        
        if sqlite3_prepare_v2(dbPointer, "PRAGMA foreign_keys = ON", -1, &statement, nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(dbPointer))
            print("error building statement: \(err)")
        }
        sqlite3_finalize(statement)
    }
    
    private func createTable(createTableString: String) {
        let createTableStatement = prepareStatement(sqlQuery: createTableString)
        sqlite3_step(createTableStatement)
        sqlite3_finalize(createTableStatement)
    }
    
    private func createEntireTable() {
        let createUserTable = """
        CREATE TABLE IF NOT EXISTS User(
            User_id INTEGER PRIMARY KEY AUTOINCREMENT,
            Username CHAR(255) NOT NULL,
            Password CHAR(255) NOT NULL,
            Phone CHAR(255) NOT NULL,
            Gender CHAR(255),
            Age CHAR(255),
            Mail CHAR(255),
            Photo CHAR(255) NOT NULL,
            Bio CHAR(255),
            Account_Created TEXT
            );
        """

        let createPostTable = """
        CREATE TABLE IF NOT EXISTS Post(
            Post_id Int NOT NULL,
            Photo CHAR(255) NOT NULL,
            Caption CHAR(255),
            User_id INT NOT NULL,
            Created_time TEXT,
            IsLikesHidden INT,
            IsCommentsHidden INT,
            PRIMARY KEY(Post_id,User_id),
            FOREIGN KEY(User_id) REFERENCES User(User_id) ON DELETE CASCADE
            );
        """

        let createFriendRequestTable = """
        CREATE TABLE IF NOT EXISTS FriendRequest (
            User_id INT,
            Requested_id INT,
            FOREIGN KEY (User_id) REFERENCES User(User_id) ON DELETE CASCADE,
            FOREIGN KEY (Requested_id) REFERENCES User(User_id) ON DELETE CASCADE
            );
        """

        let createFriendsTable = """
        CREATE TABLE IF NOT EXISTS Friends (
                User_id INT,
                Friends_id INT,
                FOREIGN KEY (User_id) REFERENCES User(User_id) ON DELETE CASCADE,
                FOREIGN KEY (Friends_id) REFERENCES User(User_id) ON DELETE CASCADE
            );
        """

        let createLikesTable = """
        CREATE TABLE IF NOT EXISTS Likes (
                User_id INT,
                Post_id INT,
                LikedUser_id INT,
                Liked_time TEXT,
                UNIQUE(User_id,Post_id),
                FOREIGN KEY (User_id) REFERENCES User(User_id) ON DELETE CASCADE,
                FOREIGN KEY (LikedUser_id) REFERENCES User(User_id) ON DELETE CASCADE,
                FOREIGN KEY (Post_id,User_id) REFERENCES Post(Post_id,User_id) ON DELETE CASCADE
            );
        """

        let createCommentsTable = """
        CREATE TABLE IF NOT EXISTS Comments (
                CommentID Int,
                User_id INT,
                Post_id INT,
                Comment CHAR(255),
                CommentUser_id INT,
                Commented_time TEXT,
                FOREIGN KEY (User_id) REFERENCES User(User_id) ON DELETE CASCADE,
                FOREIGN KEY (CommentUser_id) REFERENCES User(User_id) ON DELETE CASCADE,
                FOREIGN KEY (Post_id,User_id) REFERENCES Post(Post_id,User_id) ON DELETE CASCADE
            );
        """
        
        let blockedUsersTable = """
        CREATE TABLE IF NOT EXISTS BlockedUsers (
                User_id INT,
                BlockedUser_id INT,
                UNIQUE(User_id,BlockedUser_id)
        );
        """
        
        createTable(createTableString: createUserTable)
        createTable(createTableString: createPostTable)
        createTable(createTableString: createFriendsTable)
        createTable(createTableString: createLikesTable)
        createTable(createTableString: createCommentsTable)
        createTable(createTableString: createFriendRequestTable)
        createTable(createTableString: blockedUsersTable)
    }
    
    
    private func prepareStatement(sqlQuery: String) -> OpaquePointer? {
        var statement: OpaquePointer?
        
        if !isDBReferenceExist(){
            print("Error in connecting Database.Connecting...")
            getDatabaseReady()
        }
        
        if sqlite3_prepare_v2(dbPointer, sqlQuery, -1, &statement, nil) == SQLITE_OK {
            return statement
        }
        return nil
    }
        
    func execute(query: String) -> Bool {
        let insertTableStatement = prepareStatement(sqlQuery: query)
        
        defer {
            sqlite3_finalize(insertTableStatement)
        }

        if sqlite3_step(insertTableStatement) == SQLITE_DONE {
            return true
        }

        return false
    }
    
    func booleanQuery(query: String) -> Bool {
        let selectTableStatement = prepareStatement(sqlQuery: query)
        
        defer {
            sqlite3_finalize(selectTableStatement)
        }
        
        if sqlite3_step(selectTableStatement) == SQLITE_ROW {
            return true
        }
        
        return false
    }
    
    func retrievingQuery(query: String) -> [Int: [String]] {
        guard let readTableStatement = prepareStatement(sqlQuery: query) else {
            return [:]
        }
        
        defer {
            sqlite3_finalize(readTableStatement)
        }
                  
        var data: [Int: [String]] = [:]
        let columnCount = Int(sqlite3_column_count(readTableStatement))
        var rowCount = 1
            
        while sqlite3_step(readTableStatement) == SQLITE_ROW {
            var columnData: [String] = []
            for i in 0 ..< columnCount {
                columnData.append(
                    (sqlite3_column_type(readTableStatement, Int32(i)) != Int(exactly: SQLITE_NULL)!) ?
                        String(cString: sqlite3_column_text(readTableStatement, Int32(i)))
                        : "-1"
                )
            }
            
            data[rowCount] = columnData
            rowCount = rowCount + 1
        }
        
        return data
    }
}

