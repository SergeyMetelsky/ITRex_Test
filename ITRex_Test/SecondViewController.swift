//
//  SecondViewController.swift
//  ITRex_Test
//
//  Created by Sergey on 3/29/21.
//

import UIKit
import Foundation

class SecondViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let allUsersURL: String = "https://api.github.com/users"
    private var newAllUsersArray: [UserGeneralInfo] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DownloadedFile.shared.getJsonFile(data: [UserGeneralInfo].self,at: allUsersURL) { [unowned self] json in
            guard let jsonArray = json else {
                DispatchQueue.main.async {
                    Alert.showAlert(on: self, with: "Внимание!", message: "Сервер не отвечает")
                }
                return
            }
            self.newAllUsersArray = jsonArray
        }
        
        self.title = "List of users"
        tableView.register(UINib(nibName: "OneUserTableViewCell", bundle: nil), forCellReuseIdentifier: "OneUserTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension SecondViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newAllUsersArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OneUserTableViewCell") as? OneUserTableViewCell else { return UITableViewCell() }
        cell.configureCell(userData: newAllUsersArray[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let destinationViewController = storyboard?.instantiateViewController(identifier: "UserData") as? UserDataViewController else { return }
        
        navigationController?.pushViewController(destinationViewController, animated: true)
        destinationViewController.userURL = newAllUsersArray[indexPath.row].url
    }
}

