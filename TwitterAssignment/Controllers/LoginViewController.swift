//
//  ViewController.swift
//  TwitterAssignment
//
//  Created by Madhuri Patil on 08/06/21.
//

import UIKit
import TwitterKit

class LoginViewController: UIViewController {
    
    var loginViewModel: LoginViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Sign In
    @IBAction func clickedOnLogin(_ sender: UIButton) {
        loginViewModel = LoginViewModel()
        loginViewModel.signedInSuccessfully = {
            DispatchQueue.main.async {
                let userVC = self.storyboard?.instantiateViewController(withIdentifier: UserDetails) as! UserDetailsViewController
                userVC.user = self.loginViewModel.user!
                self.navigationController?.pushViewController(userVC, animated: false)
            }
        }
        
        loginViewModel.signedInFailed = {
            let alert = UIAlertController(title: "Error", message: self.loginViewModel.error, preferredStyle: UIAlertController.Style.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            DispatchQueue.main.async {
                // show the alert
                self.present(alert, animated: true, completion: nil)
            }
            
            
        }
    }
}

