//
//  UserInstance.swift
//  SnapShots
//
//  Created by mahendran-14703 on 09/11/22.
//

import Foundation

struct UserInstance {
    static func getUserInstance(dbQuery: String) -> User? {
        let DBInstance = SQLiteDatabase.shared
        let userData = DBInstance.retrievingQuery(query: dbQuery)
        
        if userData.isEmpty {
            return nil
        }
        
        var user: User?
        for (_,data) in userData {
            user = User(
                userId: Int(data[0])!,
                userName: data[1],
                password: data[2],
                phoneNumber: data[3],
                gender: data[4] == "-1" ? .preferNotSay : data[4] == Constants.MALE ? .male : .female,
                age: data[5],
                mail: data[6],
                photo: data[7],
                bio: data[8],
                accountCreatedDate: data[9]
            )
        }
        
        let getAllPostQuery = """
        SELECT Post_id,Photo,Caption,Created_time,isArchived FROM POST
        WHERE User_id = \(user!.userID);
        """
    
        var allPosts: [Int:Post] = [:]
        for (_,post) in DBInstance.retrievingQuery(query: getAllPostQuery) {
            allPosts[Int(post[0])!] = Post(postID: Int(post[0])!,
                                           photo: post[1],
                                        caption: post[2],
                                        postCreatedDate: post[3],
                                           isArchived: post[4] == "1" ? true:false)
            
        }
        
        user?.profile.posts = allPosts
        
        
        let getFriendsQuery = """
        SELECT Friends_id FROM Friends WHERE User_id = \(user!.userID)
        """
        
        for (_,userID) in DBInstance.retrievingQuery(query: getFriendsQuery) {
            user?.profile.friendsList.insert(Int(userID[0])!)
        }
        
        return user
    }
}
