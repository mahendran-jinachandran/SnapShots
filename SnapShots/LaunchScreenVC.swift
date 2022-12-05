//
//  LaunchScreenViewController.swift
//  SnapShots
//
//  Created by mahendran-14703 on 09/11/22.
//

import UIKit
import Lottie

class LaunchScreenVC: UIViewController {

    var launchScreenAnimation: LottieAnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        SQLiteDatabase.shared.getDatabaseReady()
        UIImage().saveImage(imageName: Constants.noDPSavingFormat, image: UIImage(named: "blankPhoto")!)
        AppUtility.lockOrientation(.portrait)
        
        launchScreenAnimation = .init(name: "SocialMediaLaunchScreen")
        launchScreenAnimation.frame = view.bounds
        launchScreenAnimation.contentMode = .scaleAspectFit
        launchScreenAnimation.loopMode = .playOnce
        launchScreenAnimation.animationSpeed = 2
        view.addSubview(launchScreenAnimation)
        
        launchScreenAnimation.play { isCompleted in
            if isCompleted {
                self.launchScreenAnimation.isHidden = true
                self.launchScreenAnimation.removeFromSuperview()
                
                AppUtility.lockOrientation(.all)
                self.setNeedsUpdateOfSupportedInterfaceOrientations()
            
                if UserDefaults.standard.integer(forKey: Constants.loggedUserFormat) != 0 {
                    self.view.window?.windowScene?.keyWindow?.rootViewController = HomePageViewController()
                } else {

                    let loginViewController = LoginVC()
                    let loginController = LoginControls()

                    loginController.setView(loginViewController)
                    loginViewController.setController(loginController)

                    self.navigationController?.pushViewController(loginViewController, animated: true)
                }
            }
        }
    }
}
