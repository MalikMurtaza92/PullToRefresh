//
//  ViewController.swift
//  CustomPullToRefress
//
//  Created by Murtaza Mehmood on 29/01/2023.
//

import UIKit

class ViewController: UIViewController,RefreshViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var refreshView: RefreshView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        refreshView = RefreshView(frame: CGRect(x: 0, y: -110, width: self.view.frame.width, height: 110),scroll: self.tableView)
        
        refreshView.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.addSubview(refreshView)
    }

    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        refreshView.scrollViewDidScroll(scrollView)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        refreshView.scrollViewWillEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
    
    func beginRefresh(_ refresh: RefreshView) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {[weak self] in
            self?.refreshView.endRefreshing()
        }
    }

}

//MARK: - TABLEVIEW DELEGATE DATASOURCE
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 25
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var config = cell.defaultContentConfiguration()
        config.text = "Index \(indexPath.row)"
        cell.contentConfiguration = config
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

