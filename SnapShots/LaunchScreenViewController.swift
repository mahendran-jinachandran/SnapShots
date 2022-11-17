//
//  LaunchScreenViewController.swift
//  SnapShots
//
//  Created by mahendran-14703 on 09/11/22.
//

import UIKit
import Lottie

class LaunchScreenViewController: UIViewController {

    var animationView: LottieAnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        AppUtility.lockOrientation(.portrait)
        // Do any additional setup after loading the view.
        
        animationView = .init(name: "SocialMediaLaunchScreen")
        animationView.frame = view.bounds
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce
        animationView.animationSpeed = 2
        view.addSubview(animationView)
        
        
        animationView.play { isCompleted in
            if isCompleted {
                self.animationView.isHidden = true
                
                if UserDefaults.standard.integer(forKey: "USER") != 0 {
                    self.navigationController?.pushViewController(HomePageViewController(), animated: true)
                } else {
                    
                    let loginViewController = LoginAssembler.assemble()
                    self.navigationController?.pushViewController(loginViewController, animated: true)
                }
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
