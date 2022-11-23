//
//  UserDaoImplementation.swift
//  SnapShots
//
//  Created by mahendran-14703 on 09/11/22.
//

import Foundation

class UserDaoImplementation: UserDao {
    
    private let sqliteDatabase: DatabaseProtocol
    init(sqliteDatabase: DatabaseProtocol) {
        self.sqliteDatabase = sqliteDatabase
    }
    
    func isPhoneNumberAlreadyExist(phoneNumber: String) -> Bool {
        let isPhoneNumberExistQuery = "SELECT * FROM User WHERE Phone = '\(phoneNumber)';"
        return !sqliteDatabase.retrievingQuery(query: isPhoneNumberExistQuery).isEmpty
    }
    
    func isUsernameAlreadyExist(username: String) -> Bool {
        let isUsernamePresentQuery = """
        SELECT * FROM User WHERE Username = '\(username)';
        """
        
        return !sqliteDatabase.retrievingQuery(query: isUsernamePresentQuery).isEmpty
    }
    
    func getUserDetails(phoneNumber: String,password: String) -> User? {
        let getUserQuery = "SELECT * FROM User WHERE Phone = '\(phoneNumber)' AND Password = '\(password)'"
        return UserInstance.getUserInstance(dbQuery: getUserQuery)
    }
    
    func getUserDetails(phoneNumber: String) -> User? {
        let checkPhoneNumberExistQuery = "SELECT * FROM User WHERE Phone = '\(phoneNumber)'"
        return UserInstance.getUserInstance(dbQuery: checkPhoneNumberExistQuery)
    }
    
    func getUserDetails(userID: Int) -> User? {
        let getParticularUserQuery = "SELECT * FROM User WHERE User_id = \(userID)"
        return UserInstance.getUserInstance(dbQuery: getParticularUserQuery)
    }
    
    func getUserID(phoneNumber: String,password: String) -> Int? {
        let getUserQuery = "SELECT User_id FROM User WHERE Phone = '\(phoneNumber)' AND Password = '\(password)'"
        var userData = sqliteDatabase.retrievingQuery(query: getUserQuery)
        
        if userData.isEmpty { return nil }
    
        return Int(userData[1]!.removeFirst())
    }
    
    func createNewUser(userName: String, password: String, phoneNumber: String) -> Bool {
        let insertUserTableQuery = """
        INSERT INTO User (Username,Password,Phone)
        VALUES
        ('\(userName)','\(password)','\(phoneNumber)');
        """
        
        return sqliteDatabase.execute(query: insertUserTableQuery)
    }
    
    func completeUserProfile(userID: Int, photo: Int,gender: Gender,mailID: String,age: Int) -> Bool {
        let updateUserProfileQuery = """
        UPDATE User SET Photo = \(photo),Gender = '\(gender)',Mail = '\(mailID)',Age = \(age)
        WHERE User_id = \(userID)
        """
        print(updateUserProfileQuery)
        
        return sqliteDatabase.execute(query: updateUserProfileQuery)
        
    }
    
    func updatePassword(password: String,userID: Int) -> Bool {
        let updatePasswordQuery = """
        UPDATE User SET Password = '\(password)' WHERE User_id = \(userID);
        """

        return sqliteDatabase.execute(query: updatePasswordQuery)
    }

    func updateUsername(username: String,userID: Int) -> Bool {
        let updateUsernameQuery = """
        UPDATE User SET Username = '\(username)' WHERE User_id = \(userID);
        """
        
        return sqliteDatabase.execute(query: updateUsernameQuery)
    }
    
    func updatePhoneNumber(phoneNumber: String,userID: Int) -> Bool {
        let updatePhoneNumberQuery = """
        UPDATE User SET Phone = '\(phoneNumber)' WHERE User_id = \(userID);
        """
        
        return sqliteDatabase.execute(query: updatePhoneNumberQuery)
    }
    
    func updateMail(mailID: String,userID: Int) -> Bool {
        let updateMailQuery = """
        UPDATE User SET Mail = '\(mailID)' WHERE User_id = \(userID);
        """
        
        return sqliteDatabase.execute(query: updateMailQuery)
    }
    
    func updateGender(gender: String,userID: Int) -> Bool {
        let updateGenderQuery = """
        UPDATE User SET Gender = '\(gender)' WHERE User_id = \(userID);
        """
        
        return sqliteDatabase.execute(query: updateGenderQuery)
    }
    
    func updateAge(age: Int,userID: Int) -> Bool {
        let updateAgeQuery = """
        UPDATE User SET Age = \(age) WHERE User_id = \(userID);
        """
        
        return sqliteDatabase.execute(query: updateAgeQuery)
    }
    
    func updatePhoto(photo: Int,userID: Int) -> Bool {
        let updatePhotoQuery = """
        UPDATE User SET Photo = '\(photo)' WHERE User_id = \(userID);
        """
        
        return sqliteDatabase.execute(query: updatePhotoQuery)
    }
    
    func updateBio(profileBio: String,userID: Int) -> Bool {
        let updateProfileBioQuery = """
        UPDATE User SET Bio = '\(profileBio)' WHERE User_id = \(userID);
        """
        
        return sqliteDatabase.execute(query: updateProfileBioQuery)
    }

    func getUserBasedOnSearch(userName: String) -> [(userID: Int, userName: String)] {
        let searchUserQuery = "SELECT User_id,Username FROM User Where Username LIKE '%\(userName)%'; "
        let searchedUsers = sqliteDatabase.retrievingQuery(query: searchUserQuery)
        
        var searchedUsersDetails: [(userID: Int, userName: String)] = []
        for (_,data) in searchedUsers {
            searchedUsersDetails.append( (Int(data[0])!,data[1] ) )
        }
        
        return searchedUsersDetails
    }

    func isPhotoPresent(userID: Int) -> Bool {
        let isPhotoPresentQuery = """
        SELECT Photo FROM User WHERE User_id = \(userID);
        """
        
        var data = sqliteDatabase.retrievingQuery(query: isPhotoPresentQuery)
        return data[1]?.removeFirst() == "1" ? true : false
    }
    
    func getUsername(userID: Int) -> String {
        let getMyFriendsDetailsQuery = """
        SELECT Username FROM User WHERE User_id = \(userID);
        """
        
        var username = sqliteDatabase.retrievingQuery(query: getMyFriendsDetailsQuery)
        return username[1]!.removeFirst()
    }
    
    func getBio(userID: Int) -> String {
        let getMyFriendsDetailsQuery = """
        SELECT Bio FROM User WHERE User_id = \(userID);
        """
        
        var bio = sqliteDatabase.retrievingQuery(query: getMyFriendsDetailsQuery)
        return bio[1]!.removeFirst()
    }
    
    func deleteAccount(userID: Int) -> Bool {
        let deleteUserQuery = "DELETE FROM User WHERE User_Id = \(userID)"
        return sqliteDatabase.execute(query: deleteUserQuery)

    }
}




