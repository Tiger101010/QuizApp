//
//  MCQViewController.swift
//  M1
//
//  Created by Lim Liu on 11/23/21.
//

import UIKit

class MCQViewController: UIViewController {
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet var submitBtn: UIButton!
    @IBOutlet var nextBtn: UIButton!
    
    var currentQuestionIndex: Int = 0
    var choice = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.dataSource = self
        pickerView.delegate  = self
        questionLabel.text = ScoreModel.sc.getMCQQues(index: currentQuestionIndex)
        choice = ScoreModel.sc.mcq[currentQuestionIndex].choices
        
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
        if currentQuestionIndex == ScoreModel.sc.mcq.count {
            currentQuestionIndex = 0
        }
        
        questionLabel.text = ScoreModel.sc.getMCQQues(index: currentQuestionIndex)
        choice = ScoreModel.sc.mcq[currentQuestionIndex].choices
        
        // reload pickerview
        pickerView.delegate  = self
        
        //reload correctness
        if(ScoreModel.sc.mcq[currentQuestionIndex].isAnswered) {
            submitBtn.isEnabled = false
            setResult(correct: ScoreModel.sc.mcq[currentQuestionIndex].isCorrect)
        } else {
            resultLabel.text = ""
            submitBtn.isEnabled = true
        }
    }
    
    @IBAction func submitAnswer(_ sender: UIButton) {
        let selectedRow = pickerView.selectedRow(inComponent: 0)
        setResult(correct: ScoreModel.sc.answerMCQ(index: currentQuestionIndex, answer: choice[selectedRow]))
        sender.isEnabled = false
    }
    

}

extension MCQViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return choice.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return choice[row]
    }
}
