//
//  TableViewController.swift
//  M1
//
//  Created by Lim Liu on 11/24/21.
//

import UIKit


class TableViewController: UITableViewController {
    
    private var listDataSource: ListDataSource?
    private var prevEditStatus: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listDataSource = ListDataSource()
        tableView.dataSource = listDataSource
    
        setEditing(false, animated: false)
        navigationItem.setLeftBarButton(editButtonItem, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier{
            case "Add": print("Adding")
            case "Edit" :
                if let row = tableView.indexPathForSelectedRow?.row {
                    let question = ScoreModel.sc.blk[row]
                    let detailViewController = segue.destination as! CellDetailViewController
                    detailViewController.question = question
                    detailViewController.index = row
            }
            default:
                    preconditionFailure("Unexpected segue identifier.")
            }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if(prevEditStatus != editing && editing == false) {
            print("start")
            guard let viewControllers = self.tabBarController?.viewControllers else {print("failed"); return}
            for viewController in viewControllers {
                if let controller = viewController as? UINavigationController {
                    if let blkController = controller.viewControllers.first as? BLKViewController{
                        print(type(of: blkController))
                        ScoreModel.sc.reset()
                        
                        blkController.loadView()
                        blkController.viewDidLoad()
                    }
                    if let mcqController = controller.viewControllers.first as? MCQViewController{
                        print(type(of: mcqController))
                        
                        mcqController.loadView()
                        mcqController.viewDidLoad()
                    }
                }
            }
            print("done")
        }
        
        prevEditStatus = editing
    }
}


