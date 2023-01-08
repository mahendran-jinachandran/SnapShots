//
//  FaceRecognitionViewController.swift
//  SnapShots
//
//  Created by mahendran-14703 on 07/01/23.
//

import UIKit
import LocalAuthentication

class FaceRecognitionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        isFaceVerified()
    }
    
    func isFaceVerified() {
        
        let context = LAContext()
        var error: NSError? = nil
        
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            let reason = "Please authorize with touch id!"
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { [weak self] success, error in
                
                
                DispatchQueue.main.async {
                    guard success,error == nil else {
                        exit(1)
                    }
                    
                    guard let self = self else {
                        return
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.view.window?.windowScene?.keyWindow?.rootViewController = LaunchScreenVC()
                    }
                }
            }
        } else {
            
            let alert = UIAlertController(title: "Unavailable", message: "You cannot use this feature", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
            
            present(alert, animated: true)
            
        }
    }
}
