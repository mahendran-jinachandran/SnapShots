//
//  PostDaoImplementation.swift
//  SnapShots
//
//  Created by mahendran-14703 on 09/11/22.
//

import Foundation

class PostDaoImplementation: PostDao {
    
    private let sqliteDatabase: DatabaseProtocol
    private let friendsDaoImplementation: FriendsDao
    init(sqliteDatabase: DatabaseProtocol,friendsDaoImplementation: FriendsDao) {
        self.sqliteDatabase = sqliteDatabase
        self.friendsDaoImplementation = friendsDaoImplementation
    }
    
    func uploadPost(postID: Int,caption: String,userID: Int) -> Bool {
        let uploadPostQuery = """
        INSERT INTO Post
        VALUES (
            \(postID),
            \(1),
            '\(caption)',
            \(userID)
        )
        """
        
        return sqliteDatabase.execute(query: uploadPostQuery)
    }
    
    func createNewPostID(userID: Int) -> Int {
        let getExistingPostIDQuery = """
        SELECT Post_id FROM POST WHERE User_id = \(userID) ORDER BY Post_id DESC LIMIT 1;
        """
        
        let existingPostIDs = sqliteDatabase.retrievingQuery(query: getExistingPostIDQuery)
        
        var newPostID = 0
        if existingPostIDs.isEmpty {
            newPostID = 1
        } else {
            for(_,post) in existingPostIDs {
                newPostID = Int(post[0])! + 1
            }
        }
        
        return newPostID
    }
    
    func getAllPosts(userID: Int) -> [(postID: Int, postDetails: Post)] {
        let getAllPostQuery = """
        SELECT Post_id,Photo,Caption FROM POST
        WHERE User_id = \(userID);
        """
        
        var allPosts: [(Int, Post)] = []
        for (_,post) in sqliteDatabase.retrievingQuery(query: getAllPostQuery) {
            allPosts.append(( Int(post[0])!,
                                  Post(postID: Int(post[0])!,
                                       photo: post[1] == "1" ? true: false,
                                       caption: post[2]))   )
        }
        
        return allPosts
    }
    
    func getAllFriendPosts(userID: Int) -> [(userId: Int,userName: String,post: Post)] {
        
        var myFriendIDs: Set<Int> = friendsDaoImplementation.getIDsOfFriends(userID: userID)
        myFriendIDs.insert(userID)
                
        var feedPosts: [(userId: Int,userName: String,post: Post)] = []
        
        for friendID in myFriendIDs {
            
            let getAllFriendsPostQuery = """
            SELECT
                User.User_id,
                Username,
                Post_id,
                Post.Photo,
                Caption
            FROM
                User
                INNER JOIN Post ON Post.User_id = \(friendID) AND
                User.User_id = Post.User_id;

            """
            
            
            for (_,friend) in sqliteDatabase.retrievingQuery(query: getAllFriendsPostQuery){
                feedPosts.append((Int(friend[0])!,friend[1], Post(postID: Int(friend[2])!, photo: friend[3] == "1" ? true: false, caption: friend[4])))
            }
        }
        
        return feedPosts
    }
    
    func editCaptionInPost(caption: String,userID: Int,postID: Int) -> Bool {
        let updateCaptionInPostQuery = """
        UPDATE Post SET Caption = '\(caption)'
        WHERE User_id = \(userID) AND Post_id = \(postID);
        """
        
        return sqliteDatabase.execute(query: updateCaptionInPostQuery)
    }
    
    func deletePost(userID: Int,postID: Int) -> Bool {
        let deletePostQuery = """
        DELETE FROM Post
        WHERE User_id = \(userID) AND Post_id = \(postID);
        """
        
        return sqliteDatabase.execute(query: deletePostQuery)
    }
}

