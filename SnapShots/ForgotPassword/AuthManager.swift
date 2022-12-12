//
//  AuthManager.swift
//  SnapShots
//
//  Created by mahendran-14703 on 30/11/22.
//

import Foundation
import FirebaseAuth

class AuthManager {
    static let shared: AuthManager = {
       return AuthManager()
    }()
    
    private let auth = Auth.auth()
    private var verificationID: String?
    
    public func startAuth(phoneNumber: String,completion: @escaping (Bool) -> (Void)) {
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { [weak self] verificationID,error in
            
            guard let verificationID = verificationID,error == nil else {
                completion(false)
                return
            }
            
            self?.verificationID = verificationID
            completion(true)
            
        }
    }
    
    public func verifyOTP(code: String,completion: @escaping (Bool) -> (Void)) {
        guard let verificationID = verificationID else {
            completion(false)
            return
        }
        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: code
        )
        
        auth.signIn(with: credential) { result,error in
            guard result != nil,error == nil else{
                completion(false)
                return
            }
            completion(true)
        }
    }
}
//
//private func validateOTP(){
//        codeTextField.endEditing(true)
//        if let text=codeTextField.text, !text.isEmpty{
//            let code=text
//            
//            AuthManager.shared.verifyCode(smsCode: code){
//                [weak self] success in
//                guard success else{
//                    self?.stopSpinning()
//                    let ac=UIAlertController(title: "OTP", message: "Invalid OTP", preferredStyle: .alert)
//                    ac.addAction(UIAlertAction(title: "Retry", style: .default){
//                        action  in
//                        self?.sendOTP()
//                    })
//                    ac.addAction(UIAlertAction(title: "Cancel", style: .cancel){_ in
//                        self?.view.isUserInteractionEnabled = true
//                        self?.navigationController!.navigationBar.topItem!.rightBarButtonItem?.isEnabled = true
//                    })
//                    self?.present(ac, animated: false)
//                    return
//                }
//                DispatchQueue.main.async {
//                    self?.stopSpinning()
//                    guard let mobileNo=self?.mobileNotextFeild.text else{
//                        return
//                    }
//                    self?.mobileNo=mobileNo
//                    self?.displaySignUpAccountDetailsVC()
//                    self?.view.isUserInteractionEnabled = true
//                    self?.navigationController?.navigationBar.topItem?.rightBarButtonItem?.isEnabled = true
//                }
//            }
//        }
//    }
//private func displayOTPAlert(){
//        present(otpAlert, animated: false)
//    }
//
//    private lazy var codeTextField=UITextField()
//
//    private lazy var otpAlert:UIAlertController = {
//        codeTextField.text=""
//        codeTextField.textContentType = .oneTimeCode
//        codeTextField.delegate = self
//        let ac = UIAlertController(title: "Enter OTP", message: "Please enter 6 digit OTP", preferredStyle: .alert)
//
//        ac.addTextField{ [weak self] alertText in
//            alertText.keyboardType = .numberPad
//            alertText.placeholder = "6-Digit OTP"
//            alertText.maxLength=6
//            self?.codeTextField=alertText
//        }
//        ac.addAction(UIAlertAction(title: "Done", style: .default){
//            [weak self] _ in
//            if self?.codeTextField.text!.count == 6{
//                self?.startSpinning()
//                self?.validateOTP()
//            }
//            else if (self?.codeTextField.text!.isEmpty)!{
//                self?.displayOTPAlert()
//            }
//            else{
//                let otpResultAlert=UIAlertController(title: "OTP", message: "Invalid OTP", preferredStyle: .alert)
//                otpResultAlert.addAction(UIAlertAction(title: "Retry", style: .default){
//                    _ in
//                    self?.sendOTP()
//                })
//                otpResultAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel){_ in
//                    self?.view.isUserInteractionEnabled = true
//                    self?.navigationController?.navigationBar.topItem?.rightBarButtonItem?.isEnabled = true
//                })
//                self?.present(otpResultAlert,animated: false)
//            }
//        })
//
//        ac.addAction(UIAlertAction(title: "Resend OTP", style: .default){
//            [weak self] _ in
//            self?.sendOTP()
//        })
//
//        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel){_ in
//            self.view.isUserInteractionEnabled = true
//            self.navigationController?.navigationBar.topItem?.rightBarButtonItem?.isEnabled = true
//        })
//        return ac
//    }()
