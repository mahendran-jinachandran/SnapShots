//
//  UserDaoImplementation.swift
//  SnapShots
//
//  Created by mahendran-14703 on 09/11/22.
//

import Foundation
import SQLite3

class UserDaoImplementation: UserDao {

    private let TABLE_NAME = "User"
    private let USER_ID = "User_id"
    private let USERNAME = "Username"
    private let PASSWORD = "Password"
    private let PHONE = "Phone"
    private let GENDER = "Gender"
    private let AGE = "Age"
    private let MAIL = "Mail"
    private let PHOTO = "Photo"
    private let BIO = "Bio"
    private let CREATED = "Account_Created"
    
    private let sqliteDatabase: DatabaseProtocol
    init(sqliteDatabase: DatabaseProtocol) {
        self.sqliteDatabase = sqliteDatabase
    }
    
    func isPhoneNumberAlreadyExist(phoneNumber: String) -> Bool {
     
        let isPhoneNumberExistQuery =  """
        SELECT * FROM \(TABLE_NAME)
        WHERE \(PHONE) = '\(phoneNumber)';
        """
        
        return !sqliteDatabase.retrievingQuery(query: isPhoneNumberExistQuery).isEmpty
    }
    
    func isUsernameAlreadyExist(username: String) -> Bool {
        let isUsernamePresentQuery = """
        SELECT * FROM \(TABLE_NAME)
        WHERE \(USERNAME) = '\(username)';
        """
        
        return !sqliteDatabase.retrievingQuery(query: isUsernamePresentQuery).isEmpty
    }
    
    func getUserDetails(phoneNumber: String,password: String) -> User? {
        let getUserQuery = """
        SELECT * FROM \(TABLE_NAME)
        WHERE \(PHONE) = '\(phoneNumber)'
        AND \(PASSWORD) = '\(password)'
        """
        return UserInstance.getUserInstance(dbQuery: getUserQuery)
    }
    
    func getUserDetails(phoneNumber: String) -> User? {
        let checkPhoneNumberExistQuery = """
        SELECT * FROM \(TABLE_NAME)
        WHERE \(PHONE) = '\(phoneNumber)'
        """
        return UserInstance.getUserInstance(dbQuery: checkPhoneNumberExistQuery)
    }
    
    func getUserDetails(userID: Int) -> User? {
        let getParticularUserQuery = """
        SELECT * FROM \(TABLE_NAME)
        WHERE \(USER_ID) = \(userID)
        """
        
        return UserInstance.getUserInstance(dbQuery: getParticularUserQuery)
    }
    
    func getAllUsers() -> [User] {
        let getAllUsers = "SELECT * FROM \(TABLE_NAME)"
        var allUsers: [User] = []
        
        for user in sqliteDatabase.retrievingQuery(query: getAllUsers) {
            allUsers.append(
                getUserDetails(userID: Int(user.value[0])!)!
            )
        }
        return allUsers
    }
    
    func getUserID(phoneNumber: String,password: String) -> Int? {
        let getUserQuery = """
        SELECT \(USER_ID) FROM \(TABLE_NAME)
        WHERE \(PHONE) = '\(phoneNumber)'
        AND \(PASSWORD) = '\(password)'
        """
        
        var userData = sqliteDatabase.retrievingQuery(query: getUserQuery)
        
        if userData.isEmpty { return nil }
    
        return Int(userData[1]!.removeFirst())
    }
    
    func createNewUser(userName: String, password: String, phoneNumber: String) -> Bool {
        let insertUserTableQuery = """
        INSERT INTO \(TABLE_NAME) (\(USERNAME),\(PASSWORD),\(PHONE),\(PHOTO),\(CREATED))
        VALUES
        ('\(userName)','\(password)','\(phoneNumber)','Default', '\(AppUtility.getCurrentTime())');
        """
        
        return sqliteDatabase.execute(query: insertUserTableQuery)
    }
    
    func completeUserProfile(userID: Int, photo: String,gender: Gender,mailID: String,age: String) -> Bool {
        
        let updateUserProfileQuery = """
        UPDATE \(TABLE_NAME)
        SET \(PHOTO) = \(photo),
            \(GENDER) = '\(gender)',
            \(MAIL) = '\(mailID)',
            \(AGE) = '\(age)'
        WHERE \(USER_ID) = \(userID)
        """
        
        return sqliteDatabase.execute(query: updateUserProfileQuery)
        
    }
    
    func updatePassword(password: String,phoneNumber: String) -> Bool {
        let updatePasswordQuery = """
        UPDATE \(TABLE_NAME)
        SET \(PASSWORD) = '\(password)'
        WHERE \(PHONE) = '\(phoneNumber)';
        """

        return sqliteDatabase.execute(query: updatePasswordQuery)
    }
    
    func updatePassword(password: String,userID: Int) -> Bool {
        let updatePasswordQuery = """
        UPDATE \(TABLE_NAME)
        SET \(PASSWORD) = '\(password)'
        WHERE \(USER_ID) = \(userID);
        """

        return sqliteDatabase.execute(query: updatePasswordQuery)
    }

    func updateUsername(username: String,userID: Int) -> Bool {
        let updateUsernameQuery = """
        UPDATE \(TABLE_NAME)
        SET \(USERNAME) = '\(username)'
        WHERE \(USER_ID) = \(userID);
        """
        
        return sqliteDatabase.execute(query: updateUsernameQuery)
    }
    
    func updatePhoneNumber(phoneNumber: String,userID: Int) -> Bool {
        let updatePhoneNumberQuery = """
        UPDATE \(TABLE_NAME)
        SET \(PHONE) = '\(phoneNumber)'
        WHERE \(USER_ID) = \(userID);
        """
        
        return sqliteDatabase.execute(query: updatePhoneNumberQuery)
    }
    
    func updateMail(mailID: String,userID: Int) -> Bool {
        let updateMailQuery = """
        UPDATE \(TABLE_NAME)
        SET \(MAIL) = '\(mailID)'
        WHERE \(USER_ID) = \(userID);
        """
        
        return sqliteDatabase.execute(query: updateMailQuery)
    }
    
    func updateGender(gender: String,userID: Int) -> Bool {
        let updateGenderQuery = """
        UPDATE \(TABLE_NAME)
        SET \(GENDER) = '\(gender)'
        WHERE \(USER_ID) = \(userID);
        """
        
        return sqliteDatabase.execute(query: updateGenderQuery)
    }
    
    func updateAge(age: String,userID: Int) -> Bool {
        let updateAgeQuery = """
        UPDATE \(TABLE_NAME)
        SET \(AGE) = '\(age)'
        WHERE \(USER_ID) = \(userID);
        """
        
        return sqliteDatabase.execute(query: updateAgeQuery)
    }
    
    func updatePhoto(photo: String,userID: Int) -> Bool {
        let updatePhotoQuery = """
        UPDATE \(TABLE_NAME)
        SET \(PHOTO) = '\(photo)'
        WHERE \(USER_ID) = \(userID);
        """
        
        return sqliteDatabase.execute(query: updatePhotoQuery)
    }
    
    func updateBio(profileBio: String,userID: Int) -> Bool {
        let updateProfileBioQuery = """
        UPDATE \(TABLE_NAME)
        SET \(BIO) = '\(profileBio)'
        WHERE \(USER_ID) = \(userID);
        """
        
        return sqliteDatabase.execute(query: updateProfileBioQuery)
    }

    func getUserBasedOnSearch(userName: String) -> [(userID: Int, userName: String)] {
        let searchUserQuery = """
        SELECT \(USER_ID),\(USERNAME)
        FROM \(TABLE_NAME)
        Where \(USERNAME)
        LIKE '%\(userName)%';
        """
        
        var searchedUsersDetails: [(userID: Int, userName: String)] = []
        for (_,data) in sqliteDatabase.retrievingQuery(query: searchUserQuery) {
            searchedUsersDetails.append( (Int(data[0])!,data[1] ) )
        }
        
        return searchedUsersDetails
    }

    func isPhotoPresent(userID: Int) -> Bool {
        let isPhotoPresentQuery = """
        SELECT \(PHOTO)
        FROM \(TABLE_NAME)
        WHERE \(USER_ID) = \(userID);
        """
        
        var data = sqliteDatabase.retrievingQuery(query: isPhotoPresentQuery)
        return data[1]?.removeFirst() == "1" ? true : false
    }
    
    func getUsername(userID: Int) -> String {
        let getMyFriendsDetailsQuery = """
        SELECT \(USERNAME)
        FROM \(TABLE_NAME)
        WHERE \(USER_ID) = \(userID);
        """
        
        var username = sqliteDatabase.retrievingQuery(query: getMyFriendsDetailsQuery)
        return username[1]!.removeFirst()
    }
    
    func getBio(userID: Int) -> String {
        let getMyFriendsDetailsQuery = """
        SELECT \(BIO)
        FROM \(TABLE_NAME)
        WHERE \(USER_ID) = \(userID);
        """
        
        var bio = sqliteDatabase.retrievingQuery(query: getMyFriendsDetailsQuery)
        return bio[1]!.removeFirst()
    }
    
    func deleteAccount(userID: Int) -> Bool {
        let deleteUserQuery = """
        DELETE FROM \(TABLE_NAME)
        WHERE \(USER_ID) = \(userID)
        """
        
        return sqliteDatabase.execute(query: deleteUserQuery)

    }
}




