//
//  DrawViewController.swift
//  M1
//
//  Created by Lim Liu on 11/30/21.
//

import Foundation
import UIKit


class DrawViewController: UIViewController {
    @IBOutlet var drawView: DrawView!
    var index: Int = ScoreModel.sc.blk.count
    var question: Question = Question(q: "Question Here", ans: "Answer Here", choices: [""])
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let img: UIImage = drawView.takeScreenshot() else {return}
        print("index: " + String(index))
        print(ScoreModel.sc.blk.count)
        if(index == ScoreModel.sc.blk.count) {
            if question.question == "" {
                question.question = "Question Here"
            }
            ScoreModel.sc.addQuestion(q: question)
            print(ScoreModel.sc.blk.count)
        }
        ScoreModel.sc.blk[index].saveImg(img: img)
        ScoreModel.sc.blk[index].drawing = drawView.finishedLines
        ScoreModel.sc.save()
    }
}
