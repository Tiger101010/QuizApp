//
//  BLKViewController.swift
//  M1
//
//  Created by Lim Liu on 11/23/21.
//

import UIKit

class BLKViewController: UIViewController {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var imgView: UIImageView!
    
    var currentQuestionIndex: Int = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        answerField.delegate = self
        questionLabel.text = ScoreModel.sc.getBLKQues(index: currentQuestionIndex)
        imgView.image = ScoreModel.sc.blk[currentQuestionIndex].img
        answerField.text = "Your Answer Here"
        answerField.textColor = .systemGray
        
        resultLabel.text = ""
        submitBtn.isEnabled = true
        currentQuestionIndex = 0
    }

    
    func setResult(correct: Bool) {
        if(correct){
            resultLabel.text = "CORRECT"
            resultLabel.textColor = .systemGreen
        } else {
            resultLabel.text = "INCORRECT"
            resultLabel.textColor = .systemRed
        }
    }
    
    @IBAction func showNextQuestion(_ sender: UIButton) {
        currentQuestionIndex += 1
        if currentQuestionIndex == ScoreModel.sc.blk.count {
            currentQuestionIndex = 0
        }
        questionLabel.text = ScoreModel.sc.getBLKQues(index: currentQuestionIndex)
        imgView.image = ScoreModel.sc.blk[currentQuestionIndex].img
        answerField.text = "Your Answer Here"
        answerField.textColor = .systemGray
        
        if(ScoreModel.sc.blk[currentQuestionIndex].isAnswered) {
            submitBtn.isEnabled = false
            setResult(correct: ScoreModel.sc.blk[currentQuestionIndex].isCorrect)
        } else {
            resultLabel.text = ""
            submitBtn.isEnabled = true
        }
        
    }
    
    @IBAction func submitAnswer(_ sender: UIButton) {
        guard let userInput = answerField.text else { return }
        setResult(correct: ScoreModel.sc.answerBLK(index: currentQuestionIndex, answer: userInput))
        sender.isEnabled = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }


}

extension BLKViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
        answerField.textColor = .systemBlue
    }
}
