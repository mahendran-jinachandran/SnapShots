//
//  AppUtility.swift
//  SnapShots
//
//  Created by mahendran-14703 on 08/11/22.
//

import UIKit



class AppUtility {
    
    static private var userDaoImp: UserDao = UserDaoImplementation(sqliteDatabase: SQLiteDatabase.shared)

    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }
    
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    static func isValidUsername(username: String) -> Result<Bool,UsernameError> {
        if username.isEmpty || username.trimmingCharacters(in: .whitespaces).count == 0 {
            return .failure(.cannotBeEmpty)
        } else if username.count < Constants.miniumUsernameLength || username.count > Constants.maximumUsernameLength {
            return .failure(.invalidNumberOfCharacters)
        }
        
        return .success(true)
    }

    static func isValidPhoneNumber(phoneNumber: String) -> Result<Bool,PhoneNumberError> {
        
        if phoneNumber.isEmpty {
            return .failure(.cannotBeEmpty)
        } else if phoneNumber.count < Constants.minimumPhoneNumberLength || phoneNumber.count > Constants.maximumPhoneNumberLength {
            return .failure(.invalidFormat)
        }
        return .success(true)
    }
    
    static func textLimit(existingText: String?,newText: String,limit: Int) -> Bool {
        let text = existingText ?? ""
        return text.count + newText.count <= limit
    }
    
    static func getProfilePhotoSavingFormat(userID: Int) -> String {
        return "\(Constants.dpSavingFormat)\(userID)"
    }
    
    static func getDisplayPicture(userID: Int) -> UIImage {
        var userDP: UIImage!
        
        if let displayPicture = UIImage().loadImageFromDiskWith(fileName: AppUtility.getProfilePhotoSavingFormat(userID: userID)) {
            userDP = displayPicture
        } else {
            userDP = UIImage().loadImageFromDiskWith(fileName: Constants.noDPSavingFormat)
        }
        
        return userDP
    }
    
    static func getDisplayPicture(fileName: String) -> UIImage {
        
        guard let image = UIImage().loadImageFromDiskWith(fileName: fileName) else {
            return UIImage().loadImageFromDiskWith(fileName: "Default")!
        }
        
       return image
    }
    
    static func getPostPicture(userID: Int,postID: Int) -> UIImage {
        return UIImage().loadImageFromDiskWith(fileName: "\(userID)_POST_\(postID)")!
    }
    
    static func updateEmail(email: String) -> Bool {
        let loggedUserID = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
        
        if !AppUtility.isValidEmail(email){
            return false
        }
        
        return userDaoImp.updateMail(mailID: email, userID: loggedUserID)
    }
    
    static func updateGender(gender: String) -> Bool {
        let loggedUserID = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
        return userDaoImp.updateGender(gender: gender, userID: loggedUserID)
    }
    
    static func updateBirthday(birthday: String) -> Bool {
        let loggedUserID = UserDefaults.standard.integer(forKey: Constants.loggedUserFormat)
        return userDaoImp.updateAge(age: birthday, userID: loggedUserID)
    }
    
    static func validatePhoneNumber(phoneNumber: String) -> Result<Bool,PhoneNumberError> {
        
        let isValidPhoneNumber = isValidPhoneNumber(phoneNumber: phoneNumber)
        
        guard let _ = try? isValidPhoneNumber.get() else {
            return isValidPhoneNumber
        }
        
        let isPhoneNumberTaken = userDaoImp.isPhoneNumberAlreadyExist(phoneNumber: phoneNumber)
        return .success(!isPhoneNumberTaken)
    }
    
    static func validateUsername(username: String) -> Result<Bool,UsernameError> {
        
        let isValidUsername = AppUtility.isValidUsername(username: username.trimmingCharacters(in: .whitespacesAndNewlines))
        
        guard let _ = try? isValidUsername.get() else {
            return isValidUsername
        }
        

        let isUsernameTaken = userDaoImp.isUsernameAlreadyExist(username: username)
        return .success(!isUsernameTaken)
    }
    
    static func getCurrentTime() -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSS"
        return formatter.string(from: Date())
    }
    
    static func getDate(date: String) -> String {
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSS"
        let date = dateFormatter.date(from: date)!
        dateFormatter.dateFormat = "E dd MMM yyyy h:mm a"
        dateFormatter.locale = tempLocale
        let dateString = dateFormatter.string(from: date)

        return dateString
    }
}
