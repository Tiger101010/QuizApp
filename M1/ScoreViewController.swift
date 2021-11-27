//
//  ScoreViewController.swift
//  M1
//
//  Created by Lim Liu on 11/23/21.
//
import UIKit

class ScoreViewController: UIViewController {
    @IBOutlet weak var scoreData: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadCorrectness()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reloadCorrectness()
    }
    
    func reloadCorrectness() {
        let correct : Int = ScoreModel.sc.correct
        let answered : Int = ScoreModel.sc.answered
        let wrong: Int = answered - correct
        let total : Int = ScoreModel.sc.total
        let data = String(correct) + " / " + String(total)
        scoreData.text = data
        
        if(wrong > correct) {
            self.view.backgroundColor = .systemRed
        } else if (wrong < correct) {
            self.view.backgroundColor = .systemGreen
        } else {
            self.view.backgroundColor = .systemBackground
        }
    }


}
