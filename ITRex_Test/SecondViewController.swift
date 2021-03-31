//
//  SecondViewController.swift
//  ITRex_Test
//
//  Created by Sergey on 3/29/21.
//

import UIKit

class SecondViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let allUsersURL: String = "https://api.github.com/users"
    var allUsersArray: [[String : Any]] = [[:]] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DownloadedFile.shared.getJsonFile(at: allUsersURL) { [weak self] json in
            guard let jsonArray = json as? [[String: Any]] else { return }
            self?.allUsersArray = jsonArray
        }
        
        self.title = "List of users"

        tableView.register(UINib(nibName: "OneUserTableViewCell", bundle: nil), forCellReuseIdentifier: "OneUserTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
}


extension SecondViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allUsersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OneUserTableViewCell") as? OneUserTableViewCell else { return UITableViewCell() }
        cell.configure(userData: allUsersArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let url = allUsersArray[indexPath.row]["url"] as? String else { return }
        guard let destinationViewController = storyboard?.instantiateViewController(identifier: "UserData") as? UserDataViewController else { return }
        
        navigationController?.pushViewController(destinationViewController, animated: true)
        destinationViewController.userURL = url
    }
}

