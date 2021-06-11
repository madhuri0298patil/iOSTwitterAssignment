//
//  UserDetailsViewController.swift
//  TwitterAssignment
//
//  Created by Madhuri Patil on 09/06/21.
//

import UIKit
import Kingfisher
import TwitterKit

class UserDetailsViewController: UIViewController {
    
    var userDict = [String: Any]()
    var user: User?
    
    var userDetailsViewModel: UserDetailsViewModel?
    var friendList: FriendList?
    
    // MARK: - IBOutlets
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailAddressLabel: UILabel!
    
    @IBOutlet weak var followersButton: UIButton!
    @IBOutlet weak var followingButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var followersView: UIView!
    @IBOutlet weak var followingView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.setupUI()
        self.bindUserData()
        
        userDetailsViewModel = UserDetailsViewModel(user: self.user!)
        if let accessToken =  UserDefaults.standard.string(forKey: "accessToken"), let screenName = user?.screenName {
            userDetailsViewModel?.callGetFollowersListApi(accessToken: accessToken, screenName: screenName, completion: { (friendList, error) in
                if let data = friendList {
                    self.friendList = data
                } else if let error = error {
                    self.showAlert(message: error)
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            })
        }
    }
    
    // MARK: - IBAction
    @IBAction func clickOnFollowersOrFollowing(_ sender: UIButton) {
        if  let accessToken = UserDefaults.standard.string(forKey: "accessToken"), let screenName = user?.screenName {
            if sender.tag == 1 {
                followersView.backgroundColor = .systemTeal
                followingView.backgroundColor = .white
                userDetailsViewModel?.callGetFollowersListApi(accessToken: accessToken, screenName: screenName, completion: { (friendList, error) in
                    if let data = friendList {
                        self.friendList = data
                    } else if let error = error {
                        self.showAlert(message: error)
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                })
            } else {
                followingView.backgroundColor = .systemTeal
                followersView.backgroundColor = .white
                userDetailsViewModel?.callGetFriendListApi(accessToken: accessToken, screenName: screenName, completion: { (friendList, error) in
                    if let data = friendList {
                        self.friendList = data
                    } else if let error = error {
                        self.showAlert(message: error)
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                })
            }
        }
    }
    
    // MARK: - Show Alert
    
    func  showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        DispatchQueue.main.async {
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Set UI
    func setupUI() {
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
    }
    
    func  bindUserData() {
        var https = user?.profileUrl ?? ""
        if https.dropFirst(5) != "https" {
            https = "https" + https.dropFirst(4)
        }
        let url = URL(string: https)
        profileImage.kf.setImage(with: url)
        
        nameLabel.text = user?.name
        emailAddressLabel.text = user?.screenName
        
        followersButton.setTitle("Followers \(user?.followersCount ?? 0)", for: .normal)
        followingButton.setTitle("Following \(user?.friendsCount ?? 0)", for: .normal)
    }
    
    func getMoreData(indexPath: IndexPath) {
        if indexPath.row == (friendList?.users.count ?? 0) - 1 {
            if  let accessToken = UserDefaults.standard.string(forKey: "accessToken"), let nextCursor = friendList?.nextCursor {
                if nextCursor > 0 && self.friendList?.users.count != user?.friendsCount{
                    userDetailsViewModel?.callGetFriendListApi(accessToken: accessToken, screenName: user?.screenName ?? "", cursor: nextCursor, completion: { (friendList, error) in
                        if let data = friendList {
                            for user in data.users {
                                self.friendList?.users.append(user)
                            }
                            DispatchQueue.main.async {
                                self.tableView.reloadData()

                            }
                        } else if let error = error{
                            self.showAlert(message: error)
                        }
                    })
                }
            }
        }
    }
}

// MARK: - UITableViewController Datasource and Delegate methods
extension UserDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendList?.users.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FriendTableCell, for: indexPath) as! FriendTableViewCell
        let friend = self.friendList?.users[indexPath.row]
        
        let url = URL(string: friend?.profileImageUrl ?? "")
        cell.profileImage.kf.setImage(with: url)
        cell.nameLabel.text = friend?.name
        cell.userName.text = friend?.screenName
        
        getMoreData(indexPath: indexPath)
        
        return cell
    }
    
    
}
